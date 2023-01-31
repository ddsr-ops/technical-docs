# TODO: supervisor
# Background

If connectors are deployed in distributed mode, we can upgrade debezium jars one by one. If so, we do not
need to stop connectors.

When the worker where the connector is running downed, the connector task will to be migrated to another
worker.


# Backup

Commonly, we need to back up debezium plugin jars and connector configurations.

## connector plugin jars

```
xcall "mv `pwd`/connector/*oracle `pwd`/connector-bak/debezium-connector-oracle-1.7"
```

Note: `xcall` command means that shell after `xcall` will be invoked on every worker.

## connector config

Firstly, get running connectors.
```
curl -X GET http://datanode1:8083/connectors
["mysql_bwt","mysql_bwt_new","mysql_tftactdb_master"]
```

Back up connector configurations.
```
curl -X GET http://datanode1:8083/connectors/mysql_bwt/config > mysql_bwt.config
curl -X GET http://datanode1:8083/connectors/mysql_bwt_new/config > mysql_bwt_new.config 
curl -X GET http://datanode1:8083/connectors/mysql_tftactdb_master/config > mysql_tftactdb_master.config 
```
After finishing backup, You must lookup the config file, ensure that backup is successful.


# Restore

Here, different from <debezium完全停机升级.md>,  we need to restart worker one by one.

## deploy plugin jars

```text
xcall "mkdir -p `pwd`/connector/debezium-connector-oracle && tar -zxf /tmp/oracle-plugin-1.8.tgz -C `pwd`/connector/debezium-connector-oracle"
```

`/tmp/oracle-plugin-1.8.tgz` was uploaded on every worker before deploying.

## restart connector service

we should restart worker one by one.

```text
[root@datanode1 connector-json]# more kill_connector_service.sh 
#!/bin/bash


source /etc/profile

source ~/.bash_profile

jps -l|grep ConnectDistributed|awk '{print $1}'|xargs kill -9

[root@datanode1 connector-json]# more start_connector_service.sh 
#!/bin/bash


cd /opt/kafka_2.12-2.7.0
bin/connect-distributed.sh  -daemon config/connect-distributed.properties

cd /opt/kafka_2.12-2.7.0/connector-json && ./kill_connector_service.sh && sleep 1 && ./start_connector_service.sh
```


#　Check

Restarting connector workers until workers are all restarted, then check the connector job status.

```text
[root@datanode5 connector-json]# ./get_connector_status.sh mysql_bwt
{"name":"mysql_bwt","connector":{"state":"RUNNING","worker_id":"10.50.253.3:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.3:8083"}],"type":"source"}[root@datanode5 connector-json]# ./get_connector_status.sh mysql_bwt_new
{"name":"mysql_bwt_new","connector":{"state":"RUNNING","worker_id":"10.50.253.3:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.3:8083"}],"type":"source"}[root@datanode5 connector-json]# ./get_connector_status.sh mysql_tftactdb_master
{"name":"mysql_tftactdb_master","connector":{"state":"RUNNING","worker_id":"10.50.253.1:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.1:8083"}],"type":"source"}[root@datanode5 connector-json]# ./get_connector_status.sh mysql_tftactdb_master
{"name":"mysql_tftactdb_master","connector":{"state":"RUNNING","worker_id":"10.50.253.1:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.1:8083"}],"type":"source"}

```

# Scripts

```shell
ls /opt/kafka_2.12-2.7.0/connector && ls /opt/kafka_2.12-2.7.0/connector-bak

cd /opt/kafka_2.12-2.7.0/connector-json/ && ./kill_connector_service.sh

cd /opt/kafka_2.12-2.7.0 && mv connector/debezium-connector-mysql connector-bak/debezium-connector-mysql-1.7 && ls /opt/kafka_2.12-2.7.0/connector-bak

unzip /tmp/debezium-connector-mysql-1.8.zip -d /opt/kafka_2.12-2.7.0/connector && cd  /opt/kafka_2.12-2.7.0/connector-json/ && ./start_connector_service.sh && tailf /opt/kafka_2.12-2.7.0/logs/connectDistributed.out
```

Note: After finished every command, confirm the output of the console.