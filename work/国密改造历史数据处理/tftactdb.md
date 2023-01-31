curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "mysql_tftactdb_sm4",
   "config": {
       "connector.class" : "io.debezium.connector.mysql.MySqlConnector",
       "tasks.max" : "1",
       "database.hostname": "10.60.4.1",
       "database.port" : "60001",
       "database.user" : "dw_repl",
       "database.server.name" : "mysql_tftactdb_sm4",
       "database.password" : "VGY^!fgU34dr",
       "table.include.list": "tftactdb.tbl_fcl_user_code,debezium.debezium_signal",
       "database.server.id": "1897",
       "message.key.columns":"tftactdb.tbl_fcl_user_code:id",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "include.schema.changes": "false",
       "snapshot.mode" : "schema_only",
       "decimal.handling.mode":"string",
       "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
       "database.history.kafka.topic" : "mysql_tftactdb_sm4_his",
       "tombstones.on.delete" : "false",
       "database.history.store.only.captured.tables.ddl": "true",
       "signal.data.collection":"debezium.debezium_signal"
   }
}' \
http://10.50.253.1:8083/connectors



insert into debezium.debezium_signal values('ad-hoc-1', 'execute-snapshot', '{"data-collections": ["tftactdb.tbl_fcl_user_code"],"type":"incremental"}');


create temporary function sm4_encrypt as 'com.tft.flink.udf.SM4EncryptUDF';

set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

CREATE TABLE tbl_fcl_user_code(
id bigint,
user_id string,
user_pinNum string,
saltValue string,
pinStatus string,
failCount string,
first_fail_tm string,
rec_crt_ts string,
rec_upd_ts string
) WITH (
'connector' = 'kafka',
'topic' = 'mysql_tftactdb_sm4.tftactdb.tbl_fcl_user_code',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'mysql_tftactdb_sm4.tbl_fcl_user_code',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE tbl_fcl_user_code1(
id bigint,
user_id string,
user_pinNum string,
saltValue string,
pinStatus string,
failCount string,
first_fail_tm string,
rec_crt_ts string,
rec_upd_ts string,
sm4Pinnum string,
PRIMARY KEY (user_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.4.2:60001/tftactdb',
'table-name' = 'tbl_fcl_user_code_new',
'username' = 'act_ap',
'password' = 'sP25*68@Ct'
);

INSERT INTO tbl_fcl_user_code1
SELECT
id,
user_id,
user_pinNum,
saltValue,
pinStatus,
failCount,
first_fail_tm,
replace(replace(rec_crt_ts, 'T', ' '), '+08:00', '') as rec_crt_ts,
replace(replace(rec_upd_ts, 'T', ' '), '+08:00', '') as rec_upd_ts,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', user_pinNum) as sm4Pinnum
FROM tbl_fcl_user_code;


select id,
       user_id,
       user_pinNum,
       saltValue,
       pinStatus,
       failCount,
       first_fail_tm,
       rec_crt_ts,
       rec_upd_ts
  from tbl_fcl_user_code
 where user_id = '1000000000064856'
union all
select id,
       user_id,
       user_pinNum,
       saltValue,
       pinStatus,
       failCount,
       first_fail_tm,
       rec_crt_ts,
       rec_upd_ts
  from tbl_fcl_user_code_new
 where user_id = '1000000000064856';

