Oracle drop column 会造成表级别的TM-contention, **阻塞该表的DML操作**

对于大表的操作删除字段，务必谨慎小心，能不删尽量不删。


## 场景一：直接drop column
运行业务模拟程序，开始正常插入日志，然后删除大表的字段。

```sql
alter table t_test_col drop column vard;
```

影响范围：

1. drop column操作耗时30多秒。

2. <u>insert 语句在drop column完成之前无法执行，等待事件为enq:TM-contention。</u>

3. select不受影响。


## 场景二：先set unused然后再drop

```sql
alter table t_test_col set unused column vard;
alter table t_test_col drop unused columns;
```

set unused仅更新表的数据字典，先将字段置为不可用状态，drop unused操作时才更新数据内容。

影响范围：

与场景一完全相同。

注意上述两种方式还会遇到一个非常麻烦的问题，在执行drop column的过程中，需要修改每一行数据，运行时间往往特别长，这会消耗大量的undo表空间，
如果表特别大，操作时间足够长，undo表空间会全部耗尽。为了解决这个问题，有了第三种场景。


## 场景三：先set unused然后再drop column checkpoint
```sql
alter table t_test_col set unused column vard;
alter table t_test_col drop unused columns checkpoint 1000;
```

drop unused columns checkpoint操作是每删除多少条记录，做一次提交，避免UNDO爆掉。
这是一个好的解决思路，但是它带来的风险也是非常大的。这个操作在间隔(interval)分区上执行会命中
BUG：20598042，ALTER TABLE DROP COLUMN … CHECKPOINT on an INTERVAL PARTITIONED table fails with ORA-600 [17016]。

执行结果是：

1. drop column checkpoint操作会报ORA-600[17016]错误。

2. 插入和查询操作，在drop过程以及drop报错之后，均抛出ORA-12986异常。

3. 在打补丁修复bug之前，这个表将无法正常使用。

换成普通分区表，先set unused然后再drop column checkpoint，

```sql
alter table t_test_col_2 set unused column vard;
alter table t_test_col_2 drop unused columns checkpoint 1000;
```

影响范围：

1. <u>insert 和select在drop column操作完成之前均无法执行。</u>

2. 等待事件为library cache lock。


## 场景四: 使用DBMS_REDEFINITION包删除字段
```sql
create table T_TEST_COL_3
as select ids,dates,vara,varb,varc,vard  from t_test_col_2;

create table T_TEST_COL_mid
(
  ids   NUMBER,
  dates DATE,
  vara  VARCHAR2(2000),
  varb  VARCHAR2(2000),
  varc  VARCHAR2(2000)
);

BEGIN
   DBMS_REDEFINITION.CAN_REDEF_TABLE('ENMOTEST','T_TEST_COL_3', DBMS_REDEFINITION.CONS_USE_ROWID);
END;
/
BEGIN
   DBMS_REDEFINITION.START_REDEF_TABLE(
         uname => 'ENMOTEST',
         orig_table => 'T_TEST_COL_3',
         int_table => 'T_TEST_COL_MID',
         col_mapping => 'IDS IDS, DATES DATES, VARA VARA,VARB VARB,VARC VARC',
         options_flag => DBMS_REDEFINITION.CONS_USE_ROWID);
END;
/

DECLARE
    error_count pls_integer := 0;
BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS('ENMOTEST',
                   'T_TEST_COL_3',
                   'T_TEST_COL_MID',
                    dbms_redefinition.cons_orig_params ,
                   TRUE,
                   TRUE,
                   TRUE,
                   FALSE,
                   error_count);
    DBMS_OUTPUT.PUT_LINE('errors := ' || TO_CHAR(error_count));
END;
/
BEGIN dbms_redefinition.finish_redef_table('ENMOTEST','T_TEST_COL_3','T_TEST_COL_MID');  END;
DROP TABLE T_TEST_COL_MID;
```

影响范围：

1. <u>中间表的大小与原表相当(需要耗费很大的空间及产生大量归档日志)。</u>

2. 先阻塞insert，再阻塞select，时间一秒多，等待事件中能看到只有非常短暂的TM锁表操作。


## 场景五: 中断测试
在场景一到场景三的执行过程中，突然中断会话，观察中断后的情况.

1. 直接drop column，中断后表可正常使用，字段仍然还在

2. 先set unused，再drop unused columns，字段set之后就查不到了，中断后，表可正常使用

3. *先set unused，再drop unused columns checkpoint，中断后，insert和select均报ORA-12986错误，提示必须执行alter table drop columns continue操作，其他操作不允许。*


## 测试总结:
1. 在生产环境执行drop column是很危险的，如果是重要的或数据量很大的表，最好申请计划停机时间窗口进行维护。

2. drop unused columns checkpoint虽然能解决回滚段占用过高的问题，但是会带来不可回退的风险。
   如果是非常大的表，只能让他跑完，但在跑的过程中，所有操作无法进行，这将会造成非常长时间的业务中断。

3. 业务压力不大的系统可采用dbms_redefinition在线重定义操作，只会在finish那一步出现很短时间的阻塞。
但是其底层是用的物化试图，进行增量刷新，非常消耗性能，也不推荐这种方式。

4. 间隔分区上执行drop unused columns checkpoint存在bug，一旦触发，同样会带来非常大的停机风险。


## 结论：
虽然Oracle能很快让你添加字段，却无法让你快速删除字段。上述4种方式，删除字段均带来了非常大的影响，且不可控！