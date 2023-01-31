从9i开始oracle就推出了logminer--日志挖掘技术，logminer可直接应用于redolog内容的解析、也被间接用于Flashback transaction、SQL apply in logical standby database等场合。
在对非本库生成的redolog进行解析时，需要用到logminer dictionary，典型的例子：搭建logical standby database的过程中有一个步骤是build logminer dictionary。因为primary db和logical standby db属于完全不同的两个库，要使standby能够从primary生成的redolog里准确解析出可执行的sql语句，必须把primary db里包含对象名称信息的数据字典提供给standby db，提供的形式有基于文件和基于redolog两种，前者是将数据字典信息直接导出到一个文本文件，后者将字典信息输出到online redolog，简单的说logminer dictionary就是包含对象名称与对象ID间映射关系的数据字典表的子集，起到了将对象编号翻译成对象名称的作用。如果没有logminer dictionary我们解析出来的sql里将会充斥了各种晦涩难懂的数字和代号。
我们以解析一个归档日志里的SQL语句为例，体验一下logminer dictionary在其中所发挥的作用


# 如果要解析的redolog是本库产生的，那么不需要build logminer dictionary，使用本库的数据字典就行

/////////////////////  
// 如果要解析的redolog是本库产生的，那么不需要build logminer dictionary，使用本库的数据字典就行
/////////////////////  
假设/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc是tstdb1库生成的一个归档日志文件，我们要在tstdb1库上对这个归档进行解析，即在本库进行logminer，无需额外build logminer dictionary，使用本库现成的数据字典即可

**在archivelog产生的源库tstdb1上执行logminer**

```
SQL> show parameter db_name


NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_name                              string      tstdb1


exec dbms_logmnr.add_logfile(logfilename=>'/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


-- 因为是本库所以使用DICT_FROM_ONLINE_CATALOG从数据字典里检索相关信息即可
exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);


***从Archivelog里搜出的语句包含具体表名和列名，这些sql已经是经过翻译的，因此是可执行的
set linesize 120 pagesize 140
SQL> select seg_name,sql_redo,sql_undo from V$LOGMNR_CONTENTS where seg_name='T0729_2';


SEG_NAME
------------------------------------------------------------------------------------------------------------------------
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
T0729_2
create table scott.t0729_2 (id number,c2 varchar2(10)) tablespace omftbs1;




T0729_2
insert into "SCOTT"."T0729_2"("ID","C2") values ('1','a');
delete from "SCOTT"."T0729_2" where "ID" = '1' and "C2" = 'a' and ROWID = 'AAAKHHAAJAAAACVAAA';


T0729_2
insert into "SCOTT"."T0729_2"("ID","C2") values ('2','b');
delete from "SCOTT"."T0729_2" where "ID" = '2' and "C2" = 'b' and ROWID = 'AAAKHHAAJAAAACVAAB';


SQL> select * from V$LOGMNR_DICTIONARY;    <---没有build logminer dictionary所以没有记录


no rows selected


set numwidth 16 linesize 120
col filename format a60
select low_scn,filename from V$LOGMNR_LOGS;  <---正在被挖掘的日志
         LOW_SCN FILENAME
---------------- ------------------------------------------------------------
  12723365353557 /oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8o
                 Un0kl_.arc


SQL> set numwidth 16
SQL> select start_scn,options from V$LOGMNR_PARAMETERS;   <---执行DBMS_LOGMNR.START_LOGMNR时指定的参数


       START_SCN          OPTIONS
---------------- ----------------
  12723365353557               16    <--16表示以本机的data dictionary作为logminer dictionary
```

options取值及含义如下：  
NO_DICT_RESET_ONSELECT    CONSTANT BINARY_INTEGER := 1;  
COMMITTED_DATA_ONLY       CONSTANT BINARY_INTEGER := 2;  
SKIP_CORRUPTION           CONSTANT BINARY_INTEGER := 4;  
DDL_DICT_TRACKING         CONSTANT BINARY_INTEGER := 8;  
DICT_FROM_ONLINE_CATALOG  CONSTANT BINARY_INTEGER := 16;  
DICT_FROM_REDO_LOGS       CONSTANT BINARY_INTEGER := 32;  
NO_SQL_DELIMITER          CONSTANT BINARY_INTEGER := 64;  
PRINT_PRETTY_SQL          CONSTANT BINARY_INTEGER := 512;  
CONTINUOUS_MINE           CONSTANT BINARY_INTEGER := 1024;  
NO_ROWID_IN_STMT          CONSTANT BINARY_INTEGER := 2048;  
STRING_LITERALS_IN_STMT   CONSTANT BINARY_INTEGER := 4096;     
默认值为0


# 要解析来自于其它库的redolog，在没有logminer dictionary的情况下，无法解析出准确的、可执行的SQL语句

/////////////////////  
// 要解析来自于其它库的redolog，在没有logminer dictionary的情况下，无法解析出准确的、可执行的SQL语句  
/////////////////////  

在shzw库上解析由tstdb1库产生的archivelog:/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc
将tstdb1库产生的archivelog复制到目标库shzw：

```
scp /oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc oracle@10.10.141.207:/oradata04/


SQL> show parameter db_name


NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_name                              string      shzw


-- 没有build logminer dictionary的情况下在shzw库上解析tstdb1库redolog所得到的sql语句没有具体的表名和列名
exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>0);


-- 以seg_name为条件只搜到create table语句，ddl语句在没有logminer dictionary的情况下能够被正确解析出
set linesize 120 pagesize 140
SQL> select seg_name,sql_redo,sql_undo from V$LOGMNR_CONTENTS where seg_name='T0729_2';


SEG_NAME
------------------------------------------------------------------------------------------------------------------------
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
T0729_2
create table scott.t0729_2 (id number,c2 varchar2(10)) tablespace omftbs1;



***改以rowid为查找条件，DML没有logminer dictionary的情况下无法得到其真实的名称
select sql_redo,sql_undo from V$LOGMNR_CONTENTS where sql_redo like '%insert into%';
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
。。。。。省略部分输出


insert into "UNKNOWN"."OBJ# 41415"("COL 1","COL 2") values (HEXTORAW('c102'),HEXTORAW('61'));
delete from "UNKNOWN"."OBJ# 41415" where "COL 1" = HEXTORAW('c102') and "COL 2" = HEXTORAW('61') and ROWID = 'AAAKHHAAJA
AAACVAAA';


insert into "UNKNOWN"."OBJ# 41415"("COL 1","COL 2") values (HEXTORAW('c103'),HEXTORAW('62'));
delete from "UNKNOWN"."OBJ# 41415" where "COL 1" = HEXTORAW('c103') and "COL 2" = HEXTORAW('62') and ROWID = 'AAAKHHAAJA
AAACVAAB';

10 rows selected.
```

obj#41415正是t0729_2表在tstdb1库上的object_id，insert语句里的列名也被col 1、col 2替代了，插入的数值1被替换成了HEXTORAW('c102')，字符'a'被替换成了HEXTORAW('61')，可见没有logminer dictionary除了ddl语句能完整显示，dml语句根本不具备可读性。引入logminer dictionary的目的就是能够以可读、可执行的形式显示出这些SQL语句。


# 构造logminer dictionary的两种方式

/////////////////////
// 构造logminer dictionary的两种方式
/////////////////////
logminer dictionary可以存在于文本文件，也可以存在于redolog file，依然以shzw库上解析tstdb1库生成的redolog作为例子

## 将logminer dictionary输出到文本文件

在源库tstdb1上build logminer dictionary到某个文件里
```
alter system set utl_file_dir='/oradata01' scope=spfile;

startup force

exec dbms_logmnr_d.build(dictionary_filename=>'tstdb1.dic',dictionary_location=>'/oradata01',options=>dbms_logmnr_d.STORE_IN_FLAT_FILE);

把dictionary文件传送到执行解析动作的shzw库
scp /oradata01/tstdb1.dic oracle@10.10.141.207:/oradata04/


在shzw库上再次进行START_LOGMNR操作，这次看到了完整的表名和列名
exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);

exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'/oradata04/tstdb1.dic',Options=>0);   <---DictFileName指定了dictionary文件的路径

set linesize 120 pagesize 140
select sql_redo,sql_undo from V$LOGMNR_CONTENTS


SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
。。。。省略部分输出


insert into "SCOTT"."T0729_2"("ID","C2") values ('1','a');
delete from "SCOTT"."T0729_2" where "ID" = '1' and "C2" = 'a' and ROWID = 'AAAKHHAAJAAAACVAAA';


insert into "SCOTT"."T0729_2"("ID","C2") values ('2','b');
delete from "SCOTT"."T0729_2" where "ID" = '2' and "C2" = 'b' and ROWID = 'AAAKHHAAJAAAACVAAB';


commit;
```

我们来看一下logminer dictionary文件里包含哪些内容，以上面生成的tstdb1.dic文件为例，tstdb1.dic是一个文本文件，我们找出其中与t0729_2表有关的记录
---记录对象信息的OBJ$表
INSERT_INTO OBJ$_TABLE VALUES (41415,41415,36,'T0729_2',1,'',2,to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),1,'','',0,,6,1,36,'','', );


---记录用户信息的USER$表
INSERT_INTO USER$_TABLE VALUES (36,'SCOTT',1,'5665B0DA34DDB8C5',4,3,to_date('12/09/2014 15:17:00', 'MM/DD/YYYY HH24:MI:SS'),to_date('06/29/2015 16:17:59', 'MM/DD/YYYY HH24:MI:SS'),to_date('06/30/2015 15:23:38', 'MM/DD/YYYY HH24:MI:SS'),,0,'',1,,,0,0,'DEFAULT_CONSUMER_GROUP','',0,,,'S:23DCE06BB6C5408756DFE8FE2C307CC5E5BCA05B9BE6C06AE53FA9AAD21C','', );


---记录列信息的COL$表
INSERT_INTO COL$_TABLE VALUES (41415,1,1,22,0,'ID',2,22,0,,,0,,'',1,0,0,0,0,0,0,'','', );
INSERT_INTO COL$_TABLE VALUES (41415,2,2,10,0,'C2',1,10,0,,,0,,'',2,0,852,1,0,0,10,'','', );


---记录表信息的TAB$表
INSERT_INTO TAB$_TABLE VALUES (41415,41415,41,9,146,,,2,,10,40,1,255,1073741825,'--------------------------------------',,,,,,,,,,,,,2,2,536870912,0,0,736,,,'','',to_date('07/29/2015 06:11:23', 'MM/DD/YYYY HH24:MI:SS'));


该有的信息都有了，在目标库解析archivelog的时候参考上面的四组信息至少可以进行如下转换
"OBJ# 41415"=>T0729_2
"COL 1"=>'ID'
"COL 2"=>'C2'


至于table_owner如何从"UNKNOWN"=>SCOTT，猜测原理和上面一样，archived log内部也准确记录了userid，只不过没有直接显示出user_id而是用UNKNOWN替代了。


为了避免logminer字典文件被误执行，dictionary 文件里故意用insert_into替代insert，并且在每个表名后增加了_TABLE，比如COL$被表示成COL$_TABLE。
因此logminer dictionary里的语句稍加修改后就能在数据库上执行，但要注意这些insert语句如果在目标库上执行(不同于生成redolog file的数据库)，即使执行成功，也不能在目标库上使用DICT_FROM_ONLINE_CATALOG方式解析redolog里的sql语句，如果这样做会受到如下报错：
SQL> exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);


*
ERROR at line 1:
ORA-01295: DB_ID mismatch between dictionary USE_ONLINE_CATALOG and logfiles
ORA-06512: at "SYS.DBMS_LOGMNR", line 58
ORA-06512: at line 1


因为Oracle在使用online catalog也就是本机的数据字典解析时，会检测被解析的redolog file里的dbid和目标库的dbid是否一致，如果不一致就会报出上面的错误。


文本方式保存logminer dictionary的可移植性较强，但存在的问题是dictionary file可能被恶意篡改，比如我们将tstdb1.dic里的T0729_2批量替换成AAAA
那么解析出来的SQL里显示的就是'AAAA'


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'/oradata04/tstdb1.dic',Options=>0);   <---DictFileName指定了dictionary文件的路径


set linesize 120
set linesize 120 pagesize 140
select sql_redo,sql_undo from V$LOGMNR_CONTENTS;
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
。。。。省略部分输出


insert into "SCOTT"."AAAA"("ID","C2") values ('1','a');
delete from "SCOTT"."AAAA" where "ID" = '1' and "C2" = 'a' and ROWID = 'AAAKHHAAJAAAACVAAA';


insert into "SCOTT"."AAAA"("ID","C2") values ('2','b');
delete from "SCOTT"."AAAA" where "ID" = '2' and "C2" = 'b' and ROWID = 'AAAKHHAAJAAAACVAAB';


commit;


如果我们选择redolog file作为logminer dictionary的载体，就不存在这个问题


(2)把logminer dictionary构建在redolog file的情况
###在tstdb1库上构造logminer dictionary
***tstdb1库上手工切换一个logfile后，current redolog变为了Sequence#  142
alter system switch logfile;


SYS@tstdb1-SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     140
Next log sequence to archive   142
Current log sequence           142
SYS@tstdb1-SQL> 


***执行update
update t0729_3 set username='NEWUSER1' where user_id<30;
commit;


***将logminer dictionary build到redolog里
SYS@tstdb1-SQL> exec DBMS_LOGMNR_D.BUILD(dictionary_filename=>NULL,dictionary_location=>NULL,options=>dbms_logmnr_d.STORE_IN_REDO_LOGS);


PL/SQL procedure successfully completed.


***build完成后发现当前的redolog sequence已经前进到了144，说明142、143已经被归档
SYS@tstdb1-SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     142
Next log sequence to archive   144
Current log sequence           144


通过v$archivelog可以看出哪些归档日志包含logminer dictionary
col name format a90
set linesize 150
select name,ARCHIVED,DICTIONARY_BEGIN,DICTIONARY_END from v$archived_log where name like '%o1_mf_1_14%_.arc';


NAME                                                                                       ARC DIC DIC
------------------------------------------------------------------------------------------ --- --- ---
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_140_1lGtfKCjT_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_141_1lHQRCI8J_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_142_1lHQpRoEe_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_143_1lHQpcQR8_.arc                     YES YES YES    <---sequence# 143含有logminer dictionary


###在shzw库上解析出tstdb1库上执行的update语句
***先把o1_mf_1_142_1lHQpRoEe_arc、.o1_mf_1_143_1lHQpcQR8_.arc两个archivelog复制到shzw库所在主机
scp /oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_142_1lHQpRoEe_.arc oracle@10.10.141.207:/oradata04/
scp /oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_143_1lHQpcQR8_.arc oracle@10.10.141.207:/oradata04/


刚才我们的update操作生成在sequence# 142这个archivelog里，但是如果要正确解析出这条update语句，必须将sequence# 143也加入进来


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_142_1lHQpRoEe_.arc',options=>DBMS_LOGMNR.NEW);


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_143_1lHQpcQR8_.arc',options=>DBMS_LOGMNR.ADDFILE);   <---加入sequence# 143


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>DBMS_LOGMNR.DICT_FROM_REDO_LOGS);


***解析出了操作T0729_3的update语句
SQL> SQL> set linesize 120
SQL> set linesize 120 pagesize 140
SQL> select seg_name,sql_redo,sql_undo from V$LOGMNR_CONTENTS where seg_name='T0729_3';


SEG_NAME
------------------------------------------------------------------------------------------------------------------------
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
T0729_3
update "SYS"."T0729_3" set "USERNAME" = 'NEWUSER1' where "USERNAME" = 'DIP' and "USER_ID" = '14' and "CREATED" = TO_DATE
('20141110 21:18:04', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAB';
update "SYS"."T0729_3" set "USERNAME" = 'DIP' where "USERNAME" = 'NEWUSER1' and "USER_ID" = '14' and "CREATED" = TO_DATE
('20141110 21:18:04', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAB';


T0729_3
update "SYS"."T0729_3" set "USERNAME" = 'NEWUSER1' where "USERNAME" = 'ORACLE_OCM' and "USER_ID" = '21' and "CREATED" =
TO_DATE('20141110 21:18:49', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAC';
update "SYS"."T0729_3" set "USERNAME" = 'ORACLE_OCM' where "USERNAME" = 'NEWUSER1' and "USER_ID" = '21' and "CREATED" =
TO_DATE('20141110 21:18:49', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAC';


T0729_3
update "SYS"."T0729_3" set "USERNAME" = 'NEWUSER1' where "USERNAME" = 'SYS' and "USER_ID" = '0' and "CREATED" = TO_DATE(
'20141110 21:16:12', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAQ';
update "SYS"."T0729_3" set "USERNAME" = 'SYS' where "USERNAME" = 'NEWUSER1' and "USER_ID" = '0' and "CREATED" = TO_DATE(
'20141110 21:16:12', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAQ';


T0729_3
update "SYS"."T0729_3" set "USERNAME" = 'NEWUSER1' where "USERNAME" = 'SYSTEM' and "USER_ID" = '5' and "CREATED" = TO_DA
TE('20141110 21:16:12', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAR';
update "SYS"."T0729_3" set "USERNAME" = 'SYSTEM' where "USERNAME" = 'NEWUSER1' and "USER_ID" = '5' and "CREATED" = TO_DA
TE('20141110 21:16:12', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAR';


T0729_3
update "SYS"."T0729_3" set "USERNAME" = 'NEWUSER1' where "USERNAME" = 'OUTLN' and "USER_ID" = '9' and "CREATED" = TO_DAT
E('20141110 21:16:14', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAS';
update "SYS"."T0729_3" set "USERNAME" = 'OUTLN' where "USERNAME" = 'NEWUSER1' and "USER_ID" = '9' and "CREATED" = TO_DAT
E('20141110 21:16:14', 'yyyymmdd hh24:mi:ss') and ROWID = 'AAAKH8AAHAAAACDAAS';
