```sql
create table if not exists default_catalog.default_database.kafka_j_trip_sync
(
    ......
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
      )
```

The insert sql writes data into the kafka topic.

```sql

insert into default_catalog.default_database.kafka_j_trip_sync
select * from default_catalog.default_database.kafka_j_trip_sync;

```

If the property `'properties.transaction.timeout.ms'` is more than 900000, then the insert action will fail.
