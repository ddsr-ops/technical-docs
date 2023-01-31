# TODO: supervisor
# How to upgrade debezium jar

## Prepare jars
You can use jars has been built, also build jars referring to <debezium build.md> and <How to upgrade debezium oracle plugin jar£¨Éý¼¶debezium oracle jar£©.md>. 

## Backup connector config
```shell
# Get connector
curl -X GET http://localhost:8083/connectors
# Get connector config
curl -X GET http://localhost:8083/connectors/mysql_tftactdb/config > mysql_tftactdb.config
curl -X GET http://localhost:8083/connectors/tft_ups_00/config > tft_ups_00.config 
```

If you want to reconfigure connectors,  DELETING connector is essential.
```shell
curl -X DELETE http://localhost:8083/connectors/mysql_tftactdb
curl -X DELETE http://localhost:8083/connectors/tft_ups_00
```


## Stop all connector services
```shell
# On every connector node
jps -l |grep ConnectDistributed|awk '{print $1}'|xargs kill -9  
```


## Replace jars
1. Backups connector jars.  
   On one of connector nodes, backups connector jars.    
   `xcall tar -czf /opt/kafka_2.12-2.7.0/connector-bak.tgz /opt/kafka_2.12-2.7.0/connector`
2. Replace jars with prepared jars ON EVERY NODE.  
   For mysql jars.
   ```shell
   xcall "tar -zxf /tmp/debezium-1.7-mysql-enhance.tgz -C /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql"
   xcall "mv -f /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql/mysql-plugin/* /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql/"
   xcall "cp /tmp/mysql-connector-java-8.0.26.jar /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql/"
   
   # Remove original jars.
   xcall "rm -f /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql/*.Final.jar /opt/kafka_2.12-2.7.0/connector/debezium-connector-mysql/mysql-connector-java-8.0.21.jar"
   ```
   
   For oracle jars.  
   ```shell
   xcall "tar -zxf /tmp/debezium-1.7-oracle-enhance.tgz -C /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle"
   xcall "mv -f /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/oracle-plugin/* /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/"
   ```
   It`s necessary to remove original conflict jars.

## Start connector service
> If you want to delete topics writen by connectors, delete topics before starting connector service. Because connector 
> service is be started, topics which are used can not be deleted.   
> When a connector task is running, you want to add one more table to cdc, the table only be captured incrementally, 
> since task snapshot is completed recorded in the topic connect-offsets.  
> If you want to re-snapshot, you need to recreate connect-offsets topic to make it null before starting connector service 
> or modify connector name in the config to make it as another task, then start connector task in snapshot mode 'initial'.  

```shell
# On every node.
cd /opt/kafka_2.12-2.7.0; bin/connect-distributed.sh -daemon config/connect-distributed.properties;tailf logs/connect.log
```

## Start connector task

```shell
curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d@tft_ups.json http://datanode1:8083/connectors
curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d@mysql_tftactdb.json http://datanode1:8083/connectors

```

# Connector config
```
[root@namenode1 connector-json]# more mysql_tftactdb.json 
{ "name" : "mysql_tftactdb",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "tftactdb.tbl_fcl_ck_acct_balance:acct_no",
  "database.user": "db_viewer",
  "database.server.id": "184058",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
  "database.history.kafka.topic": "mysql_tftactdb.tftactdb",
  "database.server.name": "mysql_tftactdb",
  "database.port": "60001",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "10.166.84.1",
  "database.password": "psM6*33Eds",
  "database.connectionTimeZone" : "LOCAL",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "tftactdb.tbl_fcl_ck_acct_balance",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "snapshot.mode": "initial",
  "name": "mysql_tftactdb"
}
}
```

```
{
   "name": "tft_ups",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "tft_ups",
       "database.user" : "logminer",
       "database.password" : "Logminer#$321",
       "database.dbname" : "tftups",
       "database.port" : "1521",
       "database.hostname" : "10.60.6.11",
       "rac.nodes" : "10.60.6.11,10.60.6.12", 
       "table.include.list":"tft_ups.dc_trip_order",
       "message.key.columns":"tft_ups.dc_trip_order:order_no",
       "key.converter":"org.apache.kafka.connect.json.JsonConverter",
       "key.converter.schemas.enable":"false",
       "value.converter":"org.apache.kafka.connect.json.JsonConverter",
       "value.converter.schemas.enable":"false",
       "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
       "database.history.kafka.topic": "tft_ups_his",
       "snapshot.mode" : "schema_only",
       "tombstones.on.delete": "false",
       "database.history.skip.unparseable.ddl": "true"
   }
}
```