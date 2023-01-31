# Goal

Migrate from the current table to another table in the same database.

# What technologies to use

* Kafka
* Debezium cdc plugin
* Flink SQL

# Prerequisites

1. A kafka cluster has been deployed and started
2. Kafka connector cluster including oracle plugin has been deployed  and started
3. Flink cluster has been deployed and started

# Build the cdc streaming road

build a connector supporting the ad-hoc increment snapshot.

## Configure a connector

curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
       "name": "oracle_tsm_inc_snap",
       "config": {
           "connector.class" : "io.debezium.connector.oracle.OracleConnector",
           "tasks.max" : "1",
           "database.server.name" : "oracle_tsm_inc_snap",
           "database.user" : "logminer",
           "database.password" : "Logminer#$321",
           "database.dbname" : "tftong",
           "database.port" : "1521",
           "database.hostname" : "10.60.5.2",
           "rac.nodes" : "10.60.5.1,10.60.5.2",
           "log.mining.transaction.retention.hours" : "2",
    	   "decimal.handling.mode":"string",
           "table.include.list":"tft_tsm.t_trade_info,logminer.debezium_signal",
           "message.key.columns":"tft_tsm.t_trade_info:trade_no",
           "key.converter":"org.apache.kafka.connect.json.JsonConverter",
           "key.converter.schemas.enable":"false",
           "value.converter":"org.apache.kafka.connect.json.JsonConverter",
           "value.converter.schemas.enable":"false",
           "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
           "database.history.kafka.topic": "oracle_tsm_inc_snap_his",
           "snapshot.mode" : "schema_only",
           "tombstones.on.delete": "false",
           "database.history.skip.unparseable.ddl": "true",
           "log.mining.strategy": "online_catalog",
           "log.mining.continuous.mine": "true",
           "signal.data.collection":"TFTONG.LOGMINER.DEBEZIUM_SIGNAL",
           "incremental.snapshot.chunk.size":"50000"
       }
    }' \
http://10.50.253.6:8085/connectors

Note the properties: `signal.data.collection` and  `table.include.list`

Output as follows:
```
[2022-08-04 15:08:38,154] INFO Requested 'INCREMENTAL' snapshot of data collections '[TFTONG.TFT_TSM.T_TRADE_INFO]' (io.debezium.pipeline.signal.ExecuteSnapshot:53)
[2022-08-04 15:08:38,376] INFO Incremental snapshot for table 'TFTONG.TFT_TSM.T_TRADE_INFO' will end at position [20220804150838843816] (io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource:289)
```
The log demonstrates increment snapshot task was accepted.


set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';


CREATE TABLE t_trade_info (
  TRADE_NO           STRING,
  ORDER_NO           STRING,
  THIRD_TRADE_NO     STRING,
  THIRD_REFUND_NO    STRING,
  ACT_UP_TRADE_NO    STRING,
  ACT_DOWN_TRADE_NO  STRING,
  ACT_UP_REFUND_NO   STRING,
  ACT_DOWN_REFUND_NO STRING,
  OUT_TRADE_NO       STRING,
  OUT_REFUND_NO      STRING,
  USER_ID            STRING,
  PAY_TYPE           STRING,
  TRADE_STATE        STRING,
  TRADE_SCENE        STRING,
  TRADE_EXTEND       STRING,
  NOTIFY_URL         STRING,
  TRADE_AMOUNT       STRING,
  REFUND_AMOUNT      STRING,
  TRADE_TIME         BIGINT,
  REFUND_TIME        BIGINT,
  SETTLE_DATE        STRING,
  SETTLE_TRADE_TIME  BIGINT,
  SETTLE_REFUND_TIME BIGINT,
  TAGS               STRING,
  FAILED_CODE        STRING,
  FAILED_MESSAGE     STRING,
  STATUS             STRING,
  CREATE_TIME        BIGINT,
  UPDATE_TIME        BIGINT,
  VERSION            STRING)
WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_inc_snap.TFT_TSM.T_TRADE_INFO',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 't_trade_info',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);


CREATE TABLE t_trade_info_new (
  TRADE_NO           STRING,
  ORDER_NO           STRING,
  THIRD_TRADE_NO     STRING,
  THIRD_REFUND_NO    STRING,
  ACT_UP_TRADE_NO    STRING,
  ACT_DOWN_TRADE_NO  STRING,
  ACT_UP_REFUND_NO   STRING,
  ACT_DOWN_REFUND_NO STRING,
  OUT_TRADE_NO       STRING,
  OUT_REFUND_NO      STRING,
  USER_ID            STRING,
  PAY_TYPE           STRING,
  TRADE_STATE        STRING,
  TRADE_SCENE        STRING,
  TRADE_EXTEND       STRING,
  NOTIFY_URL         STRING,
  TRADE_AMOUNT       STRING,
  REFUND_AMOUNT      STRING,
  TRADE_TIME         TIMESTAMP,
  REFUND_TIME        TIMESTAMP,
  SETTLE_DATE        STRING,
  SETTLE_TRADE_TIME  TIMESTAMP,
  SETTLE_REFUND_TIME TIMESTAMP,
  TAGS               STRING,
  FAILED_CODE        STRING,
  FAILED_MESSAGE     STRING,
  STATUS             STRING,
  CREATE_TIME        TIMESTAMP,
  UPDATE_TIME        TIMESTAMP,
  VERSION            STRING,
PRIMARY KEY (TRADE_NO) NOT ENFORCED)
 WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_trade_info_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO t_trade_info_new
SELECT 
TRADE_NO, 
ORDER_NO, 
THIRD_TRADE_NO, 
THIRD_REFUND_NO, 
ACT_UP_TRADE_NO, 
ACT_DOWN_TRADE_NO, 
ACT_UP_REFUND_NO, 
ACT_DOWN_REFUND_NO, 
OUT_TRADE_NO, 
OUT_REFUND_NO, 
USER_ID, 
PAY_TYPE, 
TRADE_STATE, 
TRADE_SCENE, 
TRADE_EXTEND, 
NOTIFY_URL, 
TRADE_AMOUNT, 
REFUND_AMOUNT, 
TO_TIMESTAMP(FROM_UNIXTIME(TRADE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as TRADE_TIME, 
TO_TIMESTAMP(FROM_UNIXTIME(REFUND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as REFUND_TIME, 
SETTLE_DATE, 
TO_TIMESTAMP(FROM_UNIXTIME(SETTLE_TRADE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as SETTLE_TRADE_TIME, 
TO_TIMESTAMP(FROM_UNIXTIME(SETTLE_REFUND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as SETTLE_REFUND_TIME, 
TAGS, 
FAILED_CODE, 
FAILED_MESSAGE, 
STATUS, 
TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME, 
TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME, 
VERSION
FROM 
t_trade_info;


-- 校验SQL
with new as
 (select *
    from t_trade_info_NEW t
   WHERE t.update_time >= to_date('&1', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('&2', 'yyyy-mm-dd hh24:mi:ss')),
old as
 (select *
    from t_trade_info t
   WHERE t.update_time >= to_date('&1', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('&2', 'yyyy-mm-dd hh24:mi:ss'))
select 
       (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where nvl(old.act_down_refund_no, 0) =nvl(new.act_down_refund_no, 0)
           and nvl(old.act_down_trade_no, 0) = nvl(new.act_down_trade_no, 0)
           and nvl(old.act_up_refund_no, 0) = nvl(new.act_up_refund_no, 0)
           and nvl(old.act_up_trade_no, 0) = nvl(new.act_up_trade_no, 0)
           and nvl(old.create_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.create_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and nvl(old.failed_code, 0) = nvl(new.failed_code, 0)
           and nvl(old.failed_message, 0) = nvl(new.failed_message, 0)
           and nvl(old.notify_url, 0) = nvl(new.notify_url, 0)
           and old.order_no = new.order_no
           and nvl(old.out_refund_no, 0) = nvl(new.out_refund_no, 0)
           and nvl(old.out_trade_no, 0) = nvl(new.out_trade_no, 0)
           and old.pay_type = new.pay_type
           and nvl(old.refund_amount, 0) = nvl(new.refund_amount, 0)
           and nvl(old.refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.refund_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and nvl(old.settle_date, 0) = nvl(new.settle_date, 0)
           and nvl(old.settle_refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.settle_refund_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and nvl(old.settle_trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.settle_trade_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and nvl(old.status, 0) = nvl(new.status, 0)
           and nvl(old.tags, 0) = nvl(new.tags, 0)
           and nvl(old.third_refund_no, 0) = nvl(new.third_refund_no, 0)
           and nvl(old.third_trade_no, 0) = nvl(new.third_trade_no, 0)
           and nvl(old.trade_amount, 0) = nvl(new.trade_amount, 0)
           and nvl(old.trade_extend, 0) = nvl(new.trade_extend, 0)
           and old.trade_no = new.trade_no
           and nvl(old.trade_scene, 0) = nvl(new.trade_scene, 0)
           and nvl(old.trade_state, 0) = nvl(new.trade_state, 0)
           and nvl(old.trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.trade_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and nvl(old.update_time, to_date('2022-02-02', 'yyyy-mm-dd')) = nvl(new.update_time, to_date('2022-02-02', 'yyyy-mm-dd'))
           and old.user_id = new.user_id
           and nvl(old.version, 0) = nvl(new.version, 0)) identity_count,
       (select count(*)
          from new, old
         where old.trade_no = new.trade_no
           and (nvl(old.act_down_refund_no, 0) != nvl(new.act_down_refund_no, 0) or
               nvl(old.act_down_trade_no, 0) != nvl(new.act_down_trade_no, 0) or
               nvl(old.act_up_refund_no, 0) != nvl(new.act_up_refund_no, 0) or
               nvl(old.act_up_trade_no, 0) != nvl(new.act_up_trade_no, 0) or
               nvl(old.create_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.create_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               nvl(old.failed_code, 0) != nvl(new.failed_code, 0) or
               nvl(old.failed_message, 0) != nvl(new.failed_message, 0) or
               nvl(old.notify_url, 0) != nvl(new.notify_url, 0) or
               old.order_no != new.order_no or
               nvl(old.out_refund_no, 0) != nvl(new.out_refund_no, 0) or
               nvl(old.out_trade_no, 0) != nvl(new.out_trade_no, 0) or
               old.pay_type != new.pay_type or
               nvl(old.refund_amount, 0) != nvl(new.refund_amount, 0) or
               nvl(old.refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               nvl(old.settle_date, 0) != nvl(new.settle_date, 0) or
               nvl(old.settle_refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.settle_refund_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               nvl(old.settle_trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.settle_trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               nvl(old.status, 0) != nvl(new.status, 0) or
               nvl(old.tags, 0) != nvl(new.tags, 0) or
               nvl(old.third_refund_no, 0) != nvl(new.third_refund_no, 0) or
               nvl(old.third_trade_no, 0) != nvl(new.third_trade_no, 0) or
               nvl(old.trade_amount, 0) != nvl(new.trade_amount, 0) or
               nvl(old.trade_extend, 0) != nvl(new.trade_extend, 0) or
               nvl(old.trade_scene, 0) != nvl(new.trade_scene, 0) or
               nvl(old.trade_state, 0) != nvl(new.trade_state, 0) or
               nvl(old.trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.trade_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               nvl(old.update_time, to_date('2022-02-02', 'yyyy-mm-dd')) != nvl(new.update_time, to_date('2022-02-02', 'yyyy-mm-dd')) or
               old.user_id != new.user_id or
               nvl(old.version, 0) != nvl(new.version, 0))) difference_count
  from dual;

-- 补偿SQL
MERGE INTO t_trade_info D -- 切表后的新表
USING (SELECT /*+ leading(old new) use_hash(old new)  */
        old.trade_no,
        old.order_no,
        old.third_trade_no,
        old.third_refund_no,
        old.act_up_trade_no,
        old.act_down_trade_no,
        old.act_up_refund_no,
        old.act_down_refund_no,
        old.out_trade_no,
        old.out_refund_no,
        old.user_id,
        old.pay_type,
        old.trade_state,
        old.trade_scene,
        old.trade_extend,
        old.notify_url,
        old.trade_amount,
        old.refund_amount,
        old.trade_time,
        old.refund_time,
        old.settle_date,
        old.settle_trade_time,
        old.settle_refund_time,
        old.tags,
        old.failed_code,
        old.failed_message,
        old.status,
        old.create_time,
        old.update_time,
        old.version
         FROM (select *
                 from t_trade_info_old -- 重命名后的旧表（注意和rename后的表名一致）
                where update_time >=
                      to_date('20220813 00:00:00', 'yyyymmdd hh24:mi:ss')
                  and update_time <
                      to_date('20220813 00:30:00', 'yyyymmdd hh24:mi:ss')) old,
              (select *
                 from t_trade_info -- 切表后的新表
                where update_time >= to_date('20220813 00:00:00', 'yyyymmdd')
                  and update_time < to_date('20220813 00:30:00', 'yyyymmdd')) new
        where old.trade_no = new.trade_no(+)
          and (new.trade_no is null or
              (old.update_time > new.update_time and
              ((nvl(old.version, 0) != nvl(new.version, 0) or
              nvl(old.update_time, sysdate) !=
              nvl(new.update_time, sysdate) or
              nvl(old.create_time, sysdate) !=
              nvl(new.create_time, sysdate) or
              nvl(old.status, 0) != nvl(new.status, 0) or
              nvl(old.failed_message, 0) != nvl(new.failed_message, 0) or
              nvl(old.failed_code, 0) != nvl(new.failed_code, 0) or
              nvl(old.tags, 0) != nvl(new.tags, 0) or
              nvl(old.settle_refund_time, sysdate) !=
              nvl(new.settle_refund_time, sysdate) or
              nvl(old.settle_trade_time, sysdate) !=
              nvl(new.settle_trade_time, sysdate) or
              nvl(old.settle_date, 0) != nvl(new.settle_date, 0) or
              nvl(old.refund_time, sysdate) !=
              nvl(new.refund_time, sysdate) or
              nvl(old.trade_time, sysdate) !=
              nvl(new.trade_time, sysdate) or
              nvl(old.refund_amount, 0) != nvl(new.refund_amount, 0) or
              nvl(old.trade_amount, 0) != nvl(new.trade_amount, 0) or
              nvl(old.notify_url, 0) != nvl(new.notify_url, 0) or
              nvl(old.trade_extend, 0) != nvl(new.trade_extend, 0) or
              nvl(old.trade_scene, 0) != nvl(new.trade_scene, 0) or
              nvl(old.trade_state, 0) != nvl(new.trade_state, 0) or
              old.pay_type != new.pay_type or old.user_id != new.user_id or
              nvl(old.out_refund_no, 0) != nvl(new.out_refund_no, 0) or
              nvl(old.out_trade_no, 0) != nvl(new.out_trade_no, 0) or
              nvl(old.act_down_refund_no, 0) !=
              nvl(new.act_down_refund_no, 0) or
              nvl(old.act_up_refund_no, 0) !=
              nvl(new.act_up_refund_no, 0) or
              nvl(old.act_down_trade_no, 0) !=
              nvl(new.act_down_trade_no, 0) or
              nvl(old.act_up_trade_no, 0) != nvl(new.act_up_trade_no, 0) or
              nvl(old.third_refund_no, 0) != nvl(new.third_refund_no, 0) or
              nvl(old.third_trade_no, 0) != nvl(new.third_trade_no, 0) or
              old.order_no != new.order_no))))) S
ON (D.trade_no = S.trade_no)
WHEN MATCHED THEN
  UPDATE
     SET D.version            = S.version,
         D.update_time        = S.update_time,
         D.create_time        = S.create_time,
         D.status             = S.status,
         D.failed_message     = S.failed_message,
         D.failed_code        = S.failed_code,
         D.tags               = S.tags,
         D.settle_refund_time = S.settle_refund_time,
         D.settle_trade_time  = S.settle_trade_time,
         D.settle_date        = S.settle_date,
         D.refund_time        = S.refund_time,
         D.trade_time         = S.trade_time,
         D.refund_amount      = S.refund_amount,
         D.trade_amount       = S.trade_amount,
         D.notify_url         = S.notify_url,
         D.trade_extend       = S.trade_extend,
         D.trade_scene        = S.trade_scene,
         D.trade_state        = S.trade_state,
         D.pay_type           = S.pay_type,
         D.user_id            = S.user_id,
         D.out_refund_no      = S.out_refund_no,
         D.out_trade_no       = S.out_trade_no,
         D.act_down_refund_no = S.act_down_refund_no,
         D.act_up_refund_no   = S.act_up_refund_no,
         D.act_down_trade_no  = S.act_down_trade_no,
         D.act_up_trade_no    = S.act_up_trade_no,
         D.third_refund_no    = S.third_refund_no,
         D.third_trade_no     = S.third_trade_no,
         D.order_no           = S.order_no
WHEN NOT MATCHED THEN
  INSERT
    (D.act_down_refund_no,
     D.act_down_trade_no,
     D.act_up_refund_no,
     D.act_up_trade_no,
     D.create_time,
     D.failed_code,
     D.failed_message,
     D.notify_url,
     D.order_no,
     D.out_refund_no,
     D.out_trade_no,
     D.pay_type,
     D.refund_amount,
     D.refund_time,
     D.settle_date,
     D.settle_refund_time,
     D.settle_trade_time,
     D.status,
     D.tags,
     D.third_refund_no,
     D.third_trade_no,
     D.trade_amount,
     D.trade_extend,
     D.trade_no,
     D.trade_scene,
     D.trade_state,
     D.trade_time,
     D.update_time,
     D.user_id,
     D.version)
  VALUES
    (S.act_down_refund_no,
     S.act_down_trade_no,
     S.act_up_refund_no,
     S.act_up_trade_no,
     S.create_time,
     S.failed_code,
     S.failed_message,
     S.notify_url,
     S.order_no,
     S.out_refund_no,
     S.out_trade_no,
     S.pay_type,
     S.refund_amount,
     S.refund_time,
     S.settle_date,
     S.settle_refund_time,
     S.settle_trade_time,
     S.status,
     S.tags,
     S.third_refund_no,
     S.third_trade_no,
     S.trade_amount,
     S.trade_extend,
     S.trade_no,
     S.trade_scene,
     S.trade_state,
     S.trade_time,
     S.update_time,
     S.user_id,
     S.version);

###################TODO
1. stop flink sync job
2. stop the connector
3. stop the flink standalone cluster

