REF:  
https://debezium.io/documentation/reference/1.6/connectors/oracle.html#oracle-connector-properties  
https://oldcamel.run/post/kafka-shi-xian-oracle-de-cdc-shu-ju-shi-shi-bian-geng/  
https://www.cnblogs.com/wangbin2188/p/14578421.html  
https://segmentfault.com/a/1190000039395164  
https://www.cnblogs.com/shanfeng1000/p/14638455.html  
https://docs.confluent.io/platform/current/connect/references/restapi.html  
https://cloud.baidu.com/doc/DORIS/s/ykmealv2q  
https://cloud.baidu.com/doc/DORIS/s/Zkmealo19

#ORACLE准备
```sql
alter system set db_recovery_file_dest_size = 10G;
alter system set db_recovery_file_dest = '/home/oracle/oradta/recovery_area' scope=spfile;
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
archive log list;
exit;

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;

CREATE TABLESPACE logminer_tbs DATAFILE '/opt/oracle/oradata/ORCLCDB/logminer_tbs.dbf'
    SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
	
CREATE USER logminer IDENTIFIED BY logminer
DEFAULT TABLESPACE logminer_tbs
QUOTA UNLIMITED ON logminer_tbs;

CREATE TABLESPACE logminer_tbs DATAFILE '/u01/app/oracle/oradata/ora11g/logminer_tbs.dbf'
    SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;

CREATE USER logminer IDENTIFIED BY logminer
  DEFAULT TABLESPACE logminer_tbs
  QUOTA UNLIMITED ON logminer_tbs;

GRANT CREATE SESSION TO logminer;
GRANT CREATE TABLE TO logminer;
GRANT CREATE SEQUENCE TO logminer;
GRANT CREATE TRIGGER TO logminer;
GRANT SELECT ON V_$DATABASE to logminer;
GRANT FLASHBACK ANY TABLE TO logminer;
GRANT SELECT ANY TABLE TO logminer;
GRANT SELECT_CATALOG_ROLE TO logminer;
GRANT EXECUTE_CATALOG_ROLE TO logminer;
GRANT SELECT ANY TRANSACTION TO logminer;
GRANT LOCK ANY TABLE TO logminer;
GRANT ALTER ANY TABLE TO logminer;
GRANT EXECUTE ON DBMS_LOGMNR TO logminer;
GRANT EXECUTE ON DBMS_LOGMNR_D TO logminer;
GRANT SELECT ON V_$LOG TO logminer;
GRANT SELECT ON V_$LOG_HISTORY TO logminer;
GRANT SELECT ON V_$LOGMNR_LOGS TO logminer;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO logminer;
GRANT SELECT ON V_$LOGMNR_PARAMETERS TO logminer;
GRANT SELECT ON V_$LOGFILE TO logminer;
GRANT SELECT ON V_$ARCHIVED_LOG TO logminer;
GRANT SELECT ON V_$ARCHIVE_DEST_STATUS TO logminer;
GRANT SELECT ON SYSTEM.LOGMNR_COL$ TO logminer;
GRANT SELECT ON SYSTEM.LOGMNR_OBJ$ TO logminer;
GRANT SELECT ON SYSTEM.LOGMNR_USER$ TO logminer;
GRANT SELECT ON SYSTEM.LOGMNR_UID$ TO logminer;
GRANT LOGMINING TO logminer;
GRANT EXECUTE ON DBMS_LOGMNR TO logminer;
GRANT EXECUTE ON DBMS_LOGMNR_D TO logminer;
```
**注意：CDH环境，因包不兼容，故才使用Docker环境构建新环境，CDH环境部分内容可忽略**
************************************************************************
#CDH环境
1. KAFKA【每】节点配置debezium组件及其依赖，如果是单个节点执行，则记得同步至其他KAFKA节点  
```shell
wget "https://download.oracle.com/otn_software/linux/instantclient/19600/instantclient-basiclite-linux.x64-19.6.0.0.0dbru.zip" -O /tmp/ic.zip
unzip /tmp/ic.zip -d client(用于配置环境变量)
vi ~/.bash_profile
export LD_LIBRARY_PATH=/root/gch/debezium/client/instantclient_19_6(上述解压路径)
```
2. 在$KAFKA_HOME创建connectors目录，下载connector包及oracle驱动包  
```shell
cd /opt/cloudera/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774/lib/kafka; mkdir connectors
wget "https://oss.sonatype.org/service/local/artifact/maven/redirect?r=snapshots&g=io.debezium&a=debezium-connector-oracle&v=LATEST&c=plugin&e=tar.gz" -O /tmp/dbz-ora.tgz
tar -zxf /tmp/dbz-ora.tgz -C connectors
cd connectors/debezium-connector-oracle
curl https://maven.xwiki.org/externals/com/oracle/jdbc/ojdbc8/12.2.0.1/ojdbc8-12.2.0.1.jar -o ojdbc8-12.2.0.1.jar
```

3. 创建connector所需的kafka topic  
```shell
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --create --topic connect-status --replication-factor 2 --partitions 3
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --create --topic connect-configs --replication-factor 2 --partitions 3
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --create --topic connect-offsets --replication-factor 2 --partitions 3

# 删除topic
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --delete --topic connect-status
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --delete --topic connect-configs
kafka-topics --zookeeper hadoop189:2181,Hadoop191:2181,hadoop191:2181 --delete --topic connect-offsets

# 查看topic
bin/kafka-topics.sh --list --zookeeper hadoop189:2181

# for docker
bin/kafka-topics.sh  --zookeeper 172.18.0.2:2181 --create --topic connect-status --replication-factor 1 --partitions 1 --config cleanup.policy=compact
bin/kafka-topics.sh  --zookeeper 172.18.0.2:2181 --create --topic connect-configs --replication-factor 1 --partitions 1 --config cleanup.policy=compact
bin/kafka-topics.sh  --zookeeper 172.18.0.2:2181 --create --topic connect-offsets --replication-factor 1 --partitions 1 --config cleanup.policy=compact

bin/kafka-topics.sh --list --zookeeper 172.18.0.2:2181
bin/kafka-topics.sh --zookeeper 172.18.0.2:2181 --delete --topic connect-status
bin/kafka-topics.sh --zookeeper 172.18.0.2:2181 --delete --topic connect-configs
bin/kafka-topics.sh --zookeeper 172.18.0.2:2181 --delete --topic connect-offsets
```

4. 修改kafka connect配置文件  
KAFKA【每】节点，新建kafka connect配置文件
/opt/cloudera/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774/lib/kafka/config/connect-distributed.properties
```
#kafka-connect配置文件
# kafka集群地址
bootstrap.servers=hadoop189:9092,Hadoop191:9092,hadoop191:9092

# Connector集群的名称，同一集群内的Connector需要保持此group.id一致
group.id=connect-cluster

# 存储到kafka的数据格式
key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter
key.converter.schemas.enable=false
value.converter.schemas.enable=false

# 内部转换器的格式，针对offsets、config和status，一般不需要修改
internal.key.converter=org.apache.kafka.connect.json.JsonConverter
internal.value.converter=org.apache.kafka.connect.json.JsonConverter
internal.key.converter.schemas.enable=false
internal.value.converter.schemas.enable=false

# 用于保存offsets的topic，应该有多个partitions，并且拥有副本(replication)
# Kafka Connect会自动创建这个topic，但是你可以根据需要自行创建
offset.storage.topic=connect-offsets
offset.storage.replication.factor=2
offset.storage.partitions=3

# 保存connector和task的配置，应该只有1个partition，并且有多个副本
config.storage.topic=connect-configs
config.storage.replication.factor=2

# 用于保存状态，可以拥有多个partition和replication
status.storage.topic=connect-status
status.storage.replication.factor=2
status.storage.partitions=3

# Flush much faster than normal, which is useful for testing/debugging
offset.flush.interval.ms=10000

# REST主机名，默认为本机
#rest.host.name=
# REST端口号
rest.port=18083

# The Hostname & Port that will be given out to other workers to connect to i.e. URLs that are routable from other servers.
#rest.advertised.host.name=
#rest.advertised.port=

# 保存connectors的路径
#plugin.path=/usr/local/share/java,/usr/local/share/kafka/plugins,/opt/connectors,
plugin.path=/opt/cloudera/parcels/CDH/lib/kafka/connectors
```

5. KAFKA【每】节点启动connector服务，connect服务日志在$KAFKA_HOME/log下
```shell
bin/connect-distributed.sh  -daemon config/connect-distributed.properties
# 启动前，确保任何18083端口的连接被完全关闭
# xcall为批处理shell脚本，会自动调度集群中每个节点执行shell
xcall "source /etc/profile; cd $KAFKA_HOME;bin/connect-distributed.sh  -daemon config/connect-distributed.properties"
# 查看服务是否启动
xcall "jps -l|grep ConnectDistributed"
# 杀死connector服务
xcall "jps -l|grep ConnectDistributed|awk '{print $1}'|xargs kill -9"
# 杀掉后，确保任何18083端口的连接被完全关闭
xcall "netstat -an|grep 8083"
```

6. 创建并启动oracle cdc connector
```shell
curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "devdbora",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "dev_oracle",
       "database.user" : "logminer",
       "database.password" : "logminer",
	   "database.dbname" : "ora11g",
	   "table.include.list":"dba_test.tb_test,dba_test.tb_test1",
       "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
       "database.history.kafka.bootstrap.servers" : "hadoop189:9092",
       "database.history.kafka.topic": "dev_oracle_his"
   }
}' \
http://Hadoop191:18083/connectors

curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "devdbora",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "dev_oracle",
       "database.user" : "logminer",
       "database.password" : "logminer",
	   "database.dbname" : "ora11g",
	   "table.include.list":"dba_test.tb_test,dba_test.tb_test1",
       "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
       "database.history.kafka.bootstrap.servers" : "localhost:9092",
       "database.history.kafka.topic": "dev_oracle_his"
   }
}' \
http://localhost:18083/connectors
```
	   
7. 查看oracle cdc connector状态
```shell
# 查看有哪些connector
curl -X GET http://Hadoop191:18083/connectors
["devdbora"]
# 查看connector的状态
curl -X GET http://Hadoop191:18083/connectors/devdbora/status
curl -X GET http://localhost:18083/connectors/devdbora/status
# 删除指定connector，对应kafka数据不会删除
curl -X DELETE http://Hadoop191:18083/connectors/devdbora
curl -X DELETE http://localhost:18083/connectors/devdbora
# 重启connector
curl -X POST http://Hadoop191:18083/connectors/devdbora/restart
```

8. 尝试消费cdc connector捕捉的kafka数据
```shell
bin/kafka-topics.sh --list --zookeeper hadoop189:2181
bin/kafka-topics.sh --list --zookeeper 172.18.0.2:2181

bin/kafka-console-consumer.sh --bootstrap-server hadoop189:59092 --topic dev_oracle.DBA_TEST.TB_TEST --from-beginning
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dev_oracle.DBA_TEST.TB_TEST --from-beginning
```

> 运行一段时间后，发现以下错误，原因是2.1.0-cdh6.2.1版本的org.apache.kafka.clients.producer.KafkaProducer.close方法签名为(long timeout, TimeUnit timeUnit)，而debezium的使用的社区版本kafka，其版本号为2.7.0，KafkaProducer.close方法签名为（java/time/Duration）
{"name":"devdbora","connector":{"state":"RUNNING","worker_id":"88.88.16.190:18083"},"tasks":[{"state":"FAILED","trace":"java.lang.NoSuchMethodError: org.apache.kafka.clients.producer.KafkaProducer.close(Ljava/time/Duration;)V\n\tat io.debezium.relational.history.KafkaDatabaseHistory.stop(KafkaDatabaseHistory.java:458)\n\tat io.debezium.relational.HistorizedRelationalDatabaseSchema.close(HistorizedRelationalDatabaseSchema.java:58)\n\tat io.debezium.connector.oracle.OracleConnectorTask.doStop(OracleConnectorTask.java:131)\n\tat io.debezium.connector.common.BaseSourceTask.stop(BaseSourceTask.java:252)\n\tat io.debezium.connector.common.BaseSourceTask.poll(BaseSourceTask.java:165)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.poll(WorkerSourceTask.java:244)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.execute(WorkerSourceTask.java:220)\n\tat org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:175)\n\tat org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:219)\n\tat java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)\n\tat java.util.concurrent.FutureTask.run(FutureTask.java:266)\n\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\n\tat java.lang.Thread.run(Thread.java:748)\n","id":0,"worker_id":"88.88.16.189:18083"}],"type":"source"}
***************************************************************************
#DOCKER环境
> docker compose文件注意点
KAFKA_ADVERTISED_HOST_NAME：广播主机名称，一般用IP指定
KAFKA_ZOOKEEPER_CONNECT：Zookeeper连接地址，格式：zoo1：port1,zoo2:port2:/path
KAFKA_LISTENERS：Kafka启动所使用的的协议及端口
KAFKA_ADVERTISED_LISTENERS：Kafka广播地址及端口，也就是告诉客户端，使用什么地址和端口能连接到Kafka，这个很重要，如果不指定，宿主机以外的客户端将无法连接到Kafka，比如我这里因为容器与宿主机做了端口映射，所以广播地址采用的是宿主机的地址及端口，告诉客户端只要连接到宿主机的指定端口就行了
KAFKA_BROKER_ID：指定BrokerId，如果不指定，将会自己生成

1. 使用docker重新构建zk、kafka环境
***新建docker-compose.yaml文件，52181,59092为映射到宿主机的端口, 2181, 9092不要去修改它们***
```
version: '3.7'
services:
  zookeeper:
    image: wurstmeister/zookeeper
    container_name: zk
    ports:
      - 52181:2181

  kafka:
    image: wurstmeister/kafka:2.13-2.7.0
    container_name: kafka
    ports:
      - 59092:9092
    environment:
      KAFKA_BROKER_ID: 0
      # 宿主机ip
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://88.88.16.189:59092
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
    depends_on:
      - zookeeper
```

```shell
docker-compose -f docker-compose.yaml up -d
docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                                                 NAMES
237ca41df5a3        wurstmeister/kafka:2.13-2.7.0   "start-kafka.sh"         2 hours ago         Up 8 minutes        0.0.0.0:59092->9092/tcp                               kafka
5047bca8a09b        wurstmeister/zookeeper          "/bin/sh -c '/usr/..."   2 hours ago         Up 8 minutes        22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:52182->2181/tcp   zk
```

2. 将上面下载的oracle客户端及connector包拷贝到docker，启动connector服务
```shell
docker cp connectors 237ca41df5a3:/opt/kafka/connectors
docker cp client 237ca41df5a3:/opt/kafka/oracle_client
docker exec -it 237ca41df5a3 /bin/bash
vi /etc/profile
export LD_LIBRARY_PATH=/opt/kafka/oracle_client/instantclient_19_6
source /etc/profile
cd $KAFKA_HOME/config
cp connect-distributed.properties connect-distributed-my.properties
vi connect-distributed-my.properties
rest.port=18083
plugin.path=/opt/kafka/connectors

bin/connect-distributed.sh -daemon config/connect-distributed-my.properties
bin/connect-distributed.sh -daemon config/connect-distributed.properties
```

You can shut down connector service by using `jps -l |grep ConnectDistributed|awk '{print $1}'|xargs kill -9`  


3. 创建cdc connector
```shell
curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "devdbora",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "dev_oracle",
       "database.user" : "logminer",
       "database.password" : "logminer",
	   "database.dbname" : "ora11g",
	   "table.include.list":"dba_test.tb_test,dba_test.tb_test1",
       "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
       "database.history.kafka.bootstrap.servers" : "localhost:9092",
       "database.history.kafka.topic": "dev_oracle_his_incr",
	   "tombstones.on.delete": "false",
	   "database.history.skip.unparseable.ddl": "true",
	   "snapshot.mode": "initial"
   }
}' \
http://localhost:18083/connectors
# 每个connector使用一个database.history.kafka.topic，不能共享？
# "tombstones.on.delete": "false"取消掉oracle connector中delete动作后的null消息，默认是true，即补null消息，便于kafka消息压缩
curl -X GET http://localhost:18083/connectors
curl -X GET http://localhost:18083/connectors/devdbora/status
curl -X POST http://localhost:18083/connectors/devdbora/restart
curl -X DELETE http://localhost:18083/connectors/devdbora
curl -X PUT http://localhost:18083/connectors/devdbora/pause
curl -X PUT http://localhost:18083/connectors/devdbora/resume
```

> tombstones.on.delete Controls whether a delete event is followed by a tombstone event.
true - a delete operation is represented by a delete event and a subsequent tombstone event.
false - only a delete event is emitted.
After a source record is deleted, emitting a tombstone event (the default behavior) allows Kafka to completely delete all events that pertain to the key of the deleted row in case log compaction is enabled for the topic.
> 
> database.history.skip.unparseable.ddl, 设置为true，屏蔽掉无法解析的ddl语句错误，具体参考官方issue。
虽然使用了table.include.list，但是connector在解析时，仍然解析了非table.include.list中的ddl语句，致connector job终止，设置为true解决该问题。

```shell
bin/kafka-topics.sh --list --zookeeper 172.18.0.2:2181 # IP为zk容器的地址，可通过docker inspect zk查看

# 尝试消费cdc数据
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dev_oracle.DBA_TEST.TB_TEST # docker内执行
bin/kafka-console-consumer.sh --bootstrap-server localhost:59092 --topic dev_oracle.DBA_TEST.TB_TEST # 宿主机执行
```

4. 启动flink消费程序，将转换后的数据写到dev_oracle.dba_test.tb_test topic
```sql
-- routine laod stop后就可以再次create
-- ON关键字后为表名，tb_test表必须先创建
CREATE ROUTINE LOAD example_db.tb_test4 ON tb_test
COLUMNS(id, name)
PROPERTIES
(
"desired_concurrent_number"="1",
"max_batch_interval" = "10",
"max_batch_rows" = "300000",
"max_batch_size" = "209715200",
"strict_mode" = "false",
"format" = "json",
"jsonpaths" = "[\"$.ID\",\"$.NAME\"]",
"strip_outer_array" = "false"
)
FROM KAFKA
(
"kafka_broker_list" = "88.88.16.189:59092",
"kafka_topic" = "dev_oracle.dba_test.tb_test",
"property.kafka_default_offsets" = "OFFSET_BEGINNING"
);

-- 修改routine load
alter routine load for tb_test4 PROPERTIES ("strip_outer_array"="true", "desired_concurrent_number"="1", "max_batch_interval"="10",  "jsonpaths"="[\"$.id\",\"$.name\"]" );
-- 查看routine load状态
show all routine load for example_db.tb_test4;
-- 查看目标表
select * from tb_test;
```


***
oracle特有参数配置：
* log.mining.strategy - online_catalog, Uses the database’s current data dictionary to resolve object ids and does not write any extra information to the online redo logs. This allows LogMiner to mine substantially faster but at the expense that DDL changes cannot be tracked. If the captured table(s) schema changes infrequently or never, this is the ideal choice.
* 



curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
   "name": "oracle_rac5",
   "config": {
       "connector.class" : "io.debezium.connector.oracle.OracleConnector",
       "tasks.max" : "1",
       "database.server.name" : "oracle_rac5",
       "database.user" : "logminer",
       "database.password" : "logminer",
	   "database.hostname": "192.168.56.103",
	   "rac.nodes" : "192.168.56.103,192.168.56.104",
       "database.port" : "1521",
	   "database.dbname" : "ocp11g",
       "snapshot.mode" : "schema_only",
	   "table.include.list":"daidai.tb_test",
	   "database.connection.adapter": "logminer",
	   "database.history.skip.unparseable.ddl": "true",
	   "tombstones.on.delete": "false",
       "database.history.kafka.bootstrap.servers" : "192.168.56.181:9092",
       "database.history.kafka.topic": "oracle_rac5_his"
   }
}' \
$CL


*Note: In rac modes, rac.nodes property is essential, and archive log of database should on sharing file system, 
such as ocfs2, asm.*