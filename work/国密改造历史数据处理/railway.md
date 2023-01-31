Because the number of rows in the railway database is not much big, no need to make the incremental snapshot.

curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "mysql_railway_sm4",
   "config": {
       "connector.class" : "io.debezium.connector.mysql.MySqlConnector",
       "tasks.max" : "1",
       "database.hostname": "10.60.10.2",
       "database.port" : "60001",
       "database.user" : "repl_user",
       "database.server.name" : "mysql_railway_sm4",
       "database.password" : "tft#!ZASq32",
       "table.include.list": "railway.t_apply_for_record,railway.t_railway_card",
       "database.server.id": "1898",
       "message.key.columns":"railway.t_apply_for_record:id;railway.t_railway_card:id",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "include.schema.changes": "false",
       "snapshot.mode" : "initial",
       "decimal.handling.mode":"string",
       "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
       "database.history.kafka.topic" : "mysql_railway_sm4_his",
       "tombstones.on.delete" : "false",
       "database.history.store.only.captured.tables.ddl": "true"
   }
}' \
http://10.50.253.1:8083/connectors



create temporary function sm4_encrypt as 'com.tft.flink.udf.SM4EncryptUDF';
-- decrypt firstly, then encrypt
create temporary function railway_sm4_decrypt as 'com.tft.flink.udf.RailwaySm4DecryptUDF'; 
-- select sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', railway_sm4_decrypt('Q1ITZ6rrPAurFyXpbGLzj6irYSATzyalQWr82cYvVcw='));


set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

-- case intensive
CREATE TABLE t_apply_for_record(
    ID STRING,
    USER_ID STRING,
    REAL_NAME STRING,
    UPDATE_TIME BIGINT,
    PHONE_NO STRING,
    CREATE_TIME BIGINT
) WITH (
'connector' = 'kafka',
'topic' = 'mysql_railway_sm4.railway.t_apply_for_record',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'mysql_railway_sm4.t_apply_for_record',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE t_apply_for_record1(
    ID STRING,
    USER_ID STRING,
    REAL_NAME STRING,
    UPDATE_TIME TIMESTAMP,
    PHONE_NO STRING,
    CREATE_TIME TIMESTAMP,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.10.2:60001/railway',
'table-name' = 't_apply_for_record_new',
'username' = 'tft_sytl',
'password' = 'VFR!5E#dr12s'
);

INSERT INTO t_apply_for_record1
SELECT
ID,
USER_ID,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', REAL_NAME) as REAL_NAME,
TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', railway_sm4_decrypt(PHONE_NO)) as PHONE_NO,
TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME
FROM t_apply_for_record;

select * from t_apply_for_record where user_id in ('8743823647778816') union all select * from t_apply_for_record_new where user_id in ('8743823647778816');

select count(9) from t_apply_for_record union all select count(9) from t_apply_for_record_new ;

CREATE TABLE t_railway_card
    (ID STRING,
    USER_ID STRING,
    NAME STRING,
    PHONE_NO STRING,
    BIND_TIME BIGINT,
    BIND_TYPE STRING,
    CARD_TYPE STRING,
    CARD_NO STRING,
    CARD_SURFACE_NO STRING,
    CARD_NAME STRING,
    ID_CARD STRING,
    CARD_ICON STRING,
    BIND_STATUS STRING,
    UNBIND_TIME BIGINT,
    UNBIND_TYPE STRING,
    UNBIND_VIEW_STATUS STRING,
    CREATE_TIME BIGINT,
    UPDATE_TIME BIGINT) WITH (
'connector' = 'kafka',
'topic' = 'mysql_railway_sm4.railway.t_railway_card',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'mysql_railway_sm4.t_railway_card',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE t_railway_card1(
    ID STRING,
    USER_ID STRING,
    NAME STRING,
    PHONE_NO STRING,
    BIND_TIME TIMESTAMP,
    BIND_TYPE STRING,
    CARD_TYPE STRING,
    CARD_NO STRING,
    CARD_SURFACE_NO STRING,
    CARD_NAME STRING,
    ID_CARD STRING,
    CARD_ICON STRING,
    BIND_STATUS STRING,
    UNBIND_TIME TIMESTAMP,
    UNBIND_TYPE STRING,
    UNBIND_VIEW_STATUS STRING,
    CREATE_TIME TIMESTAMP,
    UPDATE_TIME TIMESTAMP,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.10.2:60001/railway',
'table-name' = 't_railway_card_new',
'username' = 'tft_sytl',
'password' = 'VFR!5E#dr12s'
);

insert into t_railway_card1
select
    ID ,
    USER_ID ,
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', NAME) as NAME ,
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', railway_sm4_decrypt(PHONE_NO)) as PHONE_NO ,
    TO_TIMESTAMP(FROM_UNIXTIME(BIND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as BIND_TIME,
    BIND_TYPE ,
    CARD_TYPE ,
    CARD_NO ,
    CARD_SURFACE_NO ,
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', CARD_NAME) as CARD_NAME ,
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', railway_sm4_decrypt(ID_CARD)) as ID_CARD ,
    CARD_ICON ,
    BIND_STATUS ,
    TO_TIMESTAMP(FROM_UNIXTIME(UNBIND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UNBIND_TIME,
    UNBIND_TYPE ,
    UNBIND_VIEW_STATUS ,
    TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
    TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME
  from t_railway_card;

select * from t_railway_card where user_id in ('7752119543985152') union select * from t_railway_card_new where user_id in ('7752119543985152')  ;

select count(9) from t_railway_card union all select count(9) from t_railway_card_new ;  