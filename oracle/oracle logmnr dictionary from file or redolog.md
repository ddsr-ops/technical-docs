��9i��ʼoracle���Ƴ���logminer--��־�ھ�����logminer��ֱ��Ӧ����redolog���ݵĽ�����Ҳ���������Flashback transaction��SQL apply in logical standby database�ȳ��ϡ�
�ڶԷǱ������ɵ�redolog���н���ʱ����Ҫ�õ�logminer dictionary�����͵����ӣ��logical standby database�Ĺ�������һ��������build logminer dictionary����Ϊprimary db��logical standby db������ȫ��ͬ�������⣬Ҫʹstandby�ܹ���primary���ɵ�redolog��׼ȷ��������ִ�е�sql��䣬�����primary db���������������Ϣ�������ֵ��ṩ��standby db���ṩ����ʽ�л����ļ��ͻ���redolog���֣�ǰ���ǽ������ֵ���Ϣֱ�ӵ�����һ���ı��ļ������߽��ֵ���Ϣ�����online redolog���򵥵�˵logminer dictionary���ǰ����������������ID��ӳ���ϵ�������ֵ����Ӽ������˽������ŷ���ɶ������Ƶ����á����û��logminer dictionary���ǽ���������sql�ｫ�����˸��ֻ�ɬ�Ѷ������ֺʹ��š�
�����Խ���һ���鵵��־���SQL���Ϊ��������һ��logminer dictionary�����������ӵ�����


# ���Ҫ������redolog�Ǳ�������ģ���ô����Ҫbuild logminer dictionary��ʹ�ñ���������ֵ����

/////////////////////  
// ���Ҫ������redolog�Ǳ�������ģ���ô����Ҫbuild logminer dictionary��ʹ�ñ���������ֵ����
/////////////////////  
����/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc��tstdb1�����ɵ�һ���鵵��־�ļ�������Ҫ��tstdb1���϶�����鵵���н��������ڱ������logminer���������build logminer dictionary��ʹ�ñ����ֳɵ������ֵ伴��

**��archivelog������Դ��tstdb1��ִ��logminer**

```
SQL> show parameter db_name


NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_name                              string      tstdb1


exec dbms_logmnr.add_logfile(logfilename=>'/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


-- ��Ϊ�Ǳ�������ʹ��DICT_FROM_ONLINE_CATALOG�������ֵ�����������Ϣ����
exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);


***��Archivelog���ѳ��������������������������Щsql�Ѿ��Ǿ�������ģ�����ǿ�ִ�е�
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


SQL> select * from V$LOGMNR_DICTIONARY;    <---û��build logminer dictionary����û�м�¼


no rows selected


set numwidth 16 linesize 120
col filename format a60
select low_scn,filename from V$LOGMNR_LOGS;  <---���ڱ��ھ����־
         LOW_SCN FILENAME
---------------- ------------------------------------------------------------
  12723365353557 /oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8o
                 Un0kl_.arc


SQL> set numwidth 16
SQL> select start_scn,options from V$LOGMNR_PARAMETERS;   <---ִ��DBMS_LOGMNR.START_LOGMNRʱָ���Ĳ���


       START_SCN          OPTIONS
---------------- ----------------
  12723365353557               16    <--16��ʾ�Ա�����data dictionary��Ϊlogminer dictionary
```

optionsȡֵ���������£�  
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
Ĭ��ֵΪ0


# Ҫ�����������������redolog����û��logminer dictionary������£��޷�������׼ȷ�ġ���ִ�е�SQL���

/////////////////////  
// Ҫ�����������������redolog����û��logminer dictionary������£��޷�������׼ȷ�ġ���ִ�е�SQL���  
/////////////////////  

��shzw���Ͻ�����tstdb1�������archivelog:/oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc
��tstdb1�������archivelog���Ƶ�Ŀ���shzw��

```
scp /oradata06/fra/TSTDB1/archivelog/2015_07_29/o1_mf_1_109_1l8oUn0kl_.arc oracle@10.10.141.207:/oradata04/


SQL> show parameter db_name


NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_name                              string      shzw


-- û��build logminer dictionary���������shzw���Ͻ���tstdb1��redolog���õ���sql���û�о���ı���������
exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>0);


-- ��seg_nameΪ����ֻ�ѵ�create table��䣬ddl�����û��logminer dictionary��������ܹ�����ȷ������
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



***����rowidΪ����������DMLû��logminer dictionary��������޷��õ�����ʵ������
select sql_redo,sql_undo from V$LOGMNR_CONTENTS where sql_redo like '%insert into%';
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
����������ʡ�Բ������


insert into "UNKNOWN"."OBJ# 41415"("COL 1","COL 2") values (HEXTORAW('c102'),HEXTORAW('61'));
delete from "UNKNOWN"."OBJ# 41415" where "COL 1" = HEXTORAW('c102') and "COL 2" = HEXTORAW('61') and ROWID = 'AAAKHHAAJA
AAACVAAA';


insert into "UNKNOWN"."OBJ# 41415"("COL 1","COL 2") values (HEXTORAW('c103'),HEXTORAW('62'));
delete from "UNKNOWN"."OBJ# 41415" where "COL 1" = HEXTORAW('c103') and "COL 2" = HEXTORAW('62') and ROWID = 'AAAKHHAAJA
AAACVAAB';

10 rows selected.
```

obj#41415����t0729_2����tstdb1���ϵ�object_id��insert����������Ҳ��col 1��col 2����ˣ��������ֵ1���滻����HEXTORAW('c102')���ַ�'a'���滻����HEXTORAW('61')���ɼ�û��logminer dictionary����ddl�����������ʾ��dml���������߱��ɶ��ԡ�����logminer dictionary��Ŀ�ľ����ܹ��Կɶ�����ִ�е���ʽ��ʾ����ЩSQL��䡣


# ����logminer dictionary�����ַ�ʽ

/////////////////////
// ����logminer dictionary�����ַ�ʽ
/////////////////////
logminer dictionary���Դ������ı��ļ���Ҳ���Դ�����redolog file����Ȼ��shzw���Ͻ���tstdb1�����ɵ�redolog��Ϊ����

## ��logminer dictionary������ı��ļ�

��Դ��tstdb1��build logminer dictionary��ĳ���ļ���
```
alter system set utl_file_dir='/oradata01' scope=spfile;

startup force

exec dbms_logmnr_d.build(dictionary_filename=>'tstdb1.dic',dictionary_location=>'/oradata01',options=>dbms_logmnr_d.STORE_IN_FLAT_FILE);

��dictionary�ļ����͵�ִ�н���������shzw��
scp /oradata01/tstdb1.dic oracle@10.10.141.207:/oradata04/


��shzw�����ٴν���START_LOGMNR��������ο����������ı���������
exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);

exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'/oradata04/tstdb1.dic',Options=>0);   <---DictFileNameָ����dictionary�ļ���·��

set linesize 120 pagesize 140
select sql_redo,sql_undo from V$LOGMNR_CONTENTS


SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
��������ʡ�Բ������


insert into "SCOTT"."T0729_2"("ID","C2") values ('1','a');
delete from "SCOTT"."T0729_2" where "ID" = '1' and "C2" = 'a' and ROWID = 'AAAKHHAAJAAAACVAAA';


insert into "SCOTT"."T0729_2"("ID","C2") values ('2','b');
delete from "SCOTT"."T0729_2" where "ID" = '2' and "C2" = 'b' and ROWID = 'AAAKHHAAJAAAACVAAB';


commit;
```

��������һ��logminer dictionary�ļ��������Щ���ݣ����������ɵ�tstdb1.dic�ļ�Ϊ����tstdb1.dic��һ���ı��ļ��������ҳ�������t0729_2���йصļ�¼
---��¼������Ϣ��OBJ$��
INSERT_INTO OBJ$_TABLE VALUES (41415,41415,36,'T0729_2',1,'',2,to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),to_date('07/29/2015 14:11:23', 'MM/DD/YYYY HH24:MI:SS'),1,'','',0,,6,1,36,'','', );


---��¼�û���Ϣ��USER$��
INSERT_INTO USER$_TABLE VALUES (36,'SCOTT',1,'5665B0DA34DDB8C5',4,3,to_date('12/09/2014 15:17:00', 'MM/DD/YYYY HH24:MI:SS'),to_date('06/29/2015 16:17:59', 'MM/DD/YYYY HH24:MI:SS'),to_date('06/30/2015 15:23:38', 'MM/DD/YYYY HH24:MI:SS'),,0,'',1,,,0,0,'DEFAULT_CONSUMER_GROUP','',0,,,'S:23DCE06BB6C5408756DFE8FE2C307CC5E5BCA05B9BE6C06AE53FA9AAD21C','', );


---��¼����Ϣ��COL$��
INSERT_INTO COL$_TABLE VALUES (41415,1,1,22,0,'ID',2,22,0,,,0,,'',1,0,0,0,0,0,0,'','', );
INSERT_INTO COL$_TABLE VALUES (41415,2,2,10,0,'C2',1,10,0,,,0,,'',2,0,852,1,0,0,10,'','', );


---��¼����Ϣ��TAB$��
INSERT_INTO TAB$_TABLE VALUES (41415,41415,41,9,146,,,2,,10,40,1,255,1073741825,'--------------------------------------',,,,,,,,,,,,,2,2,536870912,0,0,736,,,'','',to_date('07/29/2015 06:11:23', 'MM/DD/YYYY HH24:MI:SS'));


���е���Ϣ�����ˣ���Ŀ������archivelog��ʱ��ο������������Ϣ���ٿ��Խ�������ת��
"OBJ# 41415"=>T0729_2
"COL 1"=>'ID'
"COL 2"=>'C2'


����table_owner��δ�"UNKNOWN"=>SCOTT���²�ԭ�������һ����archived log�ڲ�Ҳ׼ȷ��¼��userid��ֻ����û��ֱ����ʾ��user_id������UNKNOWN����ˡ�


Ϊ�˱���logminer�ֵ��ļ�����ִ�У�dictionary �ļ��������insert_into���insert��������ÿ��������������_TABLE������COL$����ʾ��COL$_TABLE��
���logminer dictionary�������Լ��޸ĺ���������ݿ���ִ�У���Ҫע����Щinsert��������Ŀ�����ִ��(��ͬ������redolog file�����ݿ�)����ʹִ�гɹ���Ҳ������Ŀ�����ʹ��DICT_FROM_ONLINE_CATALOG��ʽ����redolog���sql��䣬������������ܵ����±���
SQL> exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);


*
ERROR at line 1:
ORA-01295: DB_ID mismatch between dictionary USE_ONLINE_CATALOG and logfiles
ORA-06512: at "SYS.DBMS_LOGMNR", line 58
ORA-06512: at line 1


��ΪOracle��ʹ��online catalogҲ���Ǳ����������ֵ����ʱ�����ⱻ������redolog file���dbid��Ŀ����dbid�Ƿ�һ�£������һ�¾ͻᱨ������Ĵ���


�ı���ʽ����logminer dictionary�Ŀ���ֲ�Խ�ǿ�������ڵ�������dictionary file���ܱ�����۸ģ��������ǽ�tstdb1.dic���T0729_2�����滻��AAAA
��ô����������SQL����ʾ�ľ���'AAAA'


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_109_1l8oUn0kl_.arc',options=>DBMS_LOGMNR.NEW);


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'/oradata04/tstdb1.dic',Options=>0);   <---DictFileNameָ����dictionary�ļ���·��


set linesize 120
set linesize 120 pagesize 140
select sql_redo,sql_undo from V$LOGMNR_CONTENTS;
SQL_REDO
------------------------------------------------------------------------------------------------------------------------
SQL_UNDO
------------------------------------------------------------------------------------------------------------------------
��������ʡ�Բ������


insert into "SCOTT"."AAAA"("ID","C2") values ('1','a');
delete from "SCOTT"."AAAA" where "ID" = '1' and "C2" = 'a' and ROWID = 'AAAKHHAAJAAAACVAAA';


insert into "SCOTT"."AAAA"("ID","C2") values ('2','b');
delete from "SCOTT"."AAAA" where "ID" = '2' and "C2" = 'b' and ROWID = 'AAAKHHAAJAAAACVAAB';


commit;


�������ѡ��redolog file��Ϊlogminer dictionary�����壬�Ͳ������������


(2)��logminer dictionary������redolog file�����
###��tstdb1���Ϲ���logminer dictionary
***tstdb1�����ֹ��л�һ��logfile��current redolog��Ϊ��Sequence#  142
alter system switch logfile;


SYS@tstdb1-SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     140
Next log sequence to archive   142
Current log sequence           142
SYS@tstdb1-SQL> 


***ִ��update
update t0729_3 set username='NEWUSER1' where user_id<30;
commit;


***��logminer dictionary build��redolog��
SYS@tstdb1-SQL> exec DBMS_LOGMNR_D.BUILD(dictionary_filename=>NULL,dictionary_location=>NULL,options=>dbms_logmnr_d.STORE_IN_REDO_LOGS);


PL/SQL procedure successfully completed.


***build��ɺ��ֵ�ǰ��redolog sequence�Ѿ�ǰ������144��˵��142��143�Ѿ����鵵
SYS@tstdb1-SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     142
Next log sequence to archive   144
Current log sequence           144


ͨ��v$archivelog���Կ�����Щ�鵵��־����logminer dictionary
col name format a90
set linesize 150
select name,ARCHIVED,DICTIONARY_BEGIN,DICTIONARY_END from v$archived_log where name like '%o1_mf_1_14%_.arc';


NAME                                                                                       ARC DIC DIC
------------------------------------------------------------------------------------------ --- --- ---
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_140_1lGtfKCjT_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_141_1lHQRCI8J_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_142_1lHQpRoEe_.arc                     YES NO  NO
/oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_143_1lHQpcQR8_.arc                     YES YES YES    <---sequence# 143����logminer dictionary


###��shzw���Ͻ�����tstdb1����ִ�е�update���
***�Ȱ�o1_mf_1_142_1lHQpRoEe_arc��.o1_mf_1_143_1lHQpcQR8_.arc����archivelog���Ƶ�shzw����������
scp /oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_142_1lHQpRoEe_.arc oracle@10.10.141.207:/oradata04/
scp /oradata06/fra/TSTDB1/archivelog/2015_08_05/o1_mf_1_143_1lHQpcQR8_.arc oracle@10.10.141.207:/oradata04/


�ղ����ǵ�update����������sequence# 142���archivelog��������Ҫ��ȷ����������update��䣬���뽫sequence# 143Ҳ�������


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_142_1lHQpRoEe_.arc',options=>DBMS_LOGMNR.NEW);


exec dbms_logmnr.add_logfile(logfilename=>'/oradata04/o1_mf_1_143_1lHQpcQR8_.arc',options=>DBMS_LOGMNR.ADDFILE);   <---����sequence# 143


exec DBMS_LOGMNR.START_LOGMNR(DictFileName=>'',Options=>DBMS_LOGMNR.DICT_FROM_REDO_LOGS);


***�������˲���T0729_3��update���
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
