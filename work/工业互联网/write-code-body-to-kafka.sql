-- According to the Iceberg official website, no content indicates that Iceberg can be used in conjunction
-- with resource manager Yarn

-- bin/start-cluster.sh
-- bin/sql-client.sh embedded

-- The debezium-json format does not support being written, only for being read.
-- The json format can be used to write, but null values and nested json are difficult to construct.
-- Therefore, recommend to write a program to handle this.

SET execution.runtime-mode = 'batch';
SET sql-client.execution.result-mode=tableau;
SET parallelism.default=1;

CREATE CATALOG hadoop_catalog WITH (
  'type'='iceberg',
  'catalog-type'='hadoop',
  'warehouse'='hdfs:///hadoop_catalog',
  'property-version'='1'
);

drop table if exists default_catalog.default_database.kafka_j_trip_sync;
create table if not exists default_catalog.default_database.kafka_j_trip_sync
(
    biz_id string,
    trip_no string,
    fellow_no string,
    ttsp_trip_no string,
    ttsp_fellow_no string,
    user_id string,
    app_id string,
    in_voucher_no string,
    in_line_no string,
    in_station_no string,
    in_terminal_no string,
    in_time bigint,
    in_status string,
    in_sys_time bigint,
    in_sys_lng string,
    in_sys_lat string,
    in_confirm_type string,
    out_voucher_no string,
    out_line_no string,
    out_station_no string,
    out_terminal_no string,
    out_time bigint,
    out_status string,
    out_sys_time bigint,
    out_sys_lng string,
    out_sys_lat string,
    out_confirm_type string,
    mileage  int,
    trip_sts string,
    trip_sts_seq int,
    op_id string,
    service_id string,
    in_qrcode_data string,
    in_line_name string,
    in_station_name string,
    out_qrcode_data string,
    out_line_name string,
    out_station_name string,
    recv_time bigint,
    sync_time bigint,
    sync_status string,
    sync_remark string,
    trip_change_reason string,
    voucher_data_carrier string,
    extra string,
    acc_no string
) WITH (
      'connector' = 'kafka',
      'topic' = 'temp.industry.j_trip_sync',
      'properties.group.id' = 'temp_gch',
      'properties.bootstrap.servers' = 'kafka1:9093,kafka2:9093,kafka3:9093',
      'properties.transaction.timeout.ms' = '600000', -- transaction.max.timeout.ms for kafka broker = 15 minutes
      'key.format' = 'json',
      'key.fields' = 'biz_id;trip_no;fellow_no;trip_sts_seq',
      'value.format' = 'json',
      'sink.delivery-guarantee' = 'exactly-once',
      'sink.transactional-id-prefix' = 'kafka_j_trip_sync',
      'sink.parallelism' = '3'
      );

insert into default_catalog.default_database.kafka_j_trip_sync
select
    biz_id,
    trip_no,
    fellow_no,
    ttsp_trip_no,
    ttsp_fellow_no,
    user_id,
    app_id,
    in_voucher_no,
    in_line_no,
    in_station_no,
    in_terminal_no,
    unix_timestamp(date_format(in_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as in_time,
    in_status,
    unix_timestamp(date_format(in_sys_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as in_sys_time,
    in_sys_lng,
    in_sys_lat,
    in_confirm_type,
    out_voucher_no,
    out_line_no,
    out_station_no,
    out_terminal_no,
    unix_timestamp(date_format(out_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as out_time,
    out_status,
    unix_timestamp(date_format(out_sys_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as out_sys_time,
    out_sys_lng,
    out_sys_lat,
    out_confirm_type,
    mileage,
    trip_sts,
    trip_sts_seq,
    op_id,
    service_id,
    in_qrcode_data,
    in_line_name,
    in_station_name,
    out_qrcode_data,
    out_line_name,
    out_station_name,
    unix_timestamp(date_format(recv_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as recv_time,
    unix_timestamp(date_format(sync_time, 'yyyy-MM-dd HH:mm:ss')) * 1000 as sync_time,
    sync_status,
    sync_remark,
    trip_change_reason,
    voucher_data_carrier,
    extra,
    acc_no
from hadoop_catalog.stg.t_bwt_ttsp_tdtp_j_trip_sync
where data_dt = '20231121' and debezium_op = 'c' limit 30;

-- bin/stop-cluster.sh