select current_scn from v$database;

begin
DBMS_LOGMNR_D.BUILD(OPTIONS=> DBMS_LOGMNR_D.STORE_IN_REDO_LOGS);
end;
/
 
begin
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_1_seq_632.695.1130406377',OPTIONS => DBMS_LOGMNR.NEW);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_1_seq_633.696.1130406381',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_1_seq_634.697.1130406381',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_1_seq_635.701.1130406393',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_1_seq_636.705.1130406395',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_436.698.1130406383',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_437.699.1130406391',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_438.700.1130406393',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_439.702.1130406393',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_440.703.1130406393',OPTIONS => DBMS_LOGMNR.ADDFILE);
DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/archivelog/2023_03_02/thread_2_seq_441.704.1130406395',OPTIONS => DBMS_LOGMNR.ADDFILE);
-- DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/onlinelog/group_1.257.926710107',OPTIONS => DBMS_LOGMNR.ADDFILE);
-- DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATADG/ocp11g/onlinelog/group_4.266.926710871',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/

/*
* If memeory parameters are re-configured in oracle database or (databases such as RAC), debezium plugin throws ORA-00600 errors.
* Refer to the following log for details.
*/

/**
[2023-03-02 09:36:53,721] INFO For connector ocp11g, starting mining session startScn=2697169, endScn=2698837, strategy=ONLINE_CATALOG, continuous=true (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:773)
[2023-03-02 09:36:55,670] INFO Connection gracefully closed (io.debezium.jdbc.JdbcConnection:965)
[2023-03-02 09:36:55,678] INFO Connection gracefully closed (io.debezium.jdbc.JdbcConnection:965)
[2023-03-02 09:36:55,678] ERROR Mining session stopped due to the {} (io.debezium.connector.oracle.logminer.LogMinerHelper:115)
java.sql.SQLException: ORA-00600: internal error code, arguments: [krvxrrts05], [1], [], [], [], [], [], [], [], [], [], []

        at oracle.jdbc.driver.T4CTTIoer11.processError(T4CTTIoer11.java:494)
        at oracle.jdbc.driver.T4CTTIoer11.processError(T4CTTIoer11.java:446)
        at oracle.jdbc.driver.T4C8Oall.processError(T4C8Oall.java:1054)
        at oracle.jdbc.driver.T4CTTIfun.receive(T4CTTIfun.java:623)
*/

-- startScn=2697169, endScn=2698837

/****************************************************************ONLINE CATALOG****************************************************************/
-- [Success] Add logfile firstly, succeed in mining
BEGIN 
	sys.dbms_logmnr.start_logmnr(startScn => '2697169', endScn => '2698837', OPTIONS  => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.NO_ROWID_IN_STMT);
END;

-- [Failed] miss logfile without adding logfile
-- If Add logfile firstly, succeed in mining
BEGIN 
	sys.dbms_logmnr.start_logmnr(startScn => '2697169', endScn => '2698837', OPTIONS  => DBMS_LOGMNR.CONTINUOUS_MINE + DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG   + DBMS_LOGMNR.NO_ROWID_IN_STMT);
END;

-- [Success] miss logfile, but if skip the logfiles of problem, continuous_mine option can be used
BEGIN 
	sys.dbms_logmnr.start_logmnr(startScn => '2700001', endScn => '2700778', OPTIONS  => DBMS_LOGMNR.CONTINUOUS_MINE + DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG   + DBMS_LOGMNR.NO_ROWID_IN_STMT);
END;

/****************************************************************REDO CATALOG****************************************************************/
-- [Failed] ORA 01371 dict not found because dict was not built before startScn(2697169)
-- If add logfiles including the whole dict firstly or value of startScn in the start_logmnr is less than value of scn at which dict building was started(no need to add logfile explicitly), WHICH ENSURE LOGFILE MINING SUCCESSFUL
-- In another word, the window of startScn and endScn in the start_logmnr procedure must include the whole dictionary in the archive log or redo log
-- This option(DDL_DICT_TRACKING) helps LogMiner maintain internal dictionary which does not stop DDL events produced.
-- 说白了，只需要提供含有完整字典的日志就可以了，其他的交给CONTINUOUS_MINE自行寻找感兴趣的日志文件
-- DDL_DICT_TRACKING，仅有向前追溯的能力，无向后回溯的能力，不能使用后创建的字典去分析之前的发生过DDL的日志
-- 如果要跟踪DDL，则需在对象发生DDL前，构建完整的字典信息
BEGIN 
	sys.dbms_logmnr.start_logmnr(startScn => '2697169', endScn => '2698837', OPTIONS  => DBMS_LOGMNR.CONTINUOUS_MINE + DBMS_LOGMNR.DICT_FROM_REDO_LOGS + DBMS_LOGMNR.DDL_DICT_TRACKING + DBMS_LOGMNR.NO_ROWID_IN_STMT);
END;

-- [Failed] ORA 01371 dict not found because dict was not built before startScn(2697169)
-- need to add logfile firstly, otherwise errors occur
BEGIN 
	sys.dbms_logmnr.start_logmnr(startScn => '2697169', endScn => '2698837', OPTIONS  => DBMS_LOGMNR.DICT_FROM_REDO_LOGS   + DBMS_LOGMNR.NO_ROWID_IN_STMT);
END;


SELECT SCN, SQL_REDO, OPERATION_CODE, TIMESTAMP, XID, CSF, TABLE_NAME, SEG_OWNER, OPERATION, USERNAME, ROW_ID, ROLLBACK, RS_ID FROM V$LOGMNR_CONTENTS
 WHERE SCN > 2697169  AND SCN <= 2698837  AND ((OPERATION_CODE IN (6,7,34,36) OR (OPERATION_CODE = 5 AND USERNAME NOT IN ('SYS','SYSTEM') AND INFO NOT LIKE 'INTERNAL DDL%' AND (TABLE_NAME IS NULL OR TABLE_NAME NOT LIKE 'ORA_TEMP_%')) ) OR (OPERATION_CODE IN (1,2,3) AND TABLE_NAME != 'LOG_MINING_FLUSH' AND SEG_OWNER NOT IN ('APPQOSSYS','AUDSYS','CTXSYS','DVSYS','DBSFWUSER','DBSNMP','GSMADMIN_INTERNAL','LBACSYS','MDSYS','OJVMSYS','OLAPSYS','ORDDATA','ORDSYS','OUTLN','SYS','SYSTEM','WMSYS','XDB') AND (REGEXP_LIKE(SEG_OWNER || '.' || TABLE_NAME,'^daidai.tb_test$','i')) ))
   and SQL_REDO like '%天府通%'

call sys.dbms_logmnr.end_logmnr();

select scn_to_timestamp(2697169) from dual;

-- check logfile to be mined
WITH T AS
 (SELECT MIN(F.MEMBER) AS FILE_NAME,
         L.FIRST_CHANGE# FIRST_CHANGE,
         L."FIRST_TIME",
         L.NEXT_CHANGE# NEXT_CHANGE,
         L."NEXT_TIME",
         L.ARCHIVED,
         L.STATUS,
         'ONLINE' AS TYPE,
         L.SEQUENCE# AS SEQ,
         'NO' AS DICT_START,
         'NO' AS DICT_END
    FROM V$LOGFILE F, V$LOG L
    LEFT JOIN V$ARCHIVED_LOG A
      ON A.FIRST_CHANGE# = L.FIRST_CHANGE#
     AND A.NEXT_CHANGE# = L.NEXT_CHANGE#
   WHERE (A.STATUS <> 'A' OR A.FIRST_CHANGE# IS NULL)
     AND F.GROUP# = L.GROUP#
   GROUP BY F.GROUP#,
            L.FIRST_CHANGE#,
            L."FIRST_TIME",
            L.NEXT_CHANGE#,
            L.NEXT_TIME,
            L.STATUS,
            L.ARCHIVED,
            L.SEQUENCE#
  UNION
  SELECT A.NAME             AS FILE_NAME,
         A.FIRST_CHANGE#    FIRST_CHANGE,
         A."FIRST_TIME",
         A.NEXT_CHANGE#     NEXT_CHANGE,
         A.NEXT_TIME,
         'YES',
         NULL,
         'ARCHIVED',
         A.SEQUENCE#        AS SEQ,
         A.DICTIONARY_BEGIN,
         A.DICTIONARY_END
    FROM V$ARCHIVED_LOG A
   WHERE A.NAME IS NOT NULL
     AND A.ARCHIVED = 'YES'
     AND A.STATUS = 'A'
    -- AND A.NEXT_CHANGE# > 2697169  -- and A."FIRST_CHANGE#" < 2697169
     AND A.DEST_ID IN (SELECT DEST_ID
                         FROM V$ARCHIVE_DEST_STATUS
                        WHERE STATUS = 'VALID'
                          AND TYPE = 'LOCAL'
                          AND ROWNUM = 1))
select * from T where seq in (649,648,647,646,645,644,643,642,641,640,639,638,637,636,635,634,633,632,471,470,469,468,467,466,465,464,463,462,461,460,459,458,457,456,455,454,453,452,451,450,449,448,447,446,445,444,443,442,441,440,439,438,437,436)
order by seq;
