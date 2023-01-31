**问题**：  
当在使用sharding proxy时，发现其为中心化产品，并且无自带HA方案，具体可参考[issue](https://github.com/apache/shardingsphere/issues/3085)

**解决**：  
需额外增加负载均衡和高可用方案，如LVS+keepalived  

* * * 
**建议**：  
* 建议使用sharding-jdbc，在程序侧实现分片配置，由程序分布式实现高可用保证
* 再者，为运营查数方便需要，可单独部署sharding-proxy，供DBA查询
* 如有集中式交互式查询需求，则单独构建OLAP数据库，如doris