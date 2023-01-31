# 目标
升级kafka connector集群的oracle插件包。  

# 准备
下载或编译oracle插件包。

# 升级
以下操作，无特别说明，都在同一kafka connector节点执行。

**NOTE：以下操作用于滚动重启，connector cdc在分布式部署模式下，并不会中断。**  
*如果需要完全停止connector task任务及集群，参考《debezium完全停机升级.md》*

## 备份
```shell
tar -czf oracle-plugin.tgz /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/
```
## 替换jar包
```shell
# 停止该节点的connector服务
jps -l |grep ConnectDistributed|awk '{print $1}'|xargs kill -9 

# 查看进程是否完全停止
jps -l |grep ConnectDistributed

# 将jar解压后替换
tar -zxf /tmp/oracle-jar.tgz -C /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/
cd /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/ && mv oracle-jar/* .

# 删除冲突的jar包，此为Alpha1的包
rm -f *Alpha1*

# 恢复该节点connector服务
cd /opt/kafka_2.12-2.7.0/ && bin/connect-distributed.sh -daemon config/connect-distributed.properties && tailf logs/connect.log
```

## 升级其他connector节点
在集群其他节点，操作备份、替换jar包动作。

# 回退
如需回退，将备份的jar包恢复，启动connector服务。

# 检查
滚动升级后，不仅需检查日志，还需检查kafka topic中，是否正常流入数据。