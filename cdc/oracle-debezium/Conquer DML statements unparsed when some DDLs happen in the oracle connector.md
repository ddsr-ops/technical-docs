```
[2022-11-04 14:51:48,063] ERROR Mining session stopped due to the {} (io.debezium.connector.oracle.logminer.LogMinerHelper:115)
io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed. Please open a Jira issue with the statement 'update "TFT_UPS"."DC_DISCOUNT_CARD" set "DURATION_TYPE" = '10', "ACTIVATION_EXPIRE_TIME_TYPE" = '20' where "ID" = '80' and "BATCH_NO" = '202003192245440302' and "CARD_NAME" = '活动公交8折测试' and "CARD_TRADE" = '02' and "DISCOUNT" = '8' and "CARD_DURATION" = '7' and "DAY_LIMIT_TIMES" = '4' and "PER_DEDUCT_LIMIT" = '100' and "OPERATOR_ID" = '2295814838289408' and "BUY_PRINCIPAL" = '03' and "BUY_PRINCIPAL_NAME" = '天府通内部' and "PUSH_MSG" = '活动公交8折测试推送测试' and "CREATE_TIME" = TO_DATE('2020-03-19 22:45:44', 'YYYY-MM-DD HH24:MI:SS') and "UPDATE_TIME" = TO_DATE('2020-03-19 22:45:44', 'YYYY-MM-DD HH24:MI:SS') and "TOTAL_LIMIT_TIMES" IS NULL and "ACTIVATION_EXPIRE_TIME" IS NULL and "EFFECTIVE_MSG" IS NULL and "INVALID_MSG" = '您的折扣卡即将到期，请尽快使用' and "CARD_TYPE" = '01' and "PURCHASE_TIMES" = '0' and "PAYMENT_LIMIT" = '0' and "DURATION_TYPE" IS NULL and "DURATION_START_TIME" IS NULL and "DURATION_END_TIME" IS NULL and "ACTIVATION_EXPIRE_TIME_TYPE" IS NULL and "ACTIVATION_DURATION" IS NULL;'.
        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.parseDmlStatement(AbstractLogMinerEventProcessor.java:893)
        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.lambda$handleDataEvent$5(AbstractLogMinerEventProcessor.java:704)
        at io.debezium.connector.oracle.logminer.processor.memory.MemoryLogMinerEventProcessor.addToTransaction(MemoryLogMinerEventProcessor.java:211)        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.handleDataEvent(AbstractLogMinerEventProcessor.java:703)
        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.processRow(AbstractLogMinerEventProcessor.java:286)        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.processResults(AbstractLogMinerEventProcessor.java:242)
        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.process(AbstractLogMinerEventProcessor.java:187)        at io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource.execute(LogMinerStreamingChangeEventSource.java:239)
        at io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource.execute(LogMinerStreamingChangeEventSource.java:55)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.streamEvents(ChangeEventSourceCoordinator.java:172)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.executeChangeEventSources(ChangeEventSourceCoordinator.java:139)
        at io.debezium.pipeline.ChangeEventSourceCoordinator.lambda$start$0(ChangeEventSourceCoordinator.java:108)        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)Caused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: Failed to parse update DML: 'update "TFT_UPS"."DC_DISCOUNT_CARD" set "DURATION_TYPE" = '10', "ACTIVATION_EXPIRE_TIME_TYPE" = '20' where "ID" = '80' and "BATCH_NO" = '202003192245440302' and "CARD_NAME" = '活动公交8折测试' and "CARD_TRADE" = '02' and "DISCOUNT" = '8' and "CARD_DURATION" = '7' and "DAY_LIMIT_TIMES" = '4' and "PER_DEDUCT_LIMIT" = '100' and "OPERATOR_ID" = '2295814838289408' and "BUY_PRINCIPAL" = '03' and "BUY_PRINCIPAL_NAME" = '天府通内部' and "PUSH_MSG" = '活动公交8折测试推送测试' and "CREATE_TIME" = TO_DATE('2020-03-19 22:45:44', 'YYYY-MM-DD HH24:MI:SS') and "UPDATE_TIME" = TO_DATE('2020-03-19 22:45:44', 'YYYY-MM-DD HH24:MI:SS') and "TOTAL_LIMIT_TIMES" IS NULL and "ACTIVATION_EXPIRE_TIME" IS NULL and "EFFECTIVE_MSG" IS NULL and "INVALID_MSG" = '您的折扣卡即将到期，请尽快使用' and "CARD_TYPE" = '01' and "PURCHASE_TIMES" = '0' and "PAYMENT_LIMIT" = '0' and "DURATION_TYPE" IS NULL and "DURATION_START_TIME" IS NULL and "DURATION_END_TIME" IS NULL and "ACTIVATION_EXPIRE_TIME_TYPE" IS NULL and "ACTIVATION_DURATION" IS NULL;'
        at io.debezium.connector.oracle.logminer.parser.LogMinerDmlParser.parseUpdate(LogMinerDmlParser.java:159)
        at io.debezium.connector.oracle.logminer.parser.LogMinerDmlParser.parse(LogMinerDmlParser.java:79)
        at io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor.parseDmlStatement(AbstractLogMinerEventProcessor.java:887)
        ... 16 more
Caused by: io.debezium.DebeziumException: No column 'DURATION_TYPE' found in table 'TFTUPS.TFT_UPS.DC_DISCOUNT_CARD'
        at io.debezium.connector.oracle.logminer.LogMinerHelper.getColumnIndexByName(LogMinerHelper.java:229) 
        at io.debezium.connector.oracle.logminer.parser.LogMinerDmlParser.parseSetClause(LogMinerDmlParser.java:400)
        at io.debezium.connector.oracle.logminer.parser.LogMinerDmlParser.parseUpdate(LogMinerDmlParser.java:134)
        ... 18 more
[2022-11-04 14:51:48,064] ERROR Producer failure (io.debezium.pipeline.ErrorHandler:31)

```

Commonly, the case occurs because some DDL events(add columns) were not captured by logminer. DML events related to the tables
which were altered by DDL after the DDL events take place can not be recognized by logminer. So the exception was thrown.

1. If DDL statements are issued by sys/system user, they are not captured by logminer.
2. If log mining mode is online_catalog, DDL statements are not recorded by logminer.

We mock DDL events and emit them to history topic , then restart relevant tasks to conquer it.

# Mock DDL events match the debezium format

```
{
  "source" : {
    "server" : "oracle_ups"
  },
  "position" : {
    "snapshot_scn" : "276102911761",
    "snapshot" : true,
    "scn" : "276102911761",
    "snapshot_completed" : false
  },
  "databaseName" : "TFTUPS",
  "schemaName" : "TFT_UPS",
  "ddl" : "ALTER TABLE DC_DISCOUNT_CARD ADD DURATION_TYPE CHAR(2)",
  "tableChanges" : [ {
    "type" : "ALTER",
    "id" : "\"TFTUPS\".\"TFT_UPS\".\"DC_DISCOUNT_CARD\"",
    "table" : {
      "defaultCharsetName" : null,
      "primaryKeyColumnNames" : [ "ID" ],
      "columns" : [ {
        "name" : "ID",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 0,
        "position" : 1,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "BATCH_NO",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 18,
        "position" : 2,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "CARD_NAME",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 64,
        "position" : 3,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "CARD_TRADE",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 2,
        "position" : 4,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "DISCOUNT",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 3,
        "scale" : 2,
        "position" : 5,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "CARD_DURATION",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 0,
        "position" : 6,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "DAY_LIMIT_TIMES",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 8,
        "scale" : 0,
        "position" : 7,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "PER_DEDUCT_LIMIT",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 10,
        "scale" : 0,
        "position" : 8,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "OPERATOR_ID",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 19,
        "position" : 9,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "BUY_PRINCIPAL",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 2,
        "position" : 10,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "BUY_PRINCIPAL_NAME",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 32,
        "position" : 11,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "PUSH_MSG",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 200,
        "position" : 12,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "CREATE_TIME",
        "jdbcType" : 93,
        "typeName" : "DATE",
        "typeExpression" : "DATE",
        "charsetName" : null,
        "position" : 13,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "UPDATE_TIME",
        "jdbcType" : 93,
        "typeName" : "DATE",
        "typeExpression" : "DATE",
        "charsetName" : null,
        "position" : 14,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : false,
        "enumValues" : [ ]
      }, {
        "name" : "TOTAL_LIMIT_TIMES",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 8,
        "scale" : 0,
        "position" : 15,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "ACTIVATION_EXPIRE_TIME",
        "jdbcType" : 93,
        "typeName" : "DATE",
        "typeExpression" : "DATE",
        "charsetName" : null,
        "position" : 16,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "EFFECTIVE_MSG",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 200,
        "position" : 17,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "INVALID_MSG",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 200,
        "position" : 18,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "CARD_TYPE",
        "jdbcType" : 12,
        "typeName" : "VARCHAR2",
        "typeExpression" : "VARCHAR2",
        "charsetName" : null,
        "length" : 200,
        "position" : 19,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "PURCHASE_TIMES",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 0,
        "position" : 20,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "defaultValueExpression" : "0 ",
        "enumValues" : [ ]
      }, {
        "name" : "PAYMENT_LIMIT",
        "jdbcType" : 1,
        "typeName" : "CHAR",
        "typeExpression" : "CHAR",
        "charsetName" : null,
        "length" : 1,
        "position" : 21,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "defaultValueExpression" : "'0' ",
        "enumValues" : [ ]
      }, {
        "name" : "DURATION_TYPE",
        "jdbcType" : 1,
        "typeName" : "CHAR",
        "typeExpression" : "CHAR",
        "charsetName" : null,
        "length" : 2,
        "position" : 22,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "DURATION_START_TIME",
        "jdbcType" : 93,
        "typeName" : "DATE",
        "typeExpression" : "DATE",
        "charsetName" : null,
        "position" : 23,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "DURATION_END_TIME",
        "jdbcType" : 93,
        "typeName" : "DATE",
        "typeExpression" : "DATE",
        "charsetName" : null,
        "position" : 24,
        "optional" : true,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      }, {
        "name" : "ACTIVATION_EXPIRE_TIME_TYPE",
        "jdbcType" : 1,
        "typeName" : "CHAR",
        "typeExpression" : "CHAR",
        "charsetName" : null,
        "length" : 2,
        "position" : 25,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      },{
        "name" : "ACTIVATION_DURATION",
        "jdbcType" : 2,
        "typeName" : "NUMBER",
        "typeExpression" : "NUMBER",
        "charsetName" : null,
        "length" : 8,
        "scale" : 0,
        "position" : 26,
        "optional" : false,
        "autoIncremented" : false,
        "generated" : false,
        "comment" : null,
        "hasDefaultValue" : true,
        "enumValues" : [ ]
      } ]
    },
    "comment" : null
  } ]
}
```

You can copy an old message from history topic , here the topic name is oracle_ups_his. 
Some demonstrations:
* `position` section, Scn and committed_scn would be checked by logminer, so need to modify it according to error dml scn and configured offset scn.
  In details, the order of them should be correct. If not, DDL events may not be applied by logminer.
* `columns` section, it includes all columns. Modify , delete or add some columns to the end, take care of all fields.

Query history topic data , you can use KSQL of kafka-eagle(path : messages - topic - ksql).
For example, `select * from oracle_tsm_his where `partition` in (0) and `msg` like '%T_ACT_TRADE_DETAIL%'`

## Another way to obtain the newest DDL message

Launch another dummy connector only including tables which schema infos are incorrect.
Copy the table DDL messages from history topic, modify the scn and committed_scn fields, then emit them to the history topic
of crashed connectors.

# Emit DDL events to history topic

Here, we send messages to history topic(oracle_ups_his) via kafka-eagle. 

Enter the web ui , http://namenode2:8049/topic/mock, path : MESSAGES -- TOPICS -- MOCK

# Modify the SCN of offset topic

If skip unparsed DML messages, correct offset message should be emitted to the connect-offset topic.
How to config it , refer to <how to configure correct scns to skip unparsed dml evens>.

# Restart connector task

curl -Ss -X POST http://namenode2:8084/connectors/connector_name/tasks/0/restart

Note: connector_name should be replaced with correct name. 

**Add columns is different from modify columns, refer to <how to handle it when ddl which modify columns occurs without updating logminer mode(未更改CDC模式但发起DDL造成CDC链路异常)>
for details in case adding columns cause exception.** 

# how to configure correct SCNs to skip unparsed dml evens

Scn: 
* Scn at which unparsed dml events locate is SCN A  
* Scn when DDL events actually take place is SCN B, you should emit it to history topic configured in the connector-json
* Scn which you want to skip to is SCN C, you would emit it to offset topic

Rule: SCN C > SCN A > SCN B

Commonly, SCN C is specified as current SCN , `select current_scn from v$database`.
SCN B is some scn which value is less than SCN C.

The lost data should be provided by another technology, such as jdbc?