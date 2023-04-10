MySQL Connector：存在元数据进化时， 如果更改对应connect—offset位置， 可能导致无法识别表的schema，
报错'Encountered change event for table XXX whose schema isn't known to this connector'
 
使用MySQL Connector抽取指定日志指定区间的日志， 实现中将previousOffset置为空，就是为了避免报上述错误。
具体可以参考MySqlConnectorTask类的io.debezium.connector.mysql.MySqlConnectorTask#start方法。

如果MySQL CDC确实发生了中断， 分为两种情况，源数据库可恢复和不可恢复。 无论是那种情况，从保障服务可用性的角度， 服务会立即切换到备库。
此时， 有两种方式值得尝试恢复CDC链路：
1. 基于备库（新主）， 新建一条CDC链路（Connector名称不同， schema_only模式）通过CDC transform功能转换数据到原的kafka topic；
   确定缺失日志区间，另起CDC链路仅获取缺失日志，通过CDC transform功能， 将缺失日志灌入原的kafka topic，
   缺点：如果没有数据版本管理，数据过程不一致，最终一致，配置复杂，优点：时效性有保证
2. 基于备库（新主）， 新建一条CDC链路（Connector名称不同， initial模式）通过CDC transform功能转换数据到原的kafka topic
   缺点：时效性无法保证，取决于快照数据量；优点：数据一致性得以保证，配置简单