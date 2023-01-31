# 目标

本文记录常用的Debezium维护笔记。

# 跳过无法处理的DML

## 症状表现
```
...
Caused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed
...
```

一般发生在源库不正确地执行与Connector配置中相关表的DDL语句，导致Logminer无最新字典无法识别日志中的字段。

通常来说，发生此类情况，Connector无法自愈，需重建或修复Connector History topic并跳过这部分日志。

1. 从Git仓库拉取最新的Debezium Connector配置
2. 执行connector的删除：`curl -X DELETE http://10.50.253.6:8085/connectors/oracle_tftfxq`
3. 重置对应connector的offset位置：`select current_scn from v$database; `276598572096；
   修改脚本/opt/kafka_2.12-2.7.0_1/connector-json/debezium-util.sh中的connector名称与`scn`（276598572096）
   执行脚本`bash debezium-util.sh`, 将数据投递至connector-offset topic中
4. 从History topic获取较新的Schema DDL message信息
   Query history topic data , you can use KSQL of kafka-eagle(path : messages - topic - ksql).
   For example, `select * from oracle_tsm_his where `partition` in (0) and `msg` like '%T_ACT_TRADE_DETAIL%'`
5. 将上述获取到的数据中SCN、COMMITTED_SCN，修改为略小于276598572096后，将数据投递至history topic
   Here, we send messages to history topic(such as oracle_ups_his) via kafka-eagle. 
   Enter the web ui , http://namenode2:8049/topic/mock, path : MESSAGES -- TOPICS -- MOCK
6. 新建并启动connector, `curl -Ss -X POST http://namenode2:8084/connectors/connector_name/tasks/0/restart`
7. 验证connector启动成功，查看日志`tailf /opt/kafka_2.12-2.7.0_1/logs/connect.log`
   ```For connector oracle_tftfxq, Oracle Session UGA 2.97MB (max = 3.15MB), PGA 155.32MB (max = 235.45MB)```
   注意：N1、N2的日志路径为/opt/kafka_2.12-2.7.0_1/logs/connect.log, D1-D5的日志路径为/opt/kafka_2.12-2.7.0/logs/connect.log
   
TODO: 补数和修复受影响作业

Note：如何正确实施DDL，请参考文档《oracle cdc table structure evolution.sql》