# 目标
1. 部署shardingsphere proxy
2. 部署shardingsphere scaling，并验证其增量迁移
3. 部署shardingsphere ui
4. 对proxy进行压力测试

# 准备
* MySQL安装包准备，略
* MySQL驱动包准备，建议选择5.1.47版本，略
* shardingsphere 4.1.1相关组件包，[下载链接](https://archive.apache.org/dist/shardingsphere/)

***特别提醒：所有的mysql环境，库、表字符集必须保持一致，否则会出现中文乱码***

# 环境
| IP地址 | 服务 | 
| :----:| :----: |
| 88.88.16.112 | MySQL |
| 88.88.16.113 | MySQL | 
| 88.88.16.126 | shardingsphere proxy, scaling, ui 4.1.1, zk, MySQL | 

# 安装
## mysql安装
略。
### mysql测试表准备
在112服务器上的MySQL上执行：
```sql
create database demo_ds_0 default character set utf8mb4;
use demo_ds_0;
create table t_order_0
(
  order_id bigint not null auto_increment primary key,
  user_id bigint not null,
  name varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table t_order_1
(
  order_id bigint not null auto_increment primary key,
  user_id bigint not null,
  name varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_order_item_0` (
  `order_id` bigint(20) NOT NULL,
  `item` varchar(100) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_order_item_1` (
  `order_id` bigint(20) NOT NULL,
  `item` varchar(100) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE t_dt_0 (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  context varchar(2048) DEFAULT NULL,
  dt datetime DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE t_dt_1 (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  context varchar(2048) DEFAULT NULL,
  dt datetime DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);
```

在113服务器上的MySQL上执行：
```sql
create database demo_ds_1 default character set utf8mb4;
use demo_ds_1;
create table t_order_0
(
  order_id bigint not null auto_increment primary key,
  user_id bigint not null,
  name varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table t_order_1
(
  order_id bigint not null auto_increment primary key,
  user_id bigint not null,
  name varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_order_item_0` (
  `order_id` bigint(20) NOT NULL,
  `item` varchar(100) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `t_order_item_1` (
  `order_id` bigint(20) NOT NULL,
  `item` varchar(100) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE t_dt_0 (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  context varchar(2048) DEFAULT NULL,
  dt datetime DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE t_dt_1 (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  context varchar(2048) DEFAULT NULL,
  dt datetime DEFAULT NULL,
  ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);
```

## zookeeper安装
略。  
**注意：确保zookeeper启动成功，可以通过`ps -ef|grep zookeeper`查看进程是否启动**

## proxy安装
### 配置proxy
```shell
mkdir -p /opt/shardingsphere
tar -zxf apache-shardingsphere-4.1.1-sharding-proxy-bin.tar.gz -C /opt/shardingsphere/
mv /opt/shardingsphere/apache-shardingsphere-4.1.1-sharding-proxy-bin /opt/shardingsphere/sharding-proxy-4.1.1
# 拷贝MySQL驱动包到proxy lib目录下
cp mysql-connector-java-5.1.47.jar /opt/shardingsphere/sharding-proxy-4.1.1/lib/
```

#### 配置分片规则
```shell
vim /opt/shardingsphere/sharding-proxy-4.1.1/conf/config-sharding.yaml
schemaName: sharding_db

dataSources:
  ds_0:
    url: jdbc:mysql://88.88.16.112:3306/demo_ds_0?serverTimezone=Asia/Shanghai&useSSL=false&characterEncoding=utf8&character_set_server=utf8mb4&connectionCollation=utf8mb4_bin
    username: root
    password: root
    connectionTimeoutMilliseconds: 30000
    idleTimeoutMilliseconds: 60000
    maxLifetimeMilliseconds: 1800000
    maxPoolSize: 50
  ds_1:
    url: jdbc:mysql://88.88.16.113:3306/demo_ds_1?serverTimezone=Asia/Shanghai&useSSL=false&characterEncoding=utf8&character_set_server=utf8mb4&connectionCollation=utf8mb4_bin
    username: root
    password: root
    connectionTimeoutMilliseconds: 30000
    idleTimeoutMilliseconds: 60000
    maxLifetimeMilliseconds: 1800000
    maxPoolSize: 50

shardingRule:
  tables:
    t_order:
      actualDataNodes: ds_${0..1}.t_order_${0..1}
      tableStrategy:
        inline:
          shardingColumn: order_id
          algorithmExpression: t_order_${order_id % 2}
      keyGenerator:
        type: SNOWFLAKE
        column: order_id
    t_order_item:
      actualDataNodes: ds_${0..1}.t_order_item_${0..1}
      tableStrategy:
        inline:
          shardingColumn: order_id
          algorithmExpression: t_order_item_${order_id % 2}
      keyGenerator:
        type: SNOWFLAKE
        column: order_item_id
    t_dt:
      actualDataNodes: ds_${0..1}.t_dt_${0..1}
      tableStrategy:
        inline:
          shardingColumn: id
          algorithmExpression: t_dt_${id % 2}
      databaseStrategy:
        inline:
          shardingColumn: id
          algorithmExpression: ds_${id % 2}
      keyGenerator:
        type: SNOWFLAKE
        column: id
  bindingTables:
    - t_order,t_order_item
  defaultDatabaseStrategy:
    inline:
      shardingColumn: user_id
      algorithmExpression: ds_${user_id % 2}
  defaultTableStrategy:
    none:
```

#### 配置治理及权限
```shell
vi  /opt/shardingsphere/sharding-proxy-4.1.1/conf/server.yaml

orchestration:
  orchestration_ds:
    orchestrationType: registry_center,config_center,distributed_lock_manager
    instanceType: zookeeper
    serverLists: localhost:2181
    namespace: orchestration
    props:
      overwrite: true
      retryIntervalMilliseconds: 500
      timeToLiveSeconds: 60
      maxRetries: 3
      operationTimeoutMilliseconds: 500

authentication:
  users:
    root:
      password: root
    sharding:
      password: sharding 
      authorizedSchemas: sharding_db

props:
  max.connections.size.per.query: 1
  acceptor.size: 16  # The default value is available processors count * 2.
  executor.size: 16  # Infinite by default.
  proxy.frontend.flush.threshold: 128  # The default value is 128.
    # LOCAL: Proxy will run with LOCAL transaction.
    # XA: Proxy will run with XA transaction.
    # BASE: Proxy will run with B.A.S.E transaction.
  proxy.transaction.type: LOCAL
  proxy.opentracing.enabled: false
  proxy.hint.enabled: false
  query.with.cipher.column: true
  sql.show: true
  allow.range.query.with.inline.sharding: false
```

### 启动proxy
```shell
cd /opt/shardingsphere/sharding-proxy-4.1.1/bin
# 指定启动端口，该端口用于程序连接的代理端口
./start.sh 13308
tail -n 20 ../logs/stdout.log
```
检查日志，查看是否启动成功。
使用客户端连接proxy, `mysql -uroot -proot -h88.88.16.126 -P13308`，登录成功，即代理可用。

## scaling安装
4.1.1版本scaling，重启scaling后，历史任务消失。

### source端mysql环境准备
首先创建scaling数据库，作为复制的源端  
scaling数据拓扑：  
88.88.16.126 -->  proxy -- 88.88.16.112  
                        -- 88.88.16.113  
```sql
mysql> use scaling;
Database changed
mysql> show tables;
Empty set (0.00 sec)

mysql> create table t_order
    -> (
    ->   order_id bigint not null auto_increment primary key,
    ->   user_id bigint not null,
    ->   name varchar(100)
    -> ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### 配置scaling
```shell
tar -zxf apache-shardingsphere-4.1.1-sharding-scaling-bin.tar.gz -C /opt/shardingsphere
mv /opt/shardingsphere/apache-shardingsphere-4.1.1-sharding-scaling-bin /opt/shardingsphere/sharding-scaling
# 拷贝MySQL驱动包
cp /opt/shardingsphere/sharding-proxy-4.1.1/lib/mysql-connector-java-5.1.47.jar /opt/shardingsphere/sharding-scaling/lib/
cd /opt/shardingsphere/sharding-scaling/
# 根据需要调整server.yaml，4.1.1无需配置zk， 5+版本需要配置zk
vim conf/server.yaml 
sh bin/start.sh 
tail -n 50 logs/stdout.log 
```

### 创建并启动scaling任务
**注意：创建scaling任务前，确保proxy、scaling启动成功**

单表scaling
```shell
curl -X POST --url http://127.0.0.1:8888/shardingscaling/job/start \
--header 'content-type: application/json' \
--data '{
   "ruleConfiguration": {
      "sourceDatasource": "ds_0: !!org.apache.shardingsphere.orchestration.core.configuration.YamlDataSourceConfiguration\n  dataSourceClassName: com.zaxxer.hikari.HikariDataSource\n  properties:\n    jdbcUrl: jdbc:mysql://127.0.0.1:3306/scaling?serverTimezone=Asia/Shanghai&useSSL=false&characterEncoding=utf8&character_set_server=utf8mb4&connectionCollation=utf8mb4_bin\n    driverClassName: com.mysql.jdbc.Driver\n    username: root\n    password: root\n    connectionTimeout: 30000\n    idleTimeout: 60000\n    maxLifetime: 180000\n    maxPoolSize: 2\n    minPoolSize: 1\n    maintenanceIntervalMilliseconds: 30000\n    readOnly: false\n",
      "sourceRule": "tables:\n t_order:\n    actualDataNodes: ds_0.t_order\n    keyGenerator:\n      column: order_id\n      type: SNOWFLAKE",
      "destinationDataSources": {
         "name": "dt_1",
         "password": "root",
         "url": "jdbc:mysql://127.0.0.1:13308/sharding_db?serverTimezone=UTC&useSSL=false&characterEncoding=UTF-8",
         "username": "root"
      }
   },
   "jobConfiguration": {
      "concurrency": 1
   }
}'
```

多表scaling
```shell
curl -X POST --url http://127.0.0.1:8888/shardingscaling/job/start \
--header 'content-type: application/json' \
--data '{
   "ruleConfiguration": {
      "sourceDatasource": "ds_0: !!org.apache.shardingsphere.orchestration.core.configuration.YamlDataSourceConfiguration\n  dataSourceClassName: com.zaxxer.hikari.HikariDataSource\n  properties:\n    jdbcUrl: jdbc:mysql://127.0.0.1:3306/scaling?serverTimezone=Asia/Shanghai&useSSL=false&characterEncoding=utf8&character_set_server=utf8mb4&connectionCollation=utf8mb4_bin\n    driverClassName: com.mysql.jdbc.Driver\n    username: root\n    password: root\n    connectionTimeout: 30000\n    idleTimeout: 60000\n    maxLifetime: 180000\n    maxPoolSize: 2\n    minPoolSize: 1\n    maintenanceIntervalMilliseconds: 30000\n    readOnly: false\n",
      "sourceRule": "tables:\n t_order_item:\n    actualDataNodes: ds_0.t_order_item\n    keyGenerator:\n      column: order_id\n      type: SNOWFLAKE  \n t_order:\n    actualDataNodes: ds_0.t_order\n    keyGenerator:\n      column: order_id\n      type: SNOWFLAKE \n t_dt:\n    actualDataNodes: ds_0.t_dt\n    keyGenerator:\n      column: id\n      type: SNOWFLAKE",
      "destinationDataSources": {
         "name": "dt_1",
         "password": "root",
         "url": "jdbc:mysql://127.0.0.1:13308/sharding_db?serverTimezone=UTC&useSSL=false&characterEncoding=UTF-8",
         "username": "root"
      }
   },
   "jobConfiguration": {
      "concurrency": 1
   }
}'
```
*自官方文档指导，创建任务失败， 参考如下链接[参考链接](https://blog.csdn.net/beichen8641/article/details/106924189/?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_title~default-0.control&spm=1001.2101.3001.4242)*

```shell
curl -X POST --url http://127.0.0.1:8888/shardingscaling/job/start \
--header 'content-type: application/json' \
--data '{
   "ruleConfiguration": {
      "sourceDatasource": "ds_0: !!org.apache.shardingsphere.orchestration.core.configuration.YamlDataSourceConfiguration\n  dataSourceClassName: com.zaxxer.hikari.HikariDataSource\n  properties:\n    jdbcUrl: jdbc:mysql://127.0.0.1:3306/scaling?serverTimezone=Asia/Shanghai&useSSL=false&characterEncoding=utf8&character_set_server=utf8mb4&connectionCollation=utf8mb4_bin\n    driverClassName: com.mysql.jdbc.Driver\n    username: root\n    password: root\n    connectionTimeout: 30000\n    idleTimeout: 60000\n    maxLifetime: 180000\n    maxPoolSize: 2\n    minPoolSize: 1\n    maintenanceIntervalMilliseconds: 30000\n    readOnly: false\n",
      "sourceRule": "tables:\n t_order_item:\n    actualDataNodes: ds_0.t_order_item\n t_order:\n    actualDataNodes: ds_0.t_order\n t_dt:\n    actualDataNodes: ds_0.t_dt",
      "destinationDataSources": {
         "name": "dt_1",
         "password": "root",
         "url": "jdbc:mysql://127.0.0.1:13308/sharding_db?serverTimezone=UTC&useSSL=false&characterEncoding=UTF-8",
         "username": "root"
      }
   },
   "jobConfiguration": {
      "concurrency": 1
   }
}'
```

*如果重复创建迁移任务，分片表中的数据不会重复，应是迁移程序在做迁移前，清空了分片表*

* 查看job列表
`
  curl -X GET \
  http://localhost:8888/shardingscaling/job/list
`
* 查看job进度
`
  curl -X GET \
  http://localhost:8888/shardingscaling/job/progress/1
`，estimatedRows, estimatedRows字段不会统计新增的同步数据量
  
* 停止job
`
  curl -X POST \
  http://localhost:8888/shardingscaling/job/stop \
  -H 'content-type: application/json' \
  -d '{
   "jobId":1 }'
`
  
### 特别说明
* scaling重启，历史任务消失
* scaling任务，会同步复制delete语句，即源端删数，目标端也会删除，不会同步truncate
* jdbc url，需指定字符集，否则中文字符显示异常

# 压力测试
## 测试目标
测试proxy较单机mysql提升的效果收益。
## 测试概要
使用sysbench工具进行测试，首先进行mysql单机测试，再进行proxy测试。
## 测试环境
| IP地址 | 用途 | 
| :----:| :----: |
| 88.88.16.112 | proxy backend mysql, sysbench压力机|
| 88.88.16.113 | proxy backend mysql | 
| 88.88.16.126 | shardingsphere proxy|
## 测试步骤
### 准备测试环境
sysbench prepare动作，会自动创建测试表，但是4.1.1 proxy不支持ddl，故在每个actual node手动创建物理表。
1. 创建测试表
```sql
mysql> show create table sbtest1;
+---------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table   | Create Table                                                                                                                                                                                                                                 |
+---------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| sbtest1 | CREATE TABLE `sbtest1` (
  `id` int(11) NOT NULL,
  `k` int(11) NOT NULL DEFAULT '0',
  `c` char(120) NOT NULL DEFAULT '',
  `pad` char(60) NOT NULL DEFAULT '',
  KEY `k_1` (`k`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+---------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

```
2. 编辑oltp_common.lua脚本  
注释其中建表部分，大致位置为198行，关键字`con:query(query)`，使用`--`进行注释。  
   
3. 通过proxy灌入测试数据  
`sysbench oltp_read_write.lua --threads=4 --mysql-host=88.88.16.126 --mysql-user=root --mysql-password=root --mysql-port=13308 --mysql-db=sharding_db --tables=1 --table-size=4000000 prepare`

### 执行测试
#### proxy测试
第一次测试, 4个线程， 90S时长  
`sysbench oltp_read_write.lua --mysql-host=88.88.16.126 --mysql-user=root --mysql-password=root --mysql-port=13308 --mysql-db=sharding_db --tables=1 --table-size=4000000 --report-interval=1 --threads=4 --time=60 run`

#### 单机mysql测试
`sysbench oltp_read_write.lua --mysql-host=88.88.16.113 --mysql-user=root --mysql-password=root --mysql-port=3306 --mysql-db=demo_ds_1 --tables=1 --table-size=4000000 --report-interval=1 --threads=4 --time=60 run`

#### proxy测试（mysql in docker）
第一次测试, 40个线程， 60S时长  
`sysbench oltp_read_write.lua --mysql-host=88.88.16.192 --mysql-user=root --mysql-password=root \
--mysql-port=13308 --mysql-db=sharding_db --tables=1 --table-size=4000000 --report-interval=1 \
--threads=100 --time=60 run`

#### 单机mysql测试（mysql in docker）
`sysbench oltp_read_write.lua --mysql-host=88.88.16.113 --mysql-user=root --mysql-password=root \
--mysql-port=3307 --mysql-db=demo_ds_0 --tables=1 --table-size=4000000 --report-interval=1 --threads=100 \
--time=60 run`
## 测试结论