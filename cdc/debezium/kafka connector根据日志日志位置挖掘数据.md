# 背景

在实际生产中，我们可能面临着挖掘日志指定范围的数据需求，例如补数。


# 目标

使用`debezium connector`，抽取`Oracle/MySQL`日志中指定范围的数据，将数据投递至`Kafka Topic`.


# 特性

* 通过指定`Oracle`开始`SCN`号和结束`SCN`号，解析指定区间的日志数据，将变更数据投递至`Kafka`
* 通过指定`MySQL`的二进制文件名、开始`Position`位置和结束`Position`位置，解析指定区间的日志数据，将变更数据投递至`Kafka`
* 合并`Oracle`读取日志视图的重试机制以解决日志可能不存在的BUG，因为`Oracle`不在一个事务中操作`V$LOG`和`V$ARCHIVED_LOG`，
  当`redolog`在进行归档时，通过既定的`SQL`可能会查询不到满足条件的日志文件，程序将抛出无法找满足指定`SCN`的日志文件异常
* 加入`Oracle PGA`限制，避免PGA无限增加，并引入动态修改`log.mining.strategy`功能，以应对变更数据表结构


# 基线及更改

基于Master分支`Tag1.8.0.Final`版本进行修改。

## Oracle部分

解析指定`SCN`号区间内日志数据功能、限制`PGA`内存大小的功能：
`io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource#execute`

`Oracle`读取日志视图的重试机制：
`io.debezium.connector.oracle.logminer.LogMinerHelper#setLogFilesForMining`

## MySQL部分

解析指定日志指定Position区间日志：  
`io.debezium.connector.mysql.MySqlConnectorTask#start`
`io.debezium.connector.mysql.MySqlStreamingChangeEventSource#handleEvent`
`io.debezium.connector.mysql.MySqlStreamingChangeEventSource#execute`


# 使用

## Oracle

`Oracle connector`配置中需额外增加`scn.start`和`scn.end`, `Connector`会解析`(scn.start, scn.end]`之间的数据。因为`Debezium`源代码中，使用的左开右闭区间进行取数，这里并未修改这部分源代码。

当`Oracle`架构为**单机模式**时，使用如下示例的配置：
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

当`Oracle`架构为**RAC**时，需增加特有的配置项`rac.node`，如：
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


**注意：**
1. `snapshot.mode`须设置为非快照模式，如`schema_only`为仅拉取相关`schema`信息，不拉取数据
2. 建议在配置`scn.start`和`scn.end`时，适当放开区间，以囊括必要的数据
3. 建议添加`database.history.store.only.captured.tables.ddl`配置，设置为true，不获取其他表的`DDL`
4. 支持同一配置的作业多次运行，重复拉取数据，数据将会<u>重复</u>投递至`kafka`，
   切记在不配置`scn.start`和`scn.end`时，通过删除和重建`connector`（不变更`name`），`connector`会读取`connect-offsets`中的`offset`，
   `connector`会从`offset`处继续处理
5. 支持同一作业，修改`SCN`区间或增加表项后，再次运行，实现额外数据挖取，详细参考最佳实践`Oracle`部分
6. 如果想从指定`scn.start`开始进行日志挖掘， 可将`scn.end`配置为无限大（如`999999999999999999`），通常不建议这么操作
7. `connector`启动后，将挖取配置的`SCN`间的数据，数据挖取完毕后，`connector`不会自动退出，需调用删除接口删除该`connector`

注意根据日志，辨别`connector`的挖取是否结束。

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
从上述日志可以看出，`Streaming metrics`的度量信息，里面包括挖取的数据量、速率、日志状态等，后文便是`Finished streaming`，
表示流式挖取数据已经结束，便可删除该`connector`。

`curl -Ss -X DELETE http://localhost:8083/connectors/devdboragch1`

### 获取`SCN`区间

想通过指定的`SCN`区间，实现指定数据的挖掘，则使用者必须清楚，想挖掘的数据所在`SCN`区间。
1. 你清楚数据发生`DML`的时间范围（通过表记录时间、或者应用日志等）， 则可以使用`timestamp_to_scn`来转换成`SCN`号，
   如`select timestamp_to_scn(to_timestamp('18/02/2022 15:22:44','DD/MM/YYYY HH24:MI:SS')) as scn from dual;`
2. 如果数据发生变更的时间范围无法获知， 但清楚数据（记录）的关键字段信息，如主键、唯一键字段的值，则可通过手动挖掘日志定位`SCN`号，
   此操作较为繁琐，如果进行多个日志文件同时挖掘，则存在PGA溢出等问题，不推荐使用，可以参考本地文档《oracle logminer.pdf》
3. 如果有必要精确获取`SCN`区间，则使用`Oracle`日志挖掘工具手动挖掘日志，查看`v$logmnr_contents`中是否存在符合要求的数据，
   再精确地确定`SCN`区间，可以参考本地文档《oracle logminer.pdf》，详情参考下文
4. 如果无`Oracle`数据库基础， 可借助`Connector`进行大致盲挖，传入大致的`SCN`区间，将数据投递至`kafka`后，再确定数据是否符合要求，
   不断尝试，直至最终精准的`SCN`区间确定
   

通常来说， 一般使用1、3步骤可精确定位`SCN`号，下游任务支持重复数据的容错处理，则不需精确的`SCN`区间。
如果无法获知数据发生`DML`的时间范围，则无法获得大致的`SCN`号，通过盲挖日志工作量巨大。下面将演示，如何通过数据发生变更的大致时间范围，
确定准确的`SCN`区间。

假设已知`Oracle`表`tb_test`在`2022-03-01 10：00`至`11：00`发生了大量数据插入，仅挖取主键`id`为`6447354~6447363`的数据。

1. **查看数据库目前支持数据挖掘的最小`SCN`**
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
`502158888`为数据库最小的`SCN`号，`2022/2/21 22:08`为数据库能挖取日志的最小时间，即小于该时间的数据，则无法通过日志进行挖取。
从示例中，发生数据变更的时间在`2022-03-01 10：00`至`11：00`，大于最小数据库最小时间，这部分数据仍然存于日志中，可进行挖取。
此时，需定位这部分数据在哪个日志文件中。

2. **查看符合条件的日志文件**
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
发现`redo01.log`, `redo02.log`满足我们的条件， `next_time`为空表示当前日志，为数据库正写入的日志文件。

3. **手动挖取日志文件，精确定位`SCN`**

在日志文件所在的本库进行日志挖掘， 使用`online_catalog`形式的字典。

添加待挖掘的日志文件，可以是`redo`文件，可以是归档日志文件。
```
-- 首个日志文件添加，需使用NEW
begin
	 DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'/u01/app/oracle/oradata/ora11g/redo01.log',OPTIONS => DBMS_LOGMNR.NEW);
end;
/
-- 后续日志文件添加，则使用ADDFILE
begin
	 DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'/u01/app/oracle/oradata/ora11g/redo02.log',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/
```
传入时间范围，开始挖掘
```
BEGIN sys.dbms_logmnr.start_logmnr(startTime => TO_DATE('2022-03-01 10:00:00', 'yyyy-mm-dd hh24:mi:ss'), endTime => TO_DATE('2022-03-01 11:00:00', 'yyyy-mm-dd hh24:mi:ss'), Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);
END;
/
```
同时，支持传入`SCN`区间
```
BEGIN sys.dbms_logmnr.start_logmnr(startScn => 503338281, 
                endScn =>503338307, Options=>dbms_logmnr.DICT_FROM_ONLINE_CATALOG);
END;
/
```
<u>注意：`start_logmnr`过程支持重复调用，每次调用后查询的数据不一样，但是调用`start_logmnr`方法后，不能再次调用`add_logfile`方法，需结束挖掘后再行添加。</u>

4. **查询满足条件的数据，精确定位`SCN`**

```
 -- 6447354~6447363
 -- 首先定位第一条6447354数据所在的SCN号
select scn from v$logmnr_contents where seg_name = 'TB_TEST' and sql_redo like '%6447354%';
503339377
 -- 定位第二条6447363数据所在的SCN号
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
这里，我们将`SCN`号前后偏移了`10`，为观察边界数据的上下文情况。`Debezium`在挖数时，使用的条件为`(scn.start, scn.end]`。
所以，将`503339376`作为`scn.start`（偏移到上个事务的`commit`位置），将`503339396`作为`scn.end`（偏移到本事务`commit`位置）。
即要挖取指定数据，**`SCN`范围必须囊括该记录数据前后的`start`, `commit`事件的`SCN`号**，同时注意配置中的`scn.start`的时间不会挖取。
所以，最终确定的`SCN`范围为`(503339376,503339396]`.

在手动挖掘日志结束后，结束当前会话，释放数据库的PGA内存。

```
begin sys.dbms_logmnr.end_logmnr();
end;
/
```

此时， 便精确定位了`SCN`区间，配置`connector`并启动作业，发现只抽取了`10`条记录。
从上述手动挖取日志数据，可看出如果没有较为明确数据**发生变更**的时间范围， 盲挖日志非常耗费时间。

若想指定`SCN`的`connector`投递的`kafka`数据，投递至原来的`topic`, 可使用`transform`将指定数据转投至原来的`topic`。
具体请参考最佳实践。


## MySQL

在`MySQL`中，暂不支持多个`binlog`文件的连续挖掘，如果需要该feature，请联系开发者添加。
在`connector`配置中，增加`position.start`, `position.end`, `binlog.file`，边界情况取值为`[position.start, position.end]`, 如下：

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

**注意：**
1. `snapshot.mode`须设置为非快照模式，如`schema_only`为仅拉取相关`schema`信息，不拉取数据
2. 建议在配置`position.start`和`position.end`时，适当放开区间，以囊括必要的数据，在放开区间时，
   `position`的位置，必须是`binlog`文件中存在的位置， 不能凭空捏造（`SCN`号可以）。如需精确定位`position`, 参考获取`Position`区间
3. 建议添加`database.history.store.only.captured.tables.ddl`配置，设置为true，不获取其他表的`DDL`
4. 支持同一配置的作业多次运行，重复拉取数据，数据将会<u>重复</u>投递至`kafka`，
   切记在不配置`position.start`和`position.end`时，通过删除和重建`connector`（不变更`name`），`connector`会读取`connect-offsets`中的`offset`，
   `connector`会从上述`offset`处继续处理
5. 支持同一作业，修改`position`区间或增加表项后，再次运行，实现额外数据挖取，详细参考最佳实践`MySQL`部分
6. 如果想从指定`position.start`开始进行日志挖掘， 可将`position.end`配置为无限大（如`999999999999999999`），通常不建议这么操作
7. `connector`启动后，将挖取配置的`position`间的数据，数据挖取完毕后，`connector`不会自动退出，需调用删除接口删除该`connector`

注意，通过日志信息，辨别`connector`是否顺利结束。

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
当`Finished streaming`出现时，说明挖掘任务已经结束， 调用删除接口删除该`connector`

`curl -Ss -X DELETE http://localhost:8083/connectors/mysql_timezone113_9`

### 获取`Position`区间

配置项中要求传入`position.start`, `position.end`, `binlog.file`，这要求必须清楚知道变更的数据在哪个`binlog`文件中。
唯有获悉数据变更的大致时间，才可能定位变更的数据在哪个`binlog`文件中。如果无法获知连数据变更的大致时间，则只有手动分析每个`binlog`文件，
以确定所需的`binlog`文件。

和`Oracle`类似，如果要精确定位`position`位置， 需数据发生变更的准确时间戳或带有唯一标识字段的记录。

下面演示，通过手动分析`binlog`日志，获取准确的`position`位置。

在`2022-03-02 16:00~16:30`之间，`cdc_test`表插入了1~5，共计5条数据，获取5条数据的`position`区间。

1. **获取需要分析的`binlog`**
进入`MySQL`的二进制文件夹目录， 查看`binlog`文件的时间戳
```
-rw-r----- 1 mysql mysql 1077462091 Feb 18 14:24 mysql-bin.000415
-rw-r----- 1 mysql mysql 1073742137 Feb 22 17:05 mysql-bin.000416
-rw-r----- 1 mysql mysql  220842150 Mar  2 18:08 mysql-bin.000417
-rw-r----- 1 mysql mysql        117 Feb 22 17:05 mysql-bin.index
```
`mysql-bin.000417`文件，是待分析的日志文件。

2. **使用`mysqlbinlog`手动解析日志**
```shell
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-datetime='2022-03-02 16:00:00' --stop-datetime='2022-03-02 16:30:00' mysql-bin.000417 > tmp
```
现在，可通过`more`, `less`, `vim`等命令，查看`tmp`文件，寻找符合要求的`position`.
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

从日志看出，`220246905~220252186`，便是我们需要的`position`区间了，即`220246905`作为开始位置，`220252186`作为结束位置。
开启`GTID`的数据库，一个事务包含的事件如下：

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

所以开始位置是事件`SET @@SESSION.GTID_NEXT=`所在的位置， 结束位置为`COMMIT`事件所在的位置。


# 最佳实践

## 在`Oracle`日志挖掘中变更`SCN`区间或表

在`Oracle`日志挖掘中，当发现配置的`SCN`区间的数据不满足需求，或需增加额外表项的数据挖掘时，我们则需要对`Connector`的配置进行修改，并重新执行。

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

在执行上述日志挖掘时，发现还有两张表也需要进行日志挖掘，并且`SCN`区间需同步调整。其中`tb_test14`为既有表， `tb_test15`为执行上述数据挖掘时
新建的表。此时，我们调整上述的配置为：

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

上述配置仅调整了`scn.end`, `message.key.columns`, `table.include.list`，并没有调整`name`, `database.server.name`, 
`database.history.kafka.topic`.

```shell
# 删除重建connector
./delete_connector.sh devdboragch1
./create_connector_from_json.sh devdbora0.json
```

新配置的`dba_test.tb_test14`,`dba_test.tb_test15`, 在此`connector`下，实现了数据挖掘， 并且`dba_test.tb_test`的数据再次被投递至`kafka`。

## 将`Oracle`指定`SCN`的数据投递至原`topic`

通常来说，在执行指定`SCN`间数据的挖取时，不干涉原`connector`的运行，一般单独启动用其他名字命名的`connector`。
如果下游消费者，支持迟到数据的处理，并且有版本管理， 可将新`connector`的数据，重路由至原`connector`的`topic`中。

正常运行的`connector`名称为`devdboragch0`， 单独新启的`connector`名称为`devdboragch1`，配置如下：

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

说明：将"dev_oracle_gch1.DBA_TEST.TB_TEST"的数据路由至"dev_oracle_gch0.DBA_TEST.TB_TEST"，"dev_oracle_gch1.DBA_TEST.TB_TEST"这个`Topic`中，将不留存数据。

同时，支持多个路由规则的配置，例：
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

## 在`MySQL`日志挖掘中变更`Position`区间或表

在`MySQL`日志挖掘中，当发现配置的`Position`区间的数据不满足需求，或需增加额外表项的数据挖掘时，我们则需要对`Connector`的配置进行修改，并重新执行。

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

在执行上述日志挖掘时，发现还有一张表也需要进行日志挖掘，并且`Position`区间需同步调整。`cdc_test6`为执行上述数据挖掘时新建的表，并且插入了数据。
此时，我们调整上述的配置为：

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

上述配置仅调整了`position.end`, `message.key.columns`, `table.include.list`，并没有调整`name`, `database.server.name`, 
`database.history.kafka.topic`.

```shell
# 删除重建connector
./delete_connector.sh mysql_timezone113_9
./create_connector_from_json.sh mysql_timezone.json
```

新配置的`mysql_cdc_test.cdc_test6`, 在此`connector`下，实现了数据挖掘， 并且`mysql_cdc_test.cdc_test`的数据再次被投递至`kafka`。