# Ŀ��

���ļ�¼���õ�Debeziumά���ʼǡ�

# �����޷������DML

## ֢״����
```
...
Caused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed
...
```

## ���
һ�㷢����Դ�ⲻ��ȷ��ִ����Connector��������ر��DDL��䣬����Logminer�������ֵ��޷�ʶ����־�е��ֶΡ�

ͨ����˵���������������Connector�޷����������ؽ����޸�Connector History topic�������ⲿ����־��

1. ��Git�ֿ���ȡ���µ�Debezium Connector����
2. ִ��connector��ɾ����`curl -X DELETE http://10.50.253.6:8085/connectors/oracle_tftfxq`
3. ���ö�Ӧconnector��offsetλ�ã�`select current_scn from v$database; `276598572096��
   �޸Ľű�/opt/kafka_2.12-2.7.0_1/connector-json/debezium-util.sh�е�connector������`scn`��276598572096��
   ִ�нű�`bash debezium-util.sh`, ������Ͷ����connector-offset topic��
4. ��History topic��ȡ���µ�Schema DDL message��Ϣ
   Query history topic data , you can use KSQL of kafka-eagle(path : messages - topic - ksql).
   For example, `select * from oracle_tsm_his where `partition` in (0) and `msg` like '%T_ACT_TRADE_DETAIL%'`
5. ��������ȡ����������SCN��COMMITTED_SCN���޸�Ϊ��С��276598572096�󣬽�����Ͷ����history topic
   Here, we send messages to history topic(such as oracle_ups_his) via kafka-eagle. 
   Enter the web ui , http://namenode2:8049/topic/mock, path : MESSAGES -- TOPICS -- MOCK
6. �½�������connector, `curl -Ss -X POST http://namenode2:8084/connectors/connector_name/tasks/0/restart`
7. ��֤connector�����ɹ����鿴��־`tailf /opt/kafka_2.12-2.7.0_1/logs/connect.log`
   ```For connector oracle_tftfxq, Oracle Session UGA 2.97MB (max = 3.15MB), PGA 155.32MB (max = 235.45MB)```
   ע�⣺N1��N2����־·��Ϊ/opt/kafka_2.12-2.7.0_1/logs/connect.log, D1-D5����־·��Ϊ/opt/kafka_2.12-2.7.0/logs/connect.log
   
TODO: �������޸���Ӱ����ҵ

Note�������ȷʵʩDDL����ο��ĵ���oracle cdc table structure evolution.sql��



# NPE occurs when getColumnValues

## ֢״����
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

## ���
���schema�仯��ʷtopic��������oracle_tsm.schema-changes.inventory

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

���ʹ����CREATE TABLE AS SELECT ...����䣬 Debeziumû�л�ȡ��schema������ֶ���Ϣ��Xstream��LogMiner
�������DDL��û�ṩ�ֶ���Ϣ��

�ֶ�����oracle_tsm.schema-changes.inventory�����Ԫ��Ϣ��������topic�У�����connector task�ɽ��������⣬
��Ϊlcr_position׼ȷ�����Թ����schema-change�������CDC������©��
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

��ʹ��kafka-eagle���ߵ�topics-mock����������Ϣ������oracle_tsm.schema-changes.inventory

�ο���  
https://issues.redhat.com/browse/DBZ-6373  
https://issues.redhat.com/browse/DBZ-6370



# ORA-26804: Apply "XXX" is disabled

## ֢״����

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

## ���

����Apply server�����õ��������������Ϊ���ݿ����ά��Xstream��ؽ��̣�����ʹ��ALTER_OUTBOUND����
�޸�CAPTURE���̵Ķ�ȡƫ�������������ؽ����Զ�������

����Connector task���ɣ�curl -X POST http://KAFKA_NODE:8084/connectors/CONNECTOR_NAME/tasks/0/restart