##modify source code
涉及相关的模块：debezium-connector-mysql和debezium-core  
关键字：ZoneOffset.UTC改为ZoneOffset.of("+8")即可  
*Note: 全量替换，测试类可以不用替换*

##build
Refers to 《debezium build.md》 in local pc.

##deploy
Adds an extra config parameter - "database.connectionTimeZone", which must be "LOCAL".
If it is "SERVER", relative time values of cdc data are wrong. In details, You can see 
io.debezium.connector.mysql.MySqlConnection.MySqlConnectionConfiguration#MySqlConnectionConfiguration
```
// Only when performing a snapshot, the code will be executed.
jdbcConfigBuilder.with(JDBC_PROPERTY_CONNECTION_TIME_ZONE, determineConnectionTimeZone(dbConfig))
```

The whole config is as flows:
```json
{ "name" : "mysql_tftactdb",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "tftactdb.tbl_fcl_ck_acct_balance:acct_no",
  "database.user": "logminer",
  "database.server.id": "184056",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "hadoop189:9093,hadoop190:9093,hadoop191:9093",
  "database.history.kafka.topic": "mysql_tftactdb.tftactdb",
  "database.server.name": "mysql_tftactdb",
  "database.port": "3306",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "88.88.16.113",
  "database.password": "logminer",
  "database.connectionTimeZone" : "LOCAL",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "tftactdb.tbl_fcl_ck_acct_balance",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "snapshot.mode": "initial"
}
}
```

##Referring
**connectionTimeZone**  
Configures the connection time zone which is used by Connector/J if conversion between the JVM default and a target time zone is needed when preserving instant temporal values.[CR]Accepts a geographic time zone name or a time zone offset from Greenwich/UTC, using a syntax 'java.time.ZoneId' is able to parse, or one of the two logical values "LOCAL" and "SERVER". Default is "LOCAL". If set to an explicit time zone then it must be one that either the JVM or both the JVM and MySQL support. If set to "LOCAL" then the driver assumes that the connection time zone is the same as the JVM default time zone. If set to "SERVER" then the driver attempts to detect the session time zone from the values configured on the MySQL server session variables 'time_zone' or 'system_time_zone'. The time zone detection and subsequent mapping to a Java time zone may fail due to several reasons, mostly because of time zone abbreviations being used, in which case an explicit time zone must be set or a different time zone must be configured on the server.[CR]This option itself does not set MySQL server session variable 'time_zone' to the given value. To do that the 'forceConnectionTimeZoneToSession' connection option must be set to "true".[CR]Please note that setting a value to 'connectionTimeZone' in conjunction with 'forceConnectionTimeZoneToSession=false' and 'preserveInstants=false' has no effect since, in this case, neither this option is used to change the session time zone nor used for time zone conversions of time-based data.[CR]Former connection option 'serverTimezone' is still valid as an alias of this one but may be deprecated in the future.[CR]See also 'forceConnectionTimeZoneToSession' and 'preserveInstants' for more details.