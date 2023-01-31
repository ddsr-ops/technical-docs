# Destination

In production env, deploy flink stream job.

# Prerequisites

## Jars

```text
[root@namenode1 log]# suhdfs -ls /flink/jars
Found 18 items
-rw-r--r--   3 hdfs supergroup    7007450 2021-07-29 15:53 /flink/jars/doris-flink-1.0-SNAPSHOT.jar
-rw-r--r--   3 hdfs supergroup     196361 2021-07-29 15:53 /flink/jars/flink-connector-jdbc_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup      47662 2021-07-29 15:53 /flink/jars/flink-connector-kafka-0.10_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup      60159 2021-07-29 15:53 /flink/jars/flink-connector-kafka-0.11_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup     122956 2021-07-29 15:53 /flink/jars/flink-connector-kafka-base_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup      90819 2021-07-29 15:53 /flink/jars/flink-csv-1.11.3.jar
-rw-r--r--   3 hdfs supergroup   99519985 2021-07-29 15:53 /flink/jars/flink-dist_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup     102076 2021-08-27 10:38 /flink/jars/flink-json-1.11.3.jar
-rw-r--r--   3 hdfs supergroup    7712156 2021-07-29 15:53 /flink/jars/flink-shaded-zookeeper-3.4.14.jar
-rw-r--r--   3 hdfs supergroup   35041068 2021-07-29 15:53 /flink/jars/flink-table-blink_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup   32138761 2021-07-29 15:53 /flink/jars/flink-table_2.12-1.11.3.jar
-rw-r--r--   3 hdfs supergroup    1644596 2021-07-30 15:42 /flink/jars/hadoop-mapreduce-client-core-3.0.0-cdh6.2.1.jar
-rw-r--r--   3 hdfs supergroup    1417459 2021-07-29 15:53 /flink/jars/kafka-clients-0.11.0.2.jar
-rw-r--r--   3 hdfs supergroup      67114 2021-07-29 15:53 /flink/jars/log4j-1.2-api-2.12.1.jar
-rw-r--r--   3 hdfs supergroup     276771 2021-07-29 15:53 /flink/jars/log4j-api-2.12.1.jar
-rw-r--r--   3 hdfs supergroup    1674433 2021-07-29 15:53 /flink/jars/log4j-core-2.12.1.jar
-rw-r--r--   3 hdfs supergroup      23518 2021-07-29 15:53 /flink/jars/log4j-slf4j-impl-2.12.1.jar
-rw-r--r--   3 hdfs supergroup    1891236 2021-07-29 15:53 /flink/jars/mysql-connector-java-6.0.5.jar
```

These jars are needed by flink running environment, the path must be configured in $FLINK_HOME/conf/flink-conf.yaml, 
such as `yarn.provided.lib.dirs: hdfs:///flink/jars`

## tool jar

Tool jar is developed by ourselves. We deploy it in the directory named `hdfs:///flink/main_jars` .
```text
[root@namenode1 log]# suhdfs -ls /flink/main_jars
Found 1 items
-rw-r--r--   3 hdfs supergroup   21353404 2021-09-15 10:06 /flink/main_jars/flink_tool-1.0-SNAPSHOT.jar
```

# Development

# prepare doris table ddl

Doris will not create historical partitions, we should add partitions manually.

```text
drop table if exists sdm_s.s_tft_ups_dc_trip_order;
CREATE TABLE sdm_s.s_tft_ups_dc_trip_order (
update_time datetime comment '更新时间' ,
order_no varchar(32) comment '订单系统订单号' ,
user_id varchar(16) comment '用户号' ,
service_id varchar(2) comment '业务类型：01 - 地铁 02 - 公交' ,
.....
process_time datetime not null comment 'flink处理时间'
)
engine=olap
DUPLICATE KEY(update_time,order_no)
comment '行程订单表'
partition by range (update_time)
distributed by hash (order_no)
properties
(
  "dynamic_partition.enable" = "true",
  "dynamic_partition.time_unit" = "DAY",
  "dynamic_partition.end" = "3",
  "dynamic_partition.prefix" = "p",
  "dynamic_partition.buckets" = "10"
)
;
alter table sdm_s.s_tft_ups_dc_trip_order set ("dynamic_partition.enable" = "false");
alter table sdm_s.s_tft_ups_dc_trip_order add partition p20200313 values less than ("2020-03-14 00:00:00");
alter table sdm_s.s_tft_ups_dc_trip_order add partition p20200314 values less than ("2020-03-15 00:00:00");
alter table sdm_s.s_tft_ups_dc_trip_order add partition p20200315 values less than ("2020-03-16 00:00:00");
......
alter table sdm_s.s_tft_ups_dc_trip_order add partition p20210824 values less than ("2021-08-25 00:00:00");
alter table sdm_s.s_tft_ups_dc_trip_order add partition p20210825 values less than ("2021-08-26 00:00:00");
alter table sdm_s.s_tft_ups_dc_trip_order set ("dynamic_partition.enable" = "true");
```

## edit etl sql

Edit a sql for etl.

> NOTE: ETL sql is not relevant to ddl sql in above.

```
CREATE TABLE kafka_tbl_fcl_ck_acct_balance (
 id int,
 acct_no string,
 acct_name string ,
 acct_cata string ,
 acct_status string,
 user_id string,
 sbjt_cd string,
 current_direct string,
 current_balance String ,
 freeze_at String,
 status_change_date string,
 freeze_level string,
 rec_crt_ts string,
 rec_upd_ts string,
 op string
) WITH (
 'connector' = 'kafka-0.11',
 'topic' = 'mysql_tftactdb.tftactdb.tbl_fcl_ck_acct_balance',
 'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
 'properties.group.id' = 'kafka_tbl_fcl_ck_acct_balance',
 'format' = 'debezium-json_op',
 'scan.startup.mode' = 'earliest-offset'
);
CREATE TABLE doris_table (
rec_upd_ts string,
 id int,
 acct_no string,
 acct_name string ,
 acct_cata string ,
 acct_status string,
 user_id string,
 sbjt_cd string,
 current_direct string,
 current_balance decimal(16,0) ,
 freeze_at decimal(16,0),
 status_change_date string,
 freeze_level string,
 rec_crt_ts string,
 op string

) WITH (
'connector' = 'doris',
'fenodes'='namenode2:8034',
'table.identifier' = 'sdm_s.s_tbl_fcl_ck_acct_balance',
'username' = 'flink',
'password' = 'flink',
'sink.batch.size' = '40000',
'sink.max-retries' = '3',
'sink.batch.interval'='4min'
);
insert into doris_table select
date_format(TIMESTAMPADD(HOUR,8,string2timestamp(rec_upd_ts)),'yyyy-MM-dd HH:mm:ss') rec_upd_ts,
 id,
 acct_no,
 acct_name,
 acct_cata,
 acct_status,
 user_id,
 sbjt_cd,
 current_direct,
 cast(string2decimal(current_balance,0) as decimal(16,0) ) ,
 cast(string2decimal(freeze_at,0) as decimal(16,0)),
 status_change_date,
 freeze_level,
date_format(TIMESTAMPADD(HOUR,8,string2timestamp(rec_crt_ts)),'yyyy-MM-dd HH:mm:ss') rec_crt_ts,
op,
date_fromat(cast( PROCTIME() as timestamp with LOCAL TIME ZONE),'yyyy-MM-dd HH:mm:ss') process_time
 from kafka_tbl_fcl_ck_acct_balance
```

# Deployment

# create doris table

Invoke doris table create sql in doris command.

# launch stream job

1. Upload etl sql to hdfs file system.

2. Starts stream job.
    `/opt/flink-1.11.3/bin/flink run-application -t yarn-application  -Dyarn.application.name=kafka_tbl_fcl_ck_acct_balance  -c com.tft.flink.base.BaseStreamFlinkJob hdfs:///flink/main_jars/flink_
tool-1.0-SNAPSHOT.jar -file /warehouse/workspace/04_flink/01_sdm_s/kafka_tbl_fcl_ck_acct_balance.sql`
   > Sql file is on hdfs file system.

