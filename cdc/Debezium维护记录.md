# 目标

本文记录常用的Debezium维护笔记。

# 跳过无法处理的DML

## 症状表现
```
...
Caused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed
...
```

## 解决
一般发生在源库不正确地执行与Connector配置中相关表的DDL语句，导致Logminer无最新字典无法识别日志中的字段。

通常来说，发生此类情况，Connector无法自愈，需重建或修复Connector History topic并跳过这部分日志。

1. 从Git仓库拉取最新的Debezium Connector配置
2. 执行connector的删除：`curl -X DELETE http://10.50.253.6:8085/connectors/oracle_tftfxq`
3. 重置对应connector的offset位置：`select current_scn from v$database; `276598572096；
   修改脚本/opt/kafka_2.12-2.7.0_1/connector-json/debezium-util.sh中的connector名称与`scn`（276598572096）
   执行脚本`bash debezium-util.sh`, 将数据投递至connector-offset topic中
4. 从History topic获取较新的Schema DDL message信息
   Query history topic data , you can use KSQL of kafka-eagle(path : messages - topic - ksql).
   For example, `select * from oracle_tsm_his where `partition` in (0) and `msg` like '%T_ACT_TRADE_DETAIL%'`
5. 将上述获取到的数据中SCN、COMMITTED_SCN，修改为略小于276598572096后，将数据投递至history topic
   Here, we send messages to history topic(such as oracle_ups_his) via kafka-eagle. 
   Enter the web ui , http://namenode2:8049/topic/mock, path : MESSAGES -- TOPICS -- MOCK
6. 新建并启动connector, `curl -Ss -X POST http://namenode2:8084/connectors/connector_name/tasks/0/restart`
7. 验证connector启动成功，查看日志`tailf /opt/kafka_2.12-2.7.0_1/logs/connect.log`
   ```For connector oracle_tftfxq, Oracle Session UGA 2.97MB (max = 3.15MB), PGA 155.32MB (max = 235.45MB)```
   注意：N1、N2的日志路径为/opt/kafka_2.12-2.7.0_1/logs/connect.log, D1-D5的日志路径为/opt/kafka_2.12-2.7.0/logs/connect.log
   
TODO: 补数和修复受影响作业

Note：如何正确实施DDL，请参考文档《oracle cdc table structure evolution.sql》



# NPE occurs when getColumnValues

## 症状表现
```
[2023-05-22 10:28:58,438] INFO Already applied 1861 database changes (io.debezium.relational.history.SchemaHistoryMetrics:140)
......
[2023-05-22 10:35:35,172] ERROR Producer failure (io.debezium.pipeline.ErrorHandler:57)
java.lang.NullPointerException 
        at io.debezium.connector.oracle.xstream.XStreamChangeRecordEmitter.getColumnValues(XStreamChangeRecordEmitter.java:59)
        at io.debezium.connector.oracle.xstream.XStreamChangeRecordEmitter.<init>(XStreamChangeRecordEmitter.java:35)
        at io.debezium.connector.oracle.xstream.LcrEventHandler.dispatchDataChangeEvent(LcrEventHandler.java:244)
        at io.debezium.connector.oracle.xstream.LcrEventHandler.processRowLCR(LcrEventHandler.java:149) 
        at io.debezium.connector.oracle.xstream.LcrEventHandler.processLCR(LcrEventHandler.java:117)
        at oracle.streams.XStreamOut.XStreamOutReceiveLCRCallbackNative(Native Method)
        at oracle.streams.XStreamOut.receiveLCRCallback(Unknown Source)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:125)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:45)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.streamEvents(ChangeEventSourceCoordinator.java:196)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.executeChangeEventSources(ChangeEventSourceCoordinator.java:163)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.lambda$start$0(ChangeEventSourceCoordinator.java:121) 
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
        at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128) 
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628) 
        at java.base/java.lang.Thread.run(Thread.java:834)
[2023-05-22 10:35:35,176] ERROR Producer failure (io.debezium.pipeline.ErrorHandler:57) 
java.lang.NullPointerException 
        at io.debezium.connector.oracle.xstream.XStreamChangeRecordEmitter.getColumnValues(XStreamChangeRecordEmitter.java:59)
        at io.debezium.connector.oracle.xstream.XStreamChangeRecordEmitter.<init>(XStreamChangeRecordEmitter.java:35)
        at io.debezium.connector.oracle.xstream.LcrEventHandler.dispatchDataChangeEvent(LcrEventHandler.java:244)
        at io.debezium.connector.oracle.xstream.LcrEventHandler.processRowLCR(LcrEventHandler.java:149)
        at io.debezium.connector.oracle.xstream.LcrEventHandler.processLCR(LcrEventHandler.java:117) 
        at oracle.streams.XStreamOut.XStreamOutReceiveLCRCallbackNative(Native Method)
        at oracle.streams.XStreamOut.receiveLCRCallback(Unknown Source)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:125)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:45)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.streamEvents(ChangeEventSourceCoordinator.java:196)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.executeChangeEventSources(ChangeEventSourceCoordinator.java:163)
```

## 解决
检查schema变化历史topic，这里是oracle_tsm.schema-changes.inventory

```
{
  "source" : {
    "server" : "oracle_tsm"
  },
  "position" : {
    "transaction_id" : null,
    "lcr_position" : "0046437735fa000000010000000100464377358a000000010000000101",
    "snapshot_scn" : "299510708387"
  },
  "ts_ms" : 1684722538436,
  "databaseName" : "TFTONG",
  "schemaName" : "TFT_TSM",
  "ddl" : "create table temp_lcq_01 as\nselect seq,userid,userid as msisdn\n from temp_lcq_02\n where 1<>1\n;",
  "tableChanges" : [ {
    "type" : "CREATE",
    "id" : "\"TFTONG\".\"TFT_TSM\".\"TEMP_LCQ_01\"",
    "table" : {
      "defaultCharsetName" : null,
      "primaryKeyColumnNames" : [ ],
      "columns" : [ ],
      "attributes" : [ ]
    },
    "comment" : null
  } ]
}
```

这里，使用了CREATE TABLE AS SELECT ...的语句， Debezium没有获取到schema变更的字段信息（Xstream、LogMiner
针对上述DDL均没提供字段信息）

手动构造oracle_tsm.schema-changes.inventory所需的元信息，发送至topic中，重启connector task可解决这个问题，
因为lcr_position准确，所以构造的schema-change不会造成CDC数据遗漏。
```
{
  "source" : {
    "server" : "oracle_tsm"
  },
  "position" : {
    "transaction_id" : null,
    "lcr_position" : "0046437735fa000000010000000100464377358a000000010000000101",
    "snapshot_scn" : "299510708387"
  },
  "ts_ms" : 1684722538436,
  "databaseName" : "TFTONG",
  "schemaName" : "TFT_TSM",
  "ddl" : "create table temp_lcq_01 as\nselect seq,userid,userid as msisdn\n from temp_lcq_02\n where 1<>1\n;",
  "tableChanges" : [ {
    "type" : "CREATE",
    "id" : "\"TFTONG\".\"TFT_TSM\".\"TEMP_LCQ_01\"",
    "table" : {
      "defaultCharsetName" : null,
      "primaryKeyColumnNames" : [ ],
      "columns" : [ {
        "name" : "SEQ",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 32,
        "position" : 1,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "USERID",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 32,
        "position" : 2,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "MSISDN",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 32,
        "position" : 3,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }],
      "attributes" : [ ]
    },
    "comment" : null
  } ]
}

```

可使用kafka-eagle工具的topics-mock，将上述信息发送至oracle_tsm.schema-changes.inventory

参考：  
https://issues.redhat.com/browse/DBZ-6373  
https://issues.redhat.com/browse/DBZ-6370



# ORA-26804: Apply "XXX" is disabled

## 症状表现

```
[2023-05-24 15:18:10,224] ERROR WorkerSourceTask{id=oracle_tftfxq-0} Task threw an uncaught and unrecoverable exception. Task is being killed and will not recover until manually restarted (org.apache.kafka.connect.runtime.WorkerTask:187)
org.apache.kafka.connect.errors.ConnectException: An exception occurred in the change event producer. This connector will be stopped.
        at io.debezium.pipeline.ErrorHandler.setProducerThrowable(ErrorHandler.java:72)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:144)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:45)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.streamEvents(ChangeEventSourceCoordinator.java:205)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.executeChangeEventSources(ChangeEventSourceCoordinator.java:172)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.lambda$start$0(ChangeEventSourceCoordinator.java:118)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
        at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
        at java.base/java.lang.Thread.run(Thread.java:834)
Caused by: oracle.streams.StreamsException: ORA-26804: Apply "DBZXOUT" is disabled.


        at oracle.streams.XStreamOut.XStreamOutReceiveLCRCallbackNative(Native Method)
        at oracle.streams.XStreamOut.receiveLCRCallback(Unknown Source)
        at io.debezium.connector.oracle.xstream.XstreamStreamingChangeEventSource.execute(XstreamStreamingChangeEventSource.java:125)
        ... 9 more
```

## 解决

发生Apply server不可用的情况，可能是因为数据库端在维护Xstream相关进程，例如使用ALTER_OUTBOUND过程
修改CAPTURE进程的读取偏移量，会造成相关进程自动重启。

重启Connector task即可：curl -X POST http://KAFKA_NODE:8084/connectors/CONNECTOR_NAME/tasks/0/restart



# Xstream CDC链路无数据流入

## 症状表现

通过kafka restful api查看connector运行状态正常，但是从grafana dashboard中无数据流入，甚至触发告警。
```
[root@preRTDH-kafka201 connector-json]# ./get_all_connector_status.sh 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    60  100    60    0     0   2683      0 --:--:-- --:--:-- --:--:--  2727
{"name":"oracle_ups","connector":{"state":"RUNNING","worker_id":"10.50.253.202:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.202:8084"}],"type":"source"}
{"name":"oracle_tftfxq","connector":{"state":"RUNNING","worker_id":"10.50.253.203:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.203:8084"}],"type":"source"}
{"name":"oracle_tsm_gch","connector":{"state":"RUNNING","worker_id":"10.50.253.201:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.201:8084"}],"type":"source"}
{"name":"oracle_tsm","connector":{"state":"RUNNING","worker_id":"10.50.253.201:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.201:8084"}],"type":"source"}
```

Grafana中表现就是Oracle XXX TotalNumberOfEventsSeen Rate Dashboard直接躺0，触发告警

## 解决

直接尝试重启Connector task, 查看日志输出

```shell
export KAFKA_CONN_PORT=8084
cd /opt/kafka_2.12-2.7.0/connector-json
./restart_connector_task.sh CONNECTOR_NAME
```

检查日志
```
[2023-06-16 11:06:35,655] INFO 88685 records sent during previous 00:02:39.982, last recorded offset of {server=oracle_tsm} partition is {transaction_id=null, lcr_position=0046b61b977100000001000000010046b61b9770000000010000000101, snapshot_scn=299510708387} (io.debezium.connector.common.BaseSourceTask:211)
```
出现这样的日志，则意味着Connector继续处理了，如果仍然长时间没继续处理，则请联系DBA需进一步检查Xstream各组件状态


# Task already exists in this worker

## 症状表现

```
[2023-11-07 14:11:41,807] ERROR [Worker clientId=connect-1, groupId=connect-cluster-namenode] Couldn't instantiate task oracle_tftfxq1-0 because it has an invalid task configuration. This task will not execute until reconfigured. (org.apache.kafka.connect.runtime.distributed.DistributedHerder:1275)
org.apache.kafka.connect.errors.ConnectException: Task already exists in this worker: oracle_tftfxq1-0
        at org.apache.kafka.connect.runtime.Worker.startTask(Worker.java:512)
        at org.apache.kafka.connect.runtime.distributed.DistributedHerder.startTask(DistributedHerder.java:1258)
        at org.apache.kafka.connect.runtime.distributed.DistributedHerder.access$1700(DistributedHerder.java:127)
        at org.apache.kafka.connect.runtime.distributed.DistributedHerder$10.call(DistributedHerder.java:1273)
        at org.apache.kafka.connect.runtime.distributed.DistributedHerder$10.call(DistributedHerder.java:1269)
        at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
        at java.base/java.lang.Thread.run(Thread.java:834)
[2023-11-07 14:11:41,822] INFO [Worker clientId=connect-1, groupId=connect-cluster-namenode] Starting connector oracle_tftfxq1 (org.apache.kafka.connect.runtime.distributed.DistributedHerder:1298)
```

一般来说，是因为Connect集群中，检测到已有相同Task在运行，便抛出这个错误。具体，可以查看，connect-status topic.

```
key: status-task-oracle_tftfxq1

{
"state": "RUNNING",
"trace": null,
"worker_id": "10.50.253.202:8084",
"generation": 156
}

{
"state": "RUNNING",
"trace": null,
"worker_id": "10.50.253.201:8084",
"generation": 157
}
```

这时，相同task名称，两个均为running状态，同时attach至xstream上，Oracle数据库端会拒绝后来连接xstream的用户，所以数据是不会被重复消费。

## 解决

删除后重建对应Connector

```shell
curl -X DELETE http://10.50.253.201:8084/connectors/oracle_tftfxq1

curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
       "name": "oracle_tftfxq1",
       "config": {
           "connector.class": "io.debezium.connector.oracle.OracleConnector",
           ......
           "transforms.Reroute7.key.enforce.uniqueness":"false",
           "signal.data.collection":"TFTFXQ.LOGMINER.DEBEZIUM_SIGNAL",
           "signal.poll.interval.ms":"5000"
       }
    }' \
http://10.50.253.201:8084/connectors
```
