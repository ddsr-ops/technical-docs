case repetition

```
测试LOGMINER的时候出现了ORA-310和ORA-334错误。
测试代码如下：

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

第一次出现这个错误的时候，很快意识到自己犯了一个低级的错误，对当前日志进行了LOGMINER，导致错误的产生。
但是SWITCH LOGFILE之后，问题居然仍然会出现。检查当前的日志，发现当前日志居然又会到了GROUP 2，说明第二次进行LOGMINER的时候同样是当前日志。
仔细整理了一下思路，发现问题的原因。第一次导致错误的时候只是认为是由于LOGMINER当前日志所致，并没有仔细研究错误信息。
由于采用CREATE TABLE AS SELECT * FROM V$LOGMNR_CONTENTS的方法，且视图中查询的是当前日志中的信息，就会导致CREATE TABLE产生的日志出现在V$LOGMNR_CONTENTS视图中，
而视图中的记录使得CREATE TABLE产生更多的内容，并最终导致了一个死循环。
当联机日志写满后，Oracle自动切换，但是LOGMINER并没有结束，而是继续抽取新的日志，知道三个日志都被写满，
这是Oracle要切换的时候发现第一个日志仍然被使用，于是出现了ORA-310和ORA-334的错误。而第二次开始前的切换，恰好使得联机日志切回第二个日志，于是错误完全的重演了一次。