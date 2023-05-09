##modify source code
***共计修改8个文件（2.3.0）***
涉及相关的模块：debezium-connector-oracle和debezium-core  
关键字：ZoneOffset.UTC改为ZoneOffset.of("+8")即可  
*Note: 全量替换，测试类可以不用替换；如果在因mysql时区问题已修改debezium-core模块，则忽略该模块修改*

debezium-connector-oracle模块中，还需修改两处。  
* io.debezium.connector.oracle.OracleValueConverters类的field GMT_ZONE_ID  
```
//  private static final ZoneId GMT_ZONE_ID = ZoneId.of("GMT");
    private static final ZoneId GMT_ZONE_ID = ZoneId.of("+08:00");
```
> 该处控制数据值转换的核心逻辑，涉及时间相关的字段，都与时区有关。其中，第一行代码为源代码，已被注释；第二行代码为新增代码，替换已有GMT时区。

* io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource#setNlsSessionParameters
```
// This is necessary so that TIMESTAMP WITH LOCAL TIME ZONE is returned in UTC
//  connection.executeWithoutCommitting("ALTER SESSION SET TIME_ZONE = '00:00'");
    connection.executeWithoutCommitting("ALTER SESSION SET TIME_ZONE = '+08:00'");
```
> 该处控制在增量处理时，带时区相关timestamp类型值的处理，需设定为+8时区。

##build
Refers to doc（How to  build debezium oracle connector（编译debezium oracle包）.md） in local pc.

##deploy
After building completion, replaces jars in connector directory with built jars.

The whole config is as flows:
```json
{
     "name": "devdbora0",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.tb_test:id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle0",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "initial",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.tb_test",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his0"
     }
  }
```

curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d@/opt/kafka_2.12-2.7.0/connector-json/devdbora0.json http://localhost:8083/connectors