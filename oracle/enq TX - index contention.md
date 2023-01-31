关于enq: TX - index contention 等待的探讨与测试

最近生产库上遭遇短时间的enq: TX - index contention 等待，导致数据库hang住：
这个等待事件解释如下：
> Waits for TX in mode 4 also occur when a transaction inserting a row in an index has to wait for the end of an index block split being done by another transaction. This type of TX enqueue wait corresponds to the wait event enq: TX - index contention.

可以认为一个session在向一个索引块中执行插入时产生了索引块的split，而其它的session也要往该索引块中插入数据，此时，其它session必须要等待split完成，由此引发了该等待事件。

当事务修改索引中的数据时,而相关索引块没有足够的空间的时候,就会发生索引块的分割,在分割的过程中前台进程需要等待分割完毕才能继续操作。  
   
如果这个时候其他会话也要修改这个索引块的数据,那么将会出现索引块的竞争。(enq: TX- index contention).一般索引块的分割持有资源和释放非常短,并不会对数据库造成严重的影响。但是对表操作并发量很大的情况下可能导致严重的竞争。

1. 创建表及索引
```sql
-- 创建测试表
CREATE TABLE TEST(ID INT,NAME VARCHAR2(50),CREATED DATE);
-- 插入测试数据
BEGIN
  FOR I IN 10000 .. 20000 LOOP
    INSERT INTO TEST VALUES (I, RPAD(I, 50, 'X'), SYSDATE);
  END LOOP;
  COMMIT;
END;
/

-- 检查数据
select min(id), max(id) from test;

   MIN(ID)    MAX(ID)
---------- ----------
     10000	20000
-- 创建索引
CREATE INDEX IDX_TEST_01 ON TEST(ID,NAME) PCTFREE 0;
```
>首先创建了一个测试表TEST，并向里面插入了10001 条记录，ID 最小是10000，最大是20000。然后再TEST 的ID,NAME 列上创建了升序索引。此时索引中的数据将会先按照ID 排序，再按照NAME 列排序。注意我将PCTFREE 设置为0。这将会导致叶子节点块的空间都填满了，当然B 树索引的最右边的叶子块除外(可能填满也可能没填满)。准备工作完成。
2. 分析索引  
```sql
ANALYZE INDEX IDX_TEST_01 VALIDATE STRUCTURE;
SQL> set pages 999 lines 200;
SQL> SELECT HEIGHT,BLOCKS,NAME,PARTITION_NAME,LF_ROWS,DEL_LF_ROWS,LF_BLKS,PCT_USED FROM INDEX_STATS;

    HEIGHT     BLOCKS NAME
---------- ---------- ------------------------------------------------------------------------------------------
PARTITION_NAME										      LF_ROWS DEL_LF_ROWS    LF_BLKS   PCT_USED
------------------------------------------------------------------------------------------ ---------- ----------- ---------- ----------
	 2	   96 IDX_TEST_01
												10001		0	  85	     98
```
> 可以看到，这个索引有的二元高度为2,BLOCKS数为96(包括根块，枝块，叶子块及其一些开销块) ,叶子块记录数为10001，叶子块数为85，由于最后一个叶子块空间没有用完，因此  
PCT_USED 显示的并不是100%，而是98%。  
*PCT_USED   percent of space allocated in the b-tree that is being used   使用的空间百分比*  
3. 新增记录对索引的影响
```sql
INSERT INTO TEST VALUES(20001,RPAD(20001,50,'X'),SYSDATE);
commit;
```
> 由于20001 比表中的最大值20000 还大，因此数据将会插入到索引数的最右边的叶子节点。由于索引树的最后一个叶子节点还有空闲空间容纳这条记录，因此数据能顺利插入。  
索引的叶子块数也不会发生改变。  
```sql
SQL> ANALYZE INDEX IDX_TEST_01 VALIDATE STRUCTURE;

索引已分析

SQL> SELECT HEIGHT,BLOCKS,NAME,PARTITION_NAME,LF_ROWS,DEL_LF_ROWS,LF_BLKS,PCT_USED FROM INDEX_STATS;

    HEIGHT     BLOCKS NAME
---------- ---------- ------------------------------------------------------------------------------------------
PARTITION_NAME										      LF_ROWS DEL_LF_ROWS    LF_BLKS   PCT_USED
------------------------------------------------------------------------------------------ ---------- ----------- ---------- ----------
	 2	   96 IDX_TEST_01
												10002		0	  85	     98
```
> 可以看到索引的叶子块中的记录数已经为10002 增加了1，但是叶子块数却还是85，没有改变。  
> 如果我们执行如下的SQL： INSERT INTO TEST VALUES(9999,RPAD(9999,50,'X'),SYSDATE);
由于9999 比表中的ID 最小值10000 还小，因此数据将会插入到索引数的最左边的叶子节点。 而此时索引数的最左边的叶子节点已经没有空闲空间容纳这条记录，数据无法插入。ORACLE 将会在后台进行索引块的5-5 分割，将大约一半的数据放到新的索引块中，原来的数据继续留在索引的块中。然后将9999 的记录插入到相应的块中。
```sql
SQL> INSERT INTO TEST VALUES(9999,RPAD(9999,50,'X'),SYSDATE);
SQL> commit;
SQL> ANALYZE INDEX IDX_TEST_01 VALIDATE STRUCTURE;
SQL> SELECT HEIGHT,BLOCKS,NAME,PARTITION_NAME,LF_ROWS,DEL_LF_ROWS,LF_BLKS,PCT_USED FROM INDEX_STATS;

    HEIGHT     BLOCKS NAME
---------- ---------- ------------------------------------------------------------------------------------------
PARTITION_NAME										      LF_ROWS DEL_LF_ROWS    LF_BLKS   PCT_USED
------------------------------------------------------------------------------------------ ---------- ----------- ---------- ----------
	 2	   96 IDX_TEST_01
												10003		0	  86	     97
```
> 可以看到，索引的叶子块中的记录数已经为10003 增加了1，并且叶子块数已经增加到了86，这就是索引块的分割导致一个数据块一分为二。  
--如果此时继续插入下面的SQL 语句,将会发生什么呢？  INSERT INTO TEST VALUES(9998,RPAD(9998,50,'X'),SYSDATE);  
 由于最左边的块刚刚已经发生过分割，1 个块一分为二。因此现在左边的2个块大约还有一半的空闲空间。因此容纳记录9998 有足够的空间了
```sql
SQL> INSERT INTO TEST VALUES(9998,RPAD(9998,50,'X'),SYSDATE);
SQL> commit;
SQL> ANALYZE INDEX IDX_TEST_01 VALIDATE STRUCTURE; 
SQL> SELECT HEIGHT,BLOCKS,NAME,PARTITION_NAME,LF_ROWS,DEL_LF_ROWS,LF_BLKS,PCT_USED FROM INDEX_STATS;

    HEIGHT     BLOCKS NAME
---------- ---------- ------------------------------------------------------------------------------------------
PARTITION_NAME										      LF_ROWS DEL_LF_ROWS    LF_BLKS   PCT_USED
------------------------------------------------------------------------------------------ ---------- ----------- ---------- ----------
	 2	   96 IDX_TEST_01
												10004		0	  86	     97
```
> 可以看到，记录增加，叶子块却没有增加。  
> 如果插入下面的SQL：INSERT INTO TEST VALUES(14998,RPAD(14998,50,'X'),SYSDATE);  
 根据前面的分析，及其目前索引块的空闲情况，此时也会进行索引块的分割。
```sql
SQL> INSERT INTO TEST VALUES(14998,RPAD(14998,50,'X'),SYSDATE); 
SQL> commit;
SQL> ANALYZE INDEX IDX_TEST_01 VALIDATE STRUCTURE;
SQL> SELECT HEIGHT,BLOCKS,NAME,PARTITION_NAME,LF_ROWS,DEL_LF_ROWS,LF_BLKS,PCT_USED FROM INDEX_STATS;

    HEIGHT     BLOCKS NAME
---------- ---------- ------------------------------------------------------------------------------------------
PARTITION_NAME										      LF_ROWS DEL_LF_ROWS    LF_BLKS   PCT_USED
------------------------------------------------------------------------------------------ ---------- ----------- ---------- ----------
	 2	   96 IDX_TEST_01
												10005		0	  87	     96
```
可以看到索引块又发生分割了。
```sql
-- 通过下面的SQL 语句查询索引块的分裂数。
SELECT B.NAME, A.VALUE  
    FROM v$SESSTAT A, V$STATNAME B  
     WHERE A.STATISTIC# = B.STATISTIC#  
    AND B.NAME LIKE '%split%'  
    AND A.SID = 30;
```
***注意：UPDATE 也会造成索引块的分割，对于索引来说 UPDATE 实际上是一条DELETE 加上一条 INSERT语句。***
***
4. 并发引起的enq: TX - index contention  
无论何时，只要索引块中没有空间容纳新来的数据时，就会发生索引块的分割。 如果在分割的过程中，其他进程也同时要操作相应的索引块，那么其他进程就会处于 enq:TX - index contention等待中。
为了演示的方便，重建创建一个稍微大一点的表
```sql
SQL> DROP TABLE TEST;

表已删除。

SQL> CREATE TABLE TEST(ID NUMBER,NAME CHAR(10), CREATED DATE,CONTENTS VARCHAR2(4000)); 

表已创建。

SQL> CREATE INDEX IDX_TEST_01 ON TEST(CREATED,CONTENTS);

索引已创建。
```

```sql
--分两个窗口进行：session 1：26 session：33
先统计一下这2 个会话有关索引分割的统计信息如下：
 
SELECT A.SID, B.NAME, A.VALUE
  FROM v$SESSTAT A, V$STATNAME B
 WHERE A.STATISTIC# = B.STATISTIC#
   AND B.NAME LIKE '%split%'
   AND A.SID IN (26,33)
 ORDER BY 1, 2;

        SID NAME                                                                  VALUE
---------- ---------------------------------------------------------------- ----------
        26 branch node splits                                                        0
        26 leaf node 90-10 splits                                                    0
        26 leaf node splits                                                          0
        26 queue splits                                                              0
        26 root node splits                                                          0
        33 branch node splits                                                        0
        33 leaf node 90-10 splits                                                    0
        33 leaf node splits                                                          0
        33 queue splits                                                              0
        33 root node splits                                                          0

10 rows selected.


--接下来同时在session 1和session 2向表中插入记录，且在插入数据的同时再开一个窗口监控等待事件

BEGIN
  FOR I IN 0 .. 100000 LOOP
    INSERT INTO TEST VALUES (I, TO_CHAR(I), SYSDATE, RPAD('X', 2000, 'X'));
  END LOOP;
END;
/
 
session 1： 26
SQL> SELECT USERENV('SID') FROM DUAL;  

USERENV('SID')
--------------
            26

SQL> BEGINSQL> BEGIN
  2    FOR I IN 0 .. 60000 LOOP
  3      INSERT INTO TEST VALUES (I, TO_CHAR(I), SYSDATE, RPAD('X', 2000, 'X'));
  4    END LOOP;
  5  END;
  6  /


session 2：33

SQL> SELECT USERENV('SID') FROM DUAL;  

USERENV('SID')
--------------
             33

SQL> BEGIN
  2    FOR I IN 0 .. 60000 LOOP
  3      INSERT INTO TEST VALUES (I, TO_CHAR(I), SYSDATE, RPAD('X', 2000, 'X'));
  4    END LOOP;
  5  END;
  6  /


--插入前查询等待事件如下：
SQL>  set lines 200
SQL>  col event for a30
SQL>  col machine for a15
SQL>  select inst_id,sid,sql_id,status,machine,event,blocking_session,wait_time,state,seconds_in_wait from gv$session where event like 'enq: TX - index contention';

no rows selected

SQL>


--插入期间查询等待事件：
SQL>  set lines 200
SQL>  col event for a30
SQL>  col machine for a15
SQL>  select inst_id,sid,sql_id,status,machine,event,blocking_session,wait_time,state,seconds_in_wait from gv$session where event like 'enq: TX - index contention';

no rows selected

SQL> /

no rows selected

SQL> /

no rows selected

SQL> /

no rows selected

SQL> /
   INST_ID        SID SQL_ID        STATUS   MACHINE         EVENT                          BLOCKING_SESSION  WAIT_TIME STATE               SECONDS_IN_WAIT -------------------------------- ---------------- ---------- ------------------- -------------------------------------------------------------------------------
         1         33 41vqxgnub01q1 ACTIVE   wang            enq: TX - index contention                   26          0 WAITING                           0

SQL> select sql_text from v$sql where sql_id='41vqxgnub01q1';

SQL_TEXT
-------------------------------------------------------------------------------------------------------
INSERT INTO TEST VALUES (:B1 , TO_CHAR(:B1 ), SYSDATE, RPAD('X', 2000, 'X'))

SQL>
```

```sql
关于这个等待事件描述如下：  
enq: TX - index contention  
Waits for TX in mode 4 also occur when a transaction inserting a row in an index has to wait for the end of an index block split being done by another transaction. This type of TX enqueue wait corresponds to the wait event enq: TX - index contention.  
 注意：如果索引块中没有空间分配事务槽还会引发enq: TX - allocate ITL entry 的竞争。  
   
SQL> l
  1  SELECT A.SID, B.NAME, A.VALUE
  2    FROM v$SESSTAT A, V$STATNAME B
  3   WHERE A.STATISTIC# = B.STATISTIC#
  4     AND B.NAME LIKE '%split%'
  5     AND A.SID IN (26,33)
  6*  ORDER BY 1, 2
SQL> /

       SID NAME                                                                  VALUE
---------- ---------------------------------------------------------------- ----------
        26 branch node splits                                                     7334
        26 leaf node 90-10 splits                                                19705
        26 leaf node splits                                                      20142
        26 queue splits                                                              0
        26 root node splits                                                          6
        33 branch node splits                                                     7414
        33 leaf node 90-10 splits                                                19918
        33 leaf node splits                                                      20149
        33 queue splits                                                              0
        33 root node splits                                                          2

10 rows selected.

查看结果看到了大量的分裂 
```

> 从抓取的ash报告来看，产生等待的是一条insert语句，而该sql要插入数据的表是一个每天需要进行频繁delete的表，该等待事件的产生与频繁的大批量delete是具有紧密联系的。厂商最后给出的建议是定期对该表进行rebuild，并加大索引的pctfree。

enq: TX - index contention
 
Most probable reasons are
o Indexes on the tables which are being accessed heavily from the application. o Indexes on table columns which are monotonically growing. In other words, most of the index insertions occur only on the right edge of an index.
o Large data purge has been performed, followed by high concurrent insert（大批量并发的insert）

When running an OLTP systems, it is possible to see high TX enqueue contention on index associated with tables, which are having high concurrency from the application.  This usually happens when the application performs lot of INSERTs and DELETEs concurrently. For RAC system, the concurrent INSERTs and DELETEs could happen from all the instances .

The reason for this is the index block splits while inserting a new row into the index. The transactions will have to wait for TX lock in mode 4, until the session that is doing the block splits completes the operations.（索引块的分裂）
A session will initiate a index block split, when it can'??t find space in an index block where it needs to insert a new row. Before starting the split, it would clean out all the keys in the block to check whether there is enough sufficient space in the block.deleted

Splitter has to do the following activities:

    o          Allocate a new block.
    o          Copy a percentage of rows to the new buffer.
    o          Add the new buffer to the index structure and commit the operation.

In RAC environments, this could be an expensive operation, due to the global cache operations included. The impact will be more if the split is happening at a branch or root block level.

Solutions:解决方法
a) Rebuild the index  as reverse key indexes or hash partition the indexes which are listed in the Segments by Row Lock Waits' of the AWR reports  重建索引
b) Consider increasing the CACHE size of the sequences  增大cache值
c) Rebuild or shrink associated index after huge amount of data purge   大批量的数据改动后 索引的收缩或重建
d) Increase PCT_FREE for the index 增大索引块的PCT_FREE