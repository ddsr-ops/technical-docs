动态分区裁剪适用条件
并不是什么查询都会启用动态裁剪优化的，必须满足以下几个条件：

* spark.sql.optimizer.dynamicPartitionPruning.enabled 参数必须设置为 true，不过这个值默认就是启用的；
* 需要裁减的表必须是分区表，而且分区字段必须在 join 的 on 条件里面；
* Join 类型必须是 INNER, LEFT SEMI （左表是分区表）, LEFT OUTER （右表是分区表）, or RIGHT OUTER （左表是分区表）。
* 满足上面的条件也不一定会触发动态分区裁减，还必须满足 spark.sql.optimizer.dynamicPartitionPruning.useStats 和 spark.sql.optimizer.dynamicPartitionPruning.fallbackFilterRatio 两个参数综合评估出一个进行动态分区裁减是否有益的值，满足了才会进行动态分区裁减。

> 评估函数实现请参见 org.apache.spark.sql.dynamicpruning.PartitionPruning#pruningHasBenefit

[参考](https://bbs.huaweicloud.com/blogs/236451)