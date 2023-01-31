# Goal

When operating kafka-reassign-partitions action, how producers and consumers related to topics 
which are reassigned partitions are going on?

Here, the conclusions are:

Even if how many times the topics are reassigned over and over again, Producers and consumers related to topics are going
well without any errors and omitting data.

# Kafka Partitions Reassignment Reference

```text
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --topics-to-move-json-file topics-to-move.json --broker-list "1002,1003,1007" --generate

topic-reassignment.json: 
{"version":1,"partitions":[{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":0,"replicas":[1008],"log_dirs":["any"]},{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":1,"replicas":[1009],"log_dirs":["any"]},{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":2,"replicas":[1001],"log_dirs":["any"]}]}

topic-reassignment-rollback.json: 
{"version":1,"partitions":[{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":0,"replicas":[1003],"log_dirs":["any"]},{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":1,"replicas":[1007],"log_dirs":["any"]},{"topic":"dev_oracle_gch18x.DBA_TEST.TB_TEST","partition":2,"replicas":[1002],"log_dirs":["any"]}]}

./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment.json --execute
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment.json --verify

./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment-rollback.json --execute
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment-rollback.json --verify
```

# Steps

## Kafka producer introduction

An Oracle connector was employed as a kafka producer. For details, refer to this:

```
{
     "name": "devdboragch18x",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id;dba_test.tb_test14:id;dba_test.tb_test15:id;dba_test.tb_test_upd:id;dba_test.cp_coupon_test:coupon_id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch18x",
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
         "decimal.handling.mode":"string",
         "table.include.list":"dba_test.tb_test,dba_test.tb_test14,dba_test.tb_test15,dba_test.tb_test_upd,dba_test.cp_coupon_test",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = or
a11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch18x",
         "log.mining.continuous.mine": "true"
     }
  }
```

Another action is to mock DML events via PLSQL code. Some code snippets are as follows:

```
declare
   v_max_id number;
BEGIN
  select nvl(max(id), 0) + 1 into v_max_id from dba_test.tb_test;
  FOR I IN v_max_id .. 10000000 LOOP
    -- DBMS_LOCK.SLEEP(0.005);
    DBMS_OUTPUT.PUT_LINE(to_char(i));
    INSERT INTO dba_test.tb_test(id, name) VALUES(i, '天府通'||to_char(i));
    COMMIT;
    --DELETE FROM dba_test.tb_test WHERE ID = i;
    --COMMIT;
  END LOOP;
END;
/

```

Yeah, kafka producer has been prepared. If control the speed DML events are operated on the target table,
uncomment the statement `DBMS_LOCK.SLEEP(0.005)` and modify the value in the bracket if necessary.

## Kafka consumer introduction

For conveniences, engage a kafka console consumer to consume the messages produced by the Oracle connector above.

Tow consumers are launched using the following command.

```
nohup ./kafka-console-consumer.sh --bootstrap-server hadoop190:9093 --topic dev_oracle_gch18x.DBA_TEST.TB_TEST >> /tmp/kafka-console-consumer-out1.txt 2>&1 &
nohup ./kafka-console-consumer.sh --bootstrap-server hadoop190:9093 --topic dev_oracle_gch18x.DBA_TEST.TB_TEST >> /tmp/kafka-console-consumer-out.txt 2>&1 &
```

Output the result to the temp file to check the result.

Note the topic name is the same as topic to which Oracle connector writes events.

## Experiment Steps

1. Launch the two kafka consumers, and do not stop them;
2. Startup the Oracle Connector, then execute the PLSQL code snippets to generate DML events;
3. Kafka consumers and producers are ready, let`s reassign kafka partitions more than once.

Keep kafka producers and consumers running, simultaneously reassign the kafka topic partitions using the following code:
```
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment.json --execute
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment.json --verify
```
After reassignment operation has been done, rollback reassignment action is taken at once  using the following code: 
```
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment-rollback.json --execute
./kafka-reassign-partitions.sh --bootstrap-server hadoop191:9093 --reassignment-json-file topic-reassignment-rollback.json --verify
```

Repeat the two actions above many times. At last, check the result:

About the producer, the initial `count` value is 29492, the last `count` values is 826220, 
so the total count produced by Oracle connector is 796728.

About the consumers,
```
[root@hadoop190 bin]# grep 天府通 /tmp/kafka-console-consumer-out.txt|wc -l
796728
[root@hadoop190 bin]# grep 天府通 /tmp/kafka-console-consumer-out1.txt|wc -l
796728
```
