

{
   "name": "tft_xcgl",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "tft_xcgl",
       "database.user" : "logminer",
       "database.password" : "logminer",
       "database.dbname" : "ora11g",
       "database.port" : "1521",
       "database.hostname" : "88.88.16.112",
       "table.include.list" : "tft_qrcode.j_trip_open_part_.*,............",
       "message.key.columns":"tft_xcgl.j_trip_open_part_.*:trip_no,fellow_no;..............",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
       "database.history.kafka.topic": "tft_xcgl_his",
       "snapshot.mode" : "initial",
       "tombstones.on.delete": "false",
       "database.history.skip.unparseable.ddl": "true",
       "transforms" : "Reroute",
       "transforms.Reroute.type" : "io.debezium.transforms.ByLogicalTableRouter",
       "transforms.Reroute.topic.regex" : "(.*)J_TRIP_OPEN_PART(.*)",
       "transforms.Reroute.topic.replacement" : "$1J_TRIP_OPEN_PART",
       "transforms.Reroute.key.enforce.uniqueness" : "false"
   }
}

**Pay attention to separated flag in message.key.columns and table.include.list**

***

**When more than one tables are sharded, use following configuration**
{
   "name": "tft_xcgl",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "tft_xcgl",
       "database.user" : "logminer",
       "database.password" : "logminer",
       "database.dbname" : "ora11g",
       "database.port" : "1521",
       "database.hostname" : "88.88.16.112",
       "table.include.list" : "tft_qrcode.j_trip_open_part_.*,tft_qrcode.dba_test_.*",
       "message.key.columns":"tft_qrcode.j_trip_open_part_.*:trip_no,fellow_no;tft_qrcode.dba_test_.*:id1",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
       "database.history.kafka.topic": "tft_xcgl_his",
       "snapshot.mode" : "initial",
       "tombstones.on.delete": "false",
       "database.history.skip.unparseable.ddl": "true",
       "transforms" : "Reroute,Reroute1",
       "transforms.Reroute.type" : "io.debezium.transforms.ByLogicalTableRouter",
       "transforms.Reroute.topic.regex" : "(.*)J_TRIP_OPEN_PART(.*)",
       "transforms.Reroute.topic.replacement" : "$1J_TRIP_OPEN_PART",
       "transforms.Reroute.key.enforce.uniqueness" : "false",
       "transforms.Reroute1.type" : "io.debezium.transforms.ByLogicalTableRouter",
       "transforms.Reroute1.topic.regex" : "(.*)DBA_TEST(.*)",
       "transforms.Reroute1.topic.replacement" : "$1DBA_TEST",
       "transforms.Reroute1.key.enforce.uniqueness" : "false"
   }
}


If the sharded tables have the same primary key (message.key.columns), the rows including the same key will be sent
to the same partition of the same topic. You can not distinguish the order between them. Add another field into the
key to distinguish where the rows including the same key come, 
refer to [reference](https://debezium.io/documentation/reference/1.7/transformations/topic-routing.html)