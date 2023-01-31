# ����

��ʵ�������У����ǿ����������ھ���־ָ����Χ�������������粹����


# Ŀ��

ʹ��`debezium connector`����ȡ`Oracle/MySQL`��־��ָ����Χ�����ݣ�������Ͷ����`Kafka Topic`.


# ����

* ͨ��ָ��`Oracle`��ʼ`SCN`�źͽ���`SCN`�ţ�����ָ���������־���ݣ����������Ͷ����`Kafka`
* ͨ��ָ��`MySQL`�Ķ������ļ�������ʼ`Position`λ�úͽ���`Position`λ�ã�����ָ���������־���ݣ����������Ͷ����`Kafka`
* �ϲ�`Oracle`��ȡ��־��ͼ�����Ի����Խ����־���ܲ����ڵ�BUG����Ϊ`Oracle`����һ�������в���`V$LOG`��`V$ARCHIVED_LOG`��
  ��`redolog`�ڽ��й鵵ʱ��ͨ���ȶ���`SQL`���ܻ��ѯ����������������־�ļ��������׳��޷�������ָ��`SCN`����־�ļ��쳣
* ����`Oracle PGA`���ƣ�����PGA�������ӣ������붯̬�޸�`log.mining.strategy`���ܣ���Ӧ�Ա�����ݱ�ṹ


# ���߼�����

����Master��֧`Tag1.8.0.Final`�汾�����޸ġ�

## Oracle����

����ָ��`SCN`����������־���ݹ��ܡ�����`PGA`�ڴ��С�Ĺ��ܣ�
`io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource#execute`

`Oracle`��ȡ��־��ͼ�����Ի��ƣ�
`io.debezium.connector.oracle.logminer.LogMinerHelper#setLogFilesForMining`

## MySQL����

����ָ����־ָ��Position������־��  
`io.debezium.connector.mysql.MySqlConnectorTask#start`
`io.debezium.connector.mysql.MySqlStreamingChangeEventSource#handleEvent`
`io.debezium.connector.mysql.MySqlStreamingChangeEventSource#execute`


# ʹ��

## Oracle

`Oracle connector`���������������`scn.start`��`scn.end`, `Connector`�����`(scn.start, scn.end]`֮������ݡ���Ϊ`Debezium`Դ�����У�ʹ�õ����ұ��������ȡ�������ﲢδ�޸��ⲿ��Դ���롣

��`Oracle`�ܹ�Ϊ**����ģʽ**ʱ��ʹ������ʾ�������ã�
```json
{
     "name": "devdboragch0",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id;dba_test.tb_test11:id;dba_test.tb_test10:id;dba_test.tb_test12:id;dba_test.tb_test13:id;dba_test.tb_test14:id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch0",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "schema_only",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "log.mining.transaction.retention.hours" : "1",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.tb_test,dba_test.tb_test11,dba_test.tb_test10,dba_test.tb_test12,dba_test.tb_test13,dba_test.tb_test14",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch0",
         "scn.start": "502732319",
         "scn.end": "502742138",
         "database.history.store.only.captured.tables.ddl": "true"
     }
  }
```

��`Oracle`�ܹ�Ϊ**RAC**ʱ�����������е�������`rac.node`���磺
```json
{
   "name": "tft_ups",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "tft_ups",
       "database.user" : "logminer",
       "database.password" : "**********",
       "database.dbname" : "tftups",
       "database.port" : "1521",
       "database.hostname" : "10.60.6.11",
       "rac.nodes" : "10.60.6.11,10.60.6.12", 
       "log.mining.transaction.retention.hours" : "6",
       "table.include.list":"tft_ups.dc_trip_order",
       "message.key.columns":"tft_ups.dc_trip_order:order_no",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
       "database.history.kafka.topic": "tft_ups_his",
       "snapshot.mode" : "schema_only",
       "tombstones.on.delete": "false",
       "database.history.skip.unparseable.ddl": "true",
       "scn.start": "502732319",
       "scn.end": "502742138",
       "database.history.store.only.captured.tables.ddl": "true"
   }
}
```


**ע�⣺**
1. `snapshot.mode`������Ϊ�ǿ���ģʽ����`schema_only`Ϊ����ȡ���`schema`��Ϣ������ȡ����
2. ����������`scn.start`��`scn.end`ʱ���ʵ��ſ����䣬��������Ҫ������
3. �������`database.history.store.only.captured.tables.ddl`���ã�����Ϊtrue������ȡ�������`DDL`
4. ֧��ͬһ���õ���ҵ������У��ظ���ȡ���ݣ����ݽ���<u>�ظ�</u>Ͷ����`kafka`��
   �м��ڲ�����`scn.start`��`scn.end`ʱ��ͨ��ɾ�����ؽ�`connector`�������`name`����`connector`���ȡ`connect-offsets`�е�`offset`��
   `connector`���`offset`����������
5. ֧��ͬһ��ҵ���޸�`SCN`��������ӱ�����ٴ����У�ʵ�ֶ���������ȡ����ϸ�ο����ʵ��`Oracle`����
6. ������ָ��`scn.start`��ʼ������־�ھ� �ɽ�`scn.end`����Ϊ���޴���`999999999999999999`����ͨ����������ô����
7. `connector`�����󣬽���ȡ���õ�`SCN`������ݣ�������ȡ��Ϻ�`connector`�����Զ��˳��������ɾ���ӿ�ɾ����`connector`

ע�������־�����`connector`����ȡ�Ƿ������

```
......
[2022-03-02 14:51:30,291] INFO Oracle Session UGA 2.91MB (max = 3.02MB), PGA 5.47MB (max = 22.72MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:355)
[2022-03-02 14:51:31,092] INFO Fetched log between SCN 503339376 and SCN 503339396, then ended the mining session (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:222)
[2022-03-02 14:51:31,092] INFO startScn=503339396, endScn=503339396 (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:235)
[2022-03-02 14:51:31,093] INFO Streaming metrics dump: OracleStreamingChangeEventSourceMetrics{currentScn=503556678, oldestScn=503339394, committedScn=503339396, offsetScn=503339394, logMinerQueryCount=1, totalProcessedRows=30, totalCapturedDmlCount=10, totalDurationOfFetchingQuery=PT0.323S, lastCapturedDmlCount=10, lastDurationOfFetchingQuery=PT0.323S, maxCapturedDmlCount=10, maxDurationOfFetchingQuery=PT0.323S, totalBatchProcessingDuration=PT0.412S, lastBatchProcessingDuration=PT0.412S, maxBatchProcessingThroughput=24, currentLogFileName=[/u01/app/oracle/oradata/ora11g/redo03.log], minLogFilesMined=1, maxLogFilesMined=1, redoLogStatus=[/u01/app/oracle/oradata/ora11g/redo03.log | CURRENT, /u01/app/oracle/oradata/ora11g/redo02.log | INACTIVE, /u01/app/oracle/oradata/ora11g/redo06.log | INACTIVE, /u01/app/oracle/oradata/ora11g/redo04.log | INACTIVE, /u01/app/oracle/oradata/ora11g/redo05.log | INACTIVE, /u01/app/oracle/oradata/ora11g/redo01.log | INACTIVE], switchCounter=0, batchSize=21000, millisecondToSleepBetweenMiningQuery=800, hoursToKeepTransaction=1, networkConnectionProblemsCounter0, batchSizeDefault=20000, batchSizeMin=1000, batchSizeMax=100000, sleepTimeDefault=1000, sleepTimeMin=0, sleepTimeMax=3000, sleepTimeIncrement=200, totalParseTime=PT0S, totalStartLogMiningSessionDuration=PT0.002S, lastStartLogMiningSessionDuration=PT0.002S, maxStartLogMiningSessionDuration=PT0.002S, totalProcessTime=PT0.412S, minBatchProcessTime=PT0.412S, maxBatchProcessTime=PT0.412S, totalResultSetNextTime=PT0S, lagFromTheSource=DurationPT36H41M12.248S, maxLagFromTheSourceDuration=PT36H41M12.248S, minLagFromTheSourceDuration=PT36H41M12.212S, lastCommitDuration=PT0.001S, maxCommitDuration=PT0.027S, activeTransactions=0, rolledBackTransactions=0, committedTransactions=10, abandonedTransactionIds=[], rolledbackTransactionIds=[], registeredDmlCount=10, committedDmlCount=10, errorCount=0, warningCount=0, scnFreezeCount=0, unparsableDdlCount=0, miningSessionUserGlobalAreaMemory=3048200, miningSessionUserGlobalAreaMaxMemory=3171712, miningSessionProcessGlobalAreaMemory=5735400, miningSessionProcessGlobalAreaMaxMemory=5735400} (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:236)
[2022-03-02 14:51:31,093] INFO Offsets: OracleOffsetContext [scn=503339396] (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:237)
[2022-03-02 14:51:31,094] INFO Finished streaming (io.debezium.pipeline.ChangeEventSourceCoordinator:173)<=====================
......
```
��������־���Կ�����`Streaming metrics`�Ķ�����Ϣ�����������ȡ�������������ʡ���־״̬�ȣ����ı���`Finished streaming`��
��ʾ��ʽ��ȡ�����Ѿ����������ɾ����`connector`��

`curl -Ss -X DELETE http://localhost:8083/connectors/devdboragch1`

### ��ȡ`SCN`����

��ͨ��ָ����`SCN`���䣬ʵ��ָ�����ݵ��ھ���ʹ���߱�����������ھ����������`SCN`���䡣
1. ��������ݷ���`DML`��ʱ�䷶Χ��ͨ�����¼ʱ�䡢����Ӧ����־�ȣ��� �����ʹ��`timestamp_to_scn`��ת����`SCN`�ţ�
   ��`select timestamp_to_scn(to_timestamp('18/02/2022 15:22:44','DD/MM/YYYY HH24:MI:SS')) as scn from dual;`
2. ������ݷ��������ʱ�䷶Χ�޷���֪�� ��������ݣ���¼���Ĺؼ��ֶ���Ϣ����������Ψһ���ֶε�ֵ�����ͨ���ֶ��ھ���־��λ`SCN`�ţ�
   �˲�����Ϊ������������ж����־�ļ�ͬʱ�ھ������PGA��������⣬���Ƽ�ʹ�ã����Բο������ĵ���oracle logminer.pdf��
3. ����б�Ҫ��ȷ��ȡ`SCN`���䣬��ʹ��`Oracle`��־�ھ򹤾��ֶ��ھ���־���鿴`v$logmnr_contents`���Ƿ���ڷ���Ҫ������ݣ�
   �پ�ȷ��ȷ��`SCN`���䣬���Բο������ĵ���oracle logminer.pdf��������ο�����
4. �����`Oracle`���ݿ������ �ɽ���`Connector`���д���ä�ڣ�������µ�`SCN`���䣬������Ͷ����`kafka`����ȷ�������Ƿ����Ҫ��
   ���ϳ��ԣ�ֱ�����վ�׼��`SCN`����ȷ��
   

ͨ����˵�� һ��ʹ��1��3����ɾ�ȷ��λ`SCN`�ţ���������֧���ظ����ݵ��ݴ������辫ȷ��`SCN`���䡣
����޷���֪���ݷ���`DML`��ʱ�䷶Χ�����޷���ô��µ�`SCN`�ţ�ͨ��ä����־�������޴����潫��ʾ�����ͨ�����ݷ�������Ĵ���ʱ�䷶Χ��
ȷ��׼ȷ��`SCN`���䡣

������֪`Oracle`��`tb_test`��`2022-03-01 10��00`��`11��00`�����˴������ݲ��룬����ȡ����`id`Ϊ`6447354~6447363`�����ݡ�

1. **�鿴���ݿ�Ŀǰ֧�������ھ����С`SCN`**
```
SELECT MIN(FIRST_CHANGE#), MIN(FIRST_TIME)
  FROM (SELECT MIN(FIRST_CHANGE#) AS FIRST_CHANGE#,
               MIN(FIRST_TIME) AS FIRST_TIME
          FROM V$LOG
        UNION
        SELECT MIN(FIRST_CHANGE#) AS FIRST_CHANGE,
               MIN(FIRST_TIME) AS FIRST_TIME
          FROM V$ARCHIVED_LOG
         WHERE DEST_ID IN (SELECT DEST_ID
                             FROM V$ARCHIVE_DEST_STATUS
                            WHERE STATUS = 'VALID'
                              AND TYPE = 'LOCAL'
                              AND ROWNUM = 1)
           AND STATUS = 'A');

MIN(FIRST_CHANGE#) MIN(FIRST_TIME)
------------------ ---------------
         502158888 2022/2/21 22:08
```
`502158888`Ϊ���ݿ���С��`SCN`�ţ�`2022/2/21 22:08`Ϊ���ݿ�����ȡ��־����Сʱ�䣬��С�ڸ�ʱ������ݣ����޷�ͨ����־������ȡ��
��ʾ���У��������ݱ����ʱ����`2022-03-01 10��00`��`11��00`��������С���ݿ���Сʱ�䣬�ⲿ��������Ȼ������־�У��ɽ�����ȡ��
��ʱ���趨λ�ⲿ���������ĸ���־�ļ��С�

2. **�鿴������������־�ļ�**
```
SELECT MIN(F.MEMBER) AS FILE_NAME,
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
   AND A.NEXT_CHANGE# > 487194949
   AND A.DEST_ID IN (SELECT DEST_ID
                       FROM V$ARCHIVE_DEST_STATUS
                      WHERE STATUS = 'VALID'
                        AND TYPE = 'LOCAL'
                        AND ROWNUM = 1)
 ORDER BY 9;

FILE_NAME                                   FIRST_CHANGE FIRST_TIME  NEXT_CHANGE NEXT_TIME   ARCHIVED STATUS           TYPE            SEQ DICT_START DICT_END
------------------------------------------- ------------ ----------- ----------- ----------- -------- ---------------- -------- ---------- ---------- --------
/u01/app/oracle/oradata/ora11g/redo03.log      502158888 2022/2/21 2   502475896 2022/2/23 2 YES      INACTIVE         ONLINE        12175 NO         NO
/u01/app/oracle/oradata/ora11g/redo04.log      502475896 2022/2/23 2   502789952 2022/2/25 2 YES      INACTIVE         ONLINE        12176 NO         NO
/u01/app/oracle/oradata/ora11g/redo06.log      502789952 2022/2/25 2   503003207 2022/2/27 8 YES      INACTIVE         ONLINE        12177 NO         NO
/u01/app/oracle/oradata/ora11g/redo05.log      503003207 2022/2/27 8   503267356 2022/2/28 2 YES      INACTIVE         ONLINE        12178 NO         NO
/u01/app/oracle/oradata/ora11g/redo01.log      503267356 2022/2/28 2   503363497 2022/3/1 10 YES      INACTIVE         ONLINE        12179 NO         NO
/u01/app/oracle/oradata/ora11g/redo02.log      503363497 2022/3/1 10 28147497671             NO       CURRENT          ONLINE        12180 NO         NO
6 rows selected

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
     AND A.NEXT_CHANGE# > 487194949
     AND A.DEST_ID IN (SELECT DEST_ID
                         FROM V$ARCHIVE_DEST_STATUS
                        WHERE STATUS = 'VALID'
                          AND TYPE = 'LOCAL'
                          AND ROWNUM = 1))
SELECT *
  FROM T
 WHERE (FIRST_TIME >=
       TO_DATE('2022-03-01 10:00:00', 'yyyy-mm-dd hh24:mi:ss') AND
       NEXT_TIME <=
       TO_DATE('2022-03-01 11:00:00', 'yyyy-mm-dd hh24:mi:ss'))
    OR (FIRST_TIME <=
       TO_DATE('2022-03-01 10:00:00', 'yyyy-mm-dd hh24:mi:ss') AND
       NEXT_TIME >=
       TO_DATE('2022-03-01 10:00:00', 'yyyy-mm-dd hh24:mi:ss'))
    OR (FIRST_TIME <=
       TO_DATE('2022-03-01 11:00:00', 'yyyy-mm-dd hh24:mi:ss') AND
       (NEXT_TIME >=
       TO_DATE('2022-03-01 11:00:00', 'yyyy-mm-dd hh24:mi:ss') OR
       NEXT_TIME IS NULL));

FILE_NAME                                  FIRST_CHANGE FIRST_TIME           NEXT_CHANGE NEXT_TIME            ARCHIVED STATUS           TYPE            SEQ DICT_START DICT_END
------------------------------------------ ------------ -------------------- ----------- -------------------- -------- ---------------- -------- ---------- ---------- --------
/u01/app/oracle/oradata/ora11g/redo01.log     503267356 2022/2/28 22:00:16     503363497 2022/3/1 10:48:08    YES      INACTIVE         ONLINE        12179 NO         NO
/u01/app/oracle/oradata/ora11g/redo02.log     503363497 2022/3/1 10:48:08    28147497671                      NO       CURRENT          ONLINE        12180 NO         NO
```
����`redo01.log`, `redo02.log`�������ǵ������� `next_time`Ϊ�ձ�ʾ��ǰ��־��Ϊ���ݿ���д�����־�ļ���

3. **�ֶ���ȡ��־�ļ�����ȷ��λ`SCN`**

����־�ļ����ڵı��������־�ھ� ʹ��`online_catalog`��ʽ���ֵ䡣

��Ӵ��ھ����־�ļ���������`redo`�ļ��������ǹ鵵��־�ļ���
```
-- �׸���־�ļ���ӣ���ʹ��NEW
begin
	 DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'/u01/app/oracle/oradata/ora11g/redo01.log',OPTIONS => DBMS_LOGMNR.NEW);
end;
/
-- ������־�ļ���ӣ���ʹ��ADDFILE
begin
	 DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'/u01/app/oracle/oradata/ora11g/redo02.log',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/
```
����ʱ�䷶Χ����ʼ�ھ�
```
BEGIN sys.dbms_logmnr.start_logmnr(startTime => TO_DATE('2022-03-01 10:00:00', 'yyyy-mm-dd hh24:mi:ss'), endTime => TO_DATE('2022-03-01 11:00:00', 'yyyy-mm-dd hh24:mi:ss'), Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);
END;
/
```
ͬʱ��֧�ִ���`SCN`����
```
BEGIN sys.dbms_logmnr.start_logmnr(startScn => 503338281, 
                endScn =>503338307, Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);
END;
/
```
<u>ע�⣺`start_logmnr`����֧���ظ����ã�ÿ�ε��ú��ѯ�����ݲ�һ�������ǵ���`start_logmnr`�����󣬲����ٴε���`add_logfile`������������ھ��������ӡ�</u>

4. **��ѯ�������������ݣ���ȷ��λ`SCN`**

```
 -- 6447354~6447363
 -- ���ȶ�λ��һ��6447354�������ڵ�SCN��
select scn from v$logmnr_contents where seg_name = 'TB_TEST' and sql_redo like '%6447354%';
503339377
 -- ��λ�ڶ���6447363�������ڵ�SCN��
select scn from v$logmnr_contents where seg_name = 'TB_TEST' and sql_redo like '%6447363%';
503339394
SQL> select scn, operation, sql_redo  from v$logmnr_contents where scn >= 503339377 - 10 and scn <= 503339394 + 10;

       SCN OPERAT SQL_REDO
---------- ------ --------------------------------------------------------------------------------
 ......
 503339374 COMMIT commit;
 503339374 START  set transaction read write;
 503339374 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339376 COMMIT commit;<--------------------
 503339377 START  set transaction read write;
 503339377 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339378 COMMIT commit;
 503339378 START  set transaction read write;
 503339378 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339380 COMMIT commit;
 503339381 START  set transaction read write;
 ......
 503339393 START  set transaction read write;
 503339393 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339394 COMMIT commit;
 503339394 START  set transaction read write;
 503339394 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339396 COMMIT commit; <--------------------
 503339397 START  set transaction read write;
 503339397 INSERT insert into "DBA_TEST"."TB_TEST"("ID","NAME","DT","TS","TS1","TS2") values ('644
 503339398 COMMIT commit;
 ......
55 rows selected
```
������ǽ�`SCN`��ǰ��ƫ����`10`��Ϊ�۲�߽����ݵ������������`Debezium`������ʱ��ʹ�õ�����Ϊ`(scn.start, scn.end]`��
���ԣ���`503339376`��Ϊ`scn.start`��ƫ�Ƶ��ϸ������`commit`λ�ã�����`503339396`��Ϊ`scn.end`��ƫ�Ƶ�������`commit`λ�ã���
��Ҫ��ȡָ�����ݣ�**`SCN`��Χ���������ü�¼����ǰ���`start`, `commit`�¼���`SCN`��**��ͬʱע�������е�`scn.start`��ʱ�䲻����ȡ��
���ԣ�����ȷ����`SCN`��ΧΪ`(503339376,503339396]`.

���ֶ��ھ���־�����󣬽�����ǰ�Ự���ͷ����ݿ��PGA�ڴ档

```
begin sys.dbms_logmnr.end_logmnr();
end;
/
```

��ʱ�� �㾫ȷ��λ��`SCN`���䣬����`connector`��������ҵ������ֻ��ȡ��`10`����¼��
�������ֶ���ȡ��־���ݣ��ɿ������û�н�Ϊ��ȷ����**�������**��ʱ�䷶Χ�� ä����־�ǳ��ķ�ʱ�䡣

����ָ��`SCN`��`connector`Ͷ�ݵ�`kafka`���ݣ�Ͷ����ԭ����`topic`, ��ʹ��`transform`��ָ������תͶ��ԭ����`topic`��
������ο����ʵ����


## MySQL

��`MySQL`�У��ݲ�֧�ֶ��`binlog`�ļ��������ھ������Ҫ��feature������ϵ��������ӡ�
��`connector`�����У�����`position.start`, `position.end`, `binlog.file`���߽����ȡֵΪ`[position.start, position.end]`, ���£�

```json
{ "name" : "mysql_timezone113_9",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "mysql_cdc_test.cdc_test:id",
  "database.user": "root",
  "database.server.id": "12",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "hadoop189:9093,hadoop190:9093,hadoop191:9093",
  "database.history.kafka.topic": "mysql_timezone113_9.mysql_cdc_test",
  "database.server.name": "mysql_timezone113_9",
  "database.port": "3306",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "88.88.16.113",
  "database.connectionTimeZone" : "LOCAL",
  "database.password": "root",
  "snapshot.mode": "schema_only",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "mysql_cdc_test.cdc_test",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "position.start": "220244384",
  "position.end": "220248187",
  "binlog.file": "mysql-bin.000417",
  "database.history.store.only.captured.tables.ddl": "true"
}
}
```

**ע�⣺**
1. `snapshot.mode`������Ϊ�ǿ���ģʽ����`schema_only`Ϊ����ȡ���`schema`��Ϣ������ȡ����
2. ����������`position.start`��`position.end`ʱ���ʵ��ſ����䣬��������Ҫ�����ݣ��ڷſ�����ʱ��
   `position`��λ�ã�������`binlog`�ļ��д��ڵ�λ�ã� ����ƾ�����죨`SCN`�ſ��ԣ������辫ȷ��λ`position`, �ο���ȡ`Position`����
3. �������`database.history.store.only.captured.tables.ddl`���ã�����Ϊtrue������ȡ�������`DDL`
4. ֧��ͬһ���õ���ҵ������У��ظ���ȡ���ݣ����ݽ���<u>�ظ�</u>Ͷ����`kafka`��
   �м��ڲ�����`position.start`��`position.end`ʱ��ͨ��ɾ�����ؽ�`connector`�������`name`����`connector`���ȡ`connect-offsets`�е�`offset`��
   `connector`�������`offset`����������
5. ֧��ͬһ��ҵ���޸�`position`��������ӱ�����ٴ����У�ʵ�ֶ���������ȡ����ϸ�ο����ʵ��`MySQL`����
6. ������ָ��`position.start`��ʼ������־�ھ� �ɽ�`position.end`����Ϊ���޴���`999999999999999999`����ͨ����������ô����
7. `connector`�����󣬽���ȡ���õ�`position`������ݣ�������ȡ��Ϻ�`connector`�����Զ��˳��������ɾ���ӿ�ɾ����`connector`

ע�⣬ͨ����־��Ϣ�����`connector`�Ƿ�˳��������

```
......
[2022-03-02 17:37:45,885] INFO Creating thread debezium-mysqlconnector-mysql_timezone113_9-binlog-client (io.debezium.util.Threads:287)
Mar 02, 2022 5:37:45 PM com.github.shyiko.mysql.binlog.BinaryLogClient connect
INFO: Connected to 88.88.16.113:3306 at mysql-bin.000417/220244384 (sid:12, cid:3628570)
[2022-03-02 17:37:45,890] INFO Connected to MySQL binlog at 88.88.16.113:3306, starting at MySqlOffsetContext [sourceInfoSchema=Schema{io.debezium.connector.mysql.Source:STRUourceInfo [currentGtid=null, currentBinlogFilename=mysql-bin.000417, currentBinlogPosition=220672934, currentRowNumber=0, serverId=0, sourceTime=2022-03-02T09:37:45.878Z, thrQuery=null, tableIds=[mysql_cdc_test.cdc_test6], databaseName=mysql_cdc_test], snapshotCompleted=true, transactionContext=TransactionContext [currentTransactionId=null, perTa totalEventCount=0], restartGtidSet=c53f6039-53c0-11e9-873e-00505692d826:351420004-351420984, currentGtidSet=c53f6039-53c0-11e9-873e-00505692d826:351420004-351420984, restartsql-bin.000417, restartBinlogPosition=220672934, restartRowsToSkip=1, restartEventsToSkip=2, currentEventLengthInBytes=0, inTransaction=false, transactionId=null, incrementalIncrementalSnapshotContext [windowOpened=false, chunkEndPosition=null, dataCollectionsToSnapshot=[], lastEventKeySent=null, maximumKey=null]] (io.debezium.connector.mysql.MySEventSource:1323)
[2022-03-02 17:37:45,891] INFO Waiting for keepalive thread to start (io.debezium.connector.mysql.MySqlStreamingChangeEventSource:986)
[2022-03-02 17:37:45,891] INFO Creating thread debezium-mysqlconnector-mysql_timezone113_9-binlog-client (io.debezium.util.Threads:287)
[2022-03-02 17:37:45,991] INFO Keepalive thread is running (io.debezium.connector.mysql.MySqlStreamingChangeEventSource:993)
[2022-03-02 17:37:46,192] INFO Current position is 220687159 greater than 220673168, stopped reading the mysql-bin.000417 (io.debezium.connector.mysql.MySqlStreamingChangeEve
[2022-03-02 17:37:46,194] INFO Stopped reading binlog after 0 events, last recorded offset: {transaction_id=null, ts_sec=1646213662, file=mysql-bin.000417, pos=220673233, gti11e9-873e-00505692d826:351420004-351420985, server_id=1, event=1} (io.debezium.connector.mysql.MySqlStreamingChangeEventSource:1308)
[2022-03-02 17:37:46,194] INFO Finished streaming (io.debezium.pipeline.ChangeEventSourceCoordinator:173)<=====================
......
```
��`Finished streaming`����ʱ��˵���ھ������Ѿ������� ����ɾ���ӿ�ɾ����`connector`

`curl -Ss -X DELETE http://localhost:8083/connectors/mysql_timezone113_9`

### ��ȡ`Position`����

��������Ҫ����`position.start`, `position.end`, `binlog.file`����Ҫ��������֪��������������ĸ�`binlog`�ļ��С�
Ψ�л�Ϥ���ݱ���Ĵ���ʱ�䣬�ſ��ܶ�λ������������ĸ�`binlog`�ļ��С�����޷���֪�����ݱ���Ĵ���ʱ�䣬��ֻ���ֶ�����ÿ��`binlog`�ļ���
��ȷ�������`binlog`�ļ���

��`Oracle`���ƣ����Ҫ��ȷ��λ`position`λ�ã� �����ݷ��������׼ȷʱ��������Ψһ��ʶ�ֶεļ�¼��

������ʾ��ͨ���ֶ�����`binlog`��־����ȡ׼ȷ��`position`λ�á�

��`2022-03-02 16:00~16:30`֮�䣬`cdc_test`�������1~5������5�����ݣ���ȡ5�����ݵ�`position`���䡣

1. **��ȡ��Ҫ������`binlog`**
����`MySQL`�Ķ������ļ���Ŀ¼�� �鿴`binlog`�ļ���ʱ���
```
-rw-r----- 1 mysql mysql 1077462091 Feb 18 14:24 mysql-bin.000415
-rw-r----- 1 mysql mysql 1073742137 Feb 22 17:05 mysql-bin.000416
-rw-r----- 1 mysql mysql  220842150 Mar  2 18:08 mysql-bin.000417
-rw-r----- 1 mysql mysql        117 Feb 22 17:05 mysql-bin.index
```
`mysql-bin.000417`�ļ����Ǵ���������־�ļ���

2. **ʹ��`mysqlbinlog`�ֶ�������־**
```shell
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-datetime='2022-03-02 16:00:00' --stop-datetime='2022-03-02 16:30:00' mysql-bin.000417 > tmp
```
���ڣ���ͨ��`more`, `less`, `vim`������鿴`tmp`�ļ���Ѱ�ҷ���Ҫ���`position`.
```
......
# at 220246874
#220302 16:02:51 server id 1  end_log_pos 220246905 CRC32 0x5905fed8    Xid = 217071631
COMMIT/*!*/;
# at 220246905 <===============================================================
#220302 16:02:52 server id 1  end_log_pos 220246970 CRC32 0x0fd98cf2    GTID    last_committed=347283   sequence_number=347284  rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'c53f6039-53c0-11e9-873e-00505692d826:351420010'/*!*/; <===============================================================
# at 220246970
#220302 16:02:52 server id 1  end_log_pos 220247057 CRC32 0x73e192d6    Query   thread_id=3621893       exec_time=0     error_code=0
SET TIMESTAMP=1646208172/*!*/;
BEGIN
/*!*/;
# at 220247057
#220302 16:02:52 server id 1  end_log_pos 220247123 CRC32 0x5ebeb944    Table_map: `mysql_cdc_test`.`cdc_test` mapped to number 3156179
# at 220247123
#220302 16:02:52 server id 1  end_log_pos 220247172 CRC32 0x0c22dc19    Write_rows: table id 3156179 flags: STMT_END_F
### INSERT INTO `mysql_cdc_test`.`cdc_test`
### SET
###   @1=1
###   @2='tft1'
###   @3=1646208172
# at 220247172
#220302 16:02:52 server id 1  end_log_pos 220247203 CRC32 0x3bbf25c9    Xid = 217071661
COMMIT/*!*/;
# at 220247203
#220302 16:02:55 server id 1  end_log_pos 220247268 CRC32 0x626ccd4e    GTID    last_committed=347284   sequence_number=347285  rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'c53f6039-53c0-11e9-873e-00505692d826:351420011'/*!*/;
# at 220247268
......
#220302 16:03:43 server id 1  end_log_pos 220252186 CRC32 0x95385003    Write_rows: table id 3156179 flags: STMT_END_F
### INSERT INTO `mysql_cdc_test`.`cdc_test`
### SET
###   @1=5
###   @2='tft5'
###   @3=1646208223
# at 220252186  <===============================================================
#220302 16:03:43 server id 1  end_log_pos 220252217 CRC32 0x42151987    Xid = 217072477
COMMIT/*!*/; <===============================================================
# at 220252217
#220302 16:03:47 server id 1  end_log_pos 220252282 CRC32 0xbd26069b    GTID    last_committed=347297   sequence_number=347298  rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'c53f6039-53c0-11e9-873e-00505692d826:351420024'/*!*/;
# at 220252282
#220302 16:03:47 server id 1  end_log_pos 220252366 CRC32 0x34320f6f    Query   thread_id=3623104       exec_time=0     error_code=0
SET TIMESTAMP=1646208227/*!*/;
/*!\C utf8mb4 *//*!*/;
SET @@session.character_set_client=45,@@session.collation_connection=45,@@session.collation_server=8/*!*/;
BEGIN
/*!*/;
# at 220252366
......
```

����־������`220246905~220252186`������������Ҫ��`position`�����ˣ���`220246905`��Ϊ��ʼλ�ã�`220252186`��Ϊ����λ�á�
����`GTID`�����ݿ⣬һ������������¼����£�

```
mysql> show binlog events in  'mysql-bin.000417' from 220182341 limit 50 ;
+------------------+-----------+-------------+-----------+-------------+---------------------------------------------------------------------------+
| Log_name         | Pos       | Event_type  | Server_id | End_log_pos | Info                                                                      |
+------------------+-----------+-------------+-----------+-------------+---------------------------------------------------------------------------+
| mysql-bin.000417 | 220182341 | Gtid        |         1 |   220182406 | SET @@SESSION.GTID_NEXT= 'c53f6039-53c0-11e9-873e-00505692d826:351419872' |
| mysql-bin.000417 | 220182406 | Query       |         1 |   220182490 | BEGIN                                                                     |
| mysql-bin.000417 | 220182490 | Table_map   |         1 |   220182567 | table_id: 3155096 (k8s_xxl_job.xxl_job_registry)                          |
| mysql-bin.000417 | 220182567 | Update_rows |         1 |   220182705 | table_id: 3155096 flags: STMT_END_F                                       |
| mysql-bin.000417 | 220182705 | Xid         |         1 |   220182736 | COMMIT /* xid=217060149 */                                                |
+------------------+-----------+-------------+-----------+-------------+---------------------------------------------------------------------------+
```

���Կ�ʼλ�����¼�`SET @@SESSION.GTID_NEXT=`���ڵ�λ�ã� ����λ��Ϊ`COMMIT`�¼����ڵ�λ�á�


# ���ʵ��

## ��`Oracle`��־�ھ��б��`SCN`������

��`Oracle`��־�ھ��У����������õ�`SCN`��������ݲ��������󣬻������Ӷ������������ھ�ʱ����������Ҫ��`Connector`�����ý����޸ģ�������ִ�С�

```json
{
     "name": "devdboragch1",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch1",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "schema_only",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "log.mining.transaction.retention.hours" : "1",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.tb_test",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch1",
         "scn.start": "503177831",
         "scn.end": "503177853",
         "database.history.store.only.captured.tables.ddl": "true"
     }
  }
```

��ִ��������־�ھ�ʱ�����ֻ������ű�Ҳ��Ҫ������־�ھ򣬲���`SCN`������ͬ������������`tb_test14`Ϊ���б� `tb_test15`Ϊִ�����������ھ�ʱ
�½��ı���ʱ�����ǵ�������������Ϊ��

```json
{
     "name": "devdboragch1",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id;dba_test.tb_test14:id;dba_test.tb_test15:id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch1",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "schema_only",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "log.mining.transaction.retention.hours" : "1",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.tb_test,dba_test.tb_test14,dba_test.tb_test15",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch1",
         "scn.start": "503177831",
         "scn.end": "503181118",
         "database.history.store.only.captured.tables.ddl": "true"
     }
  }
```

�������ý�������`scn.end`, `message.key.columns`, `table.include.list`����û�е���`name`, `database.server.name`, 
`database.history.kafka.topic`.

```shell
# ɾ���ؽ�connector
./delete_connector.sh devdboragch1
./create_connector_from_json.sh devdbora0.json
```

�����õ�`dba_test.tb_test14`,`dba_test.tb_test15`, �ڴ�`connector`�£�ʵ���������ھ� ����`dba_test.tb_test`�������ٴα�Ͷ����`kafka`��

## ��`Oracle`ָ��`SCN`������Ͷ����ԭ`topic`

ͨ����˵����ִ��ָ��`SCN`�����ݵ���ȡʱ��������ԭ`connector`�����У�һ�㵥����������������������`connector`��
������������ߣ�֧�ֳٵ����ݵĴ��������а汾���� �ɽ���`connector`�����ݣ���·����ԭ`connector`��`topic`�С�

�������е�`connector`����Ϊ`devdboragch0`�� ����������`connector`����Ϊ`devdboragch1`���������£�

```json
{
     "name": "devdboragch1",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id;dba_test.tb_test14:id;dba_test.tb_test15:id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch1",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "schema_only",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "log.mining.transaction.retention.hours" : "1",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.tb_test,dba_test.tb_test14,dba_test.tb_test15",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch1",
         "database.history.store.only.captured.tables.ddl": "true",
         "scn.start": "503339376",
         "scn.end": "503339396",
         "transforms" : "Reroute0",
         "transforms.Reroute0.type" : "io.debezium.transforms.ByLogicalTableRouter",
         "transforms.Reroute0.topic.regex" : "dev_oracle_gch1.DBA_TEST.TB_TEST",
         "transforms.Reroute0.topic.replacement" : "dev_oracle_gch0.DBA_TEST.TB_TEST",
         "transforms.Reroute0.key.enforce.uniqueness" : "false"
     }
  }
```

˵������"dev_oracle_gch1.DBA_TEST.TB_TEST"������·����"dev_oracle_gch0.DBA_TEST.TB_TEST"��"dev_oracle_gch1.DBA_TEST.TB_TEST"���`Topic`�У������������ݡ�

ͬʱ��֧�ֶ��·�ɹ�������ã�����
```
"transforms" : "Reroute,Reroute1",
"transforms.Reroute.type" : "io.debezium.transforms.ByLogicalTableRouter",
"transforms.Reroute.topic.regex" : "(.*)J_TRIP_OPEN_PART(.*)",
"transforms.Reroute.topic.replacement" : "$1J_TRIP_OPEN_PART",
"transforms.Reroute.key.enforce.uniqueness" : "false",
"transforms.Reroute1.type" : "io.debezium.transforms.ByLogicalTableRouter",
"transforms.Reroute1.topic.regex" : "(.*)DBA_TEST(.*)",
"transforms.Reroute1.topic.replacement" : "$1DBA_TEST",
"transforms.Reroute1.key.enforce.uniqueness" : "false"
```

## ��`MySQL`��־�ھ��б��`Position`������

��`MySQL`��־�ھ��У����������õ�`Position`��������ݲ��������󣬻������Ӷ������������ھ�ʱ����������Ҫ��`Connector`�����ý����޸ģ�������ִ�С�

```json
{ "name" : "mysql_timezone113_9",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "mysql_cdc_test.cdc_test:id",
  "database.user": "root",
  "database.server.id": "12",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "hadoop189:9093,hadoop190:9093,hadoop191:9093",
  "database.history.kafka.topic": "mysql_timezone113_9.mysql_cdc_test",
  "database.server.name": "mysql_timezone113_9",
  "database.port": "3306",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "88.88.16.113",
  "database.connectionTimeZone" : "LOCAL",
  "database.password": "root",
  "snapshot.mode": "schema_only",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "mysql_cdc_test.cdc_test",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "position.start": "220244384",
  "position.end": "220248187",
  "binlog.file": "mysql-bin.000417",
  "database.history.store.only.captured.tables.ddl": "true"
}
}
```

��ִ��������־�ھ�ʱ�����ֻ���һ�ű�Ҳ��Ҫ������־�ھ򣬲���`Position`������ͬ��������`cdc_test6`Ϊִ�����������ھ�ʱ�½��ı����Ҳ��������ݡ�
��ʱ�����ǵ�������������Ϊ��

```json
{ "name" : "mysql_timezone113_9",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "mysql_cdc_test.cdc_test:id;mysql_cdc_test.cdc_test6:id",
  "database.user": "root",
  "database.server.id": "12",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "hadoop189:9093,hadoop190:9093,hadoop191:9093",
  "database.history.kafka.topic": "mysql_timezone113_9.mysql_cdc_test",
  "database.server.name": "mysql_timezone113_9",
  "database.port": "3306",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "88.88.16.113",
  "database.connectionTimeZone" : "LOCAL",
  "database.password": "root",
  "snapshot.mode": "schema_only",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "mysql_cdc_test.cdc_test,mysql_cdc_test.cdc_test6",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "position.start": "220244384",
  "position.end": "220673168",
  "binlog.file": "mysql-bin.000417",
  "database.history.store.only.captured.tables.ddl": "true"
}
}
```

�������ý�������`position.end`, `message.key.columns`, `table.include.list`����û�е���`name`, `database.server.name`, 
`database.history.kafka.topic`.

```shell
# ɾ���ؽ�connector
./delete_connector.sh mysql_timezone113_9
./create_connector_from_json.sh mysql_timezone.json
```

�����õ�`mysql_cdc_test.cdc_test6`, �ڴ�`connector`�£�ʵ���������ھ� ����`mysql_cdc_test.cdc_test`�������ٴα�Ͷ����`kafka`��