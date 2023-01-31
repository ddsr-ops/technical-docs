case repetition

```
����LOGMINER��ʱ�������ORA-310��ORA-334����
���Դ������£�

SQL> SELECT GROUP# FROM V$LOG WHERE STATUS = 'CURRENT';
GROUP#
----------
         2
SQL> SELECT MEMBER FROM V$LOGFILE WHERE GROUP# = 2;
MEMBER
--------------------------------------------------------------------
/oracle/oradata/orcl/redo02.log
SQL> EXEC DBMS_LOGMNR.ADD_LOGFILE('/oracle/oradata/orcl/redo02.log', DBMS_LOGMNR.NEW)
PL/SQL PROCEDURE successfully completed.
SQL> EXEC DBMS_LOGMNR.START_LOGMNR(OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG)
PL/SQL PROCEDURE successfully completed.
SQL> CREATE TABLE T_BAK_LOGMNR AS SELECT * FROM V$LOGMNR_CONTENTS;
CREATE TABLE T_BAK_LOGMNR AS SELECT * FROM V$LOGMNR_CONTENTS
*
ERROR at line 1:
ORA-00310: archived log contains SEQUENCE 98; SEQUENCE 95 required
ORA-00334: archived log: '/oracle/oradata/orcl/redo02.log'
SQL> ALTER SYSTEM SWITCH LOGFILE;
System altered.
SQL> EXEC DBMS_LOGMNR.END_LOGMNR
PL/SQL PROCEDURE successfully completed.
SQL> EXEC DBMS_LOGMNR.ADD_LOGFILE('/oracle/oradata/orcl/redo02.log', DBMS_LOGMNR.NEW)
PL/SQL PROCEDURE successfully completed.
SQL> EXEC DBMS_LOGMNR.START_LOGMNR(OPTIONS => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG)
PL/SQL PROCEDURE successfully completed.
SQL> CREATE TABLE T_BAK_LOGMNR AS SELECT * FROM V$LOGMNR_CONTENTS;
CREATE TABLE T_BAK_LOGMNR AS SELECT * FROM V$LOGMNR_CONTENTS
*
ERROR at line 1:
ORA-00310: archived log contains SEQUENCE 101; SEQUENCE 98 required
ORA-00334: archived log: '/oracle/oradata/orcl/redo02.log'
SQL> EXEC DBMS_LOGMNR.END_LOGMNR
PL/SQL PROCEDURE successfully completed.
SQL> SELECT GROUP# FROM V$LOG WHERE STATUS = 'CURRENT';
GROUP#
----------
         2
SQL> ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
SESSION altered.
SQL> SELECT GROUP#, SEQUENCE#, STATUS, FIRST_TIME, NEXT_TIME FROM V$LOG;
GROUP# SEQUENCE#  STATUS           FIRST_TIME          NEXT_TIME
---------- ---------- ---------------- ------------------- -------------------
         1 100        INACTIVE         2011-09-29 17:03:26 2011-09-29 17:03:51
         2 101        CURRENT          2011-09-29 17:03:51
         3 99         INACTIVE         2011-09-29 17:02:52 2011-09-29 17:03:26


```

explanation

��һ�γ�����������ʱ�򣬺ܿ���ʶ���Լ�����һ���ͼ��Ĵ��󣬶Ե�ǰ��־������LOGMINER�����´���Ĳ�����
����SWITCH LOGFILE֮�������Ȼ��Ȼ����֡���鵱ǰ����־�����ֵ�ǰ��־��Ȼ�ֻᵽ��GROUP 2��˵���ڶ��ν���LOGMINER��ʱ��ͬ���ǵ�ǰ��־��
��ϸ������һ��˼·�����������ԭ�򡣵�һ�ε��´����ʱ��ֻ����Ϊ������LOGMINER��ǰ��־���£���û����ϸ�о�������Ϣ��
���ڲ���CREATE TABLE AS SELECT * FROM V$LOGMNR_CONTENTS�ķ���������ͼ�в�ѯ���ǵ�ǰ��־�е���Ϣ���ͻᵼ��CREATE TABLE��������־������V$LOGMNR_CONTENTS��ͼ�У�
����ͼ�еļ�¼ʹ��CREATE TABLE������������ݣ������յ�����һ����ѭ����
��������־д����Oracle�Զ��л�������LOGMINER��û�н��������Ǽ�����ȡ�µ���־��֪��������־����д����
����OracleҪ�л���ʱ���ֵ�һ����־��Ȼ��ʹ�ã����ǳ�����ORA-310��ORA-334�Ĵ��󡣶��ڶ��ο�ʼǰ���л���ǡ��ʹ��������־�лصڶ�����־�����Ǵ�����ȫ��������һ�Ρ�