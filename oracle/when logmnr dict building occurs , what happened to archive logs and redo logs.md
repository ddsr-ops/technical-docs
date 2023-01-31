When building LogMiner dictionary, what happened to archive logs (or redo logs).

Directs LogMiner to build the dictionary via the following statement.

```
BEGIN DBMS_LOGMNR_D.BUILD (options => DBMS_LOGMNR_D.STORE_IN_REDO_LOGS); END;
```

After finished the dictionary building, let`s check out the log info.

```
SQL> select * from v$log a, v$logfile b where a.group#  = b.group# order by sequence#;

GROUP#    THREAD#  SEQUENCE#      BYTES  BLOCKSIZE    MEMBERS ARCHIVED STATUS           FIRST_CHANGE# FIRST_TIME                               NEXT_CHANGE# NEXT_TIME                                    GROUP# STATUS  TYPE    MEMBER                                                                           IS_RECOVERY_DEST_FILE
---------- ---------- ---------- ---------- ---------- ---------- -------- ---------------- ------------- ---------------------------------------- ------------ ---------------------------------------- ---------- ------- ------- -------------------------------------------------------------------------------- ---------------------
         1          1      14663  524288000        512          1 YES      INACTIVE             561074952 2022/7/5 15:07:39                           561075868 2022/7/5 15:07:44                                 1         ONLINE  /u01/app/oracle/oradata/ora11g/redo01.log                                        NO
         2          1      14664  524288000        512          1 YES      INACTIVE             561075868 2022/7/5 15:07:44                           561107889 2022/7/5 15:53:28                                 2         ONLINE  /u01/app/oracle/oradata/ora11g/redo02.log                                        NO
         3          1      14665  524288000        512          1 YES      INACTIVE             561107889 2022/7/5 15:53:28                           561108808 2022/7/5 15:53:32                                 3         ONLINE  /u01/app/oracle/oradata/ora11g/redo03.log                                        NO
         4          1      14666  524288000        512          1 YES      INACTIVE             561108808 2022/7/5 15:53:32                           561108952 2022/7/5 15:54:29                                 4         ONLINE  /u01/app/oracle/oradata/ora11g/redo04.log                                        NO
         6          1      14667  524288000        512          1 YES      INACTIVE             561108952 2022/7/5 15:54:29                           561109846 2022/7/5 15:54:31                                 6         ONLINE  /u01/app/oracle/oradata/ora11g/redo06.log                                        NO
         5          1      14668  524288000        512          1 NO       CURRENT              561109846 2022/7/5 15:54:31                        281474976710                                                   5         ONLINE  /u01/app/oracle/oradata/ora11g/redo05.log 
```

```
SQL> select t.name, thread#, sequence#, first_change#, first_time, next_change#, next_time, blocks, status, completion_time, archived, dictionary_begin, dictionary_end, creator, registrar, end_of_redo_type  from V$ARCHIVED_LOG t where first_time >= to_date('2022-07-05 15:00:00', 'yyyy-mm-dd hh24:mi:ss'); -- 14248

NAME                                                                                THREAD#  SEQUENCE# FIRST_CHANGE# FIRST_TIME                               NEXT_CHANGE# NEXT_TIME                                    BLOCKS STATUS COMPLETION_TIME                          ARCHIVED DICTIONARY_BEGIN DICTIONARY_END CREATOR REGISTRAR END_OF_REDO_TYPE
-------------------------------------------------------------------------------- ---------- ---------- ------------- ---------------------------------------- ------------ ---------------------------------------- ---------- ------ ---------------------------------------- -------- ---------------- -------------- ------- --------- ----------------
/u01/app/oracle/fast_recovery_area/ORA11G/archivelog/2022_07_05/o1_mf_1_14663_kd          1      14663     561074952 2022/7/5 15:07:39                           561075868 2022/7/5 15:07:44                             56714 A      2022/7/5 15:07:44                        YES      YES              YES            FGRD    FGRD      
/u01/app/oracle/fast_recovery_area/ORA11G/archivelog/2022_07_05/o1_mf_1_14664_kd          1      14664     561075868 2022/7/5 15:07:44                           561107889 2022/7/5 15:53:28                            578475 A      2022/7/5 15:53:31                        YES      NO               NO             ARCH    ARCH      
/u01/app/oracle/fast_recovery_area/ORA11G/archivelog/2022_07_05/o1_mf_1_14665_kd          1      14665     561107889 2022/7/5 15:53:28                           561108808 2022/7/5 15:53:32                             56716 A      2022/7/5 15:53:33                        YES      YES              YES            FGRD    FGRD      
/u01/app/oracle/fast_recovery_area/ORA11G/archivelog/2022_07_05/o1_mf_1_14666_kd          1      14666     561108808 2022/7/5 15:53:32                           561108952 2022/7/5 15:54:29                               106 A      2022/7/5 15:54:29                        YES      NO               NO             ARCH    ARCH      
/u01/app/oracle/fast_recovery_area/ORA11G/archivelog/2022_07_05/o1_mf_1_14667_kd          1      14667     561108952 2022/7/5 15:54:29                           561109846 2022/7/5 15:54:31                             56688 A      2022/7/5 15:54:32                        YES      YES              YES            FGRD    FGRD
```

According to the above output, dict building action happened three times.
The value of column `dictionary_begin` and `dictionary_end` is `YES`, which indicates the log(archive or redo) includes dictionary info.
If the size of dict is large, multiple logs include dictionary info so that the whole dict is persisted in the log.