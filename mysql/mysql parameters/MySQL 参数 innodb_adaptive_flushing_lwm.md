### innodb_adaptive_flushing_lwm

* Variable Scope: Global
* Dynamic Variable: Yes
* Default Value: 10, Minimum Value: 0, Maximum Value: 70

Defines the low water mark representing percentage of redo log capacity at which adaptive flushing is enabled.

The innodb_adaptive_flushing_lwm is a configuration parameter in MySQL InnoDB that stands for "InnoDB Adaptive Flushing Low Water Mark." It represents the threshold at which the InnoDB buffer pool starts flushing dirty pages to disk more aggressively.

When the number of dirty pages (modified but not yet written to disk) in the InnoDB buffer pool exceeds the low water mark set by innodb_adaptive_flushing_lwm, InnoDB increases the flushing rate to reduce the number of dirty pages and maintain a balance between write performance and data durability.

By default, the value of innodb_adaptive_flushing_lwm is set to 10% of the total size of the InnoDB buffer pool (innodb_buffer_pool_size). However, you can adjust this value to fine-tune the flushing behavior based on your workload and performance requirements.

Setting a higher value for innodb_adaptive_flushing_lwm can delay flushing and prioritize write performance, which may be beneficial for write-intensive workloads. On the other hand, a lower value can increase the flushing rate, ensuring more frequent writes to disk and improving data durability at the cost of some write performance.

It's worth noting that modifying the innodb_adaptive_flushing_lwm value should be done carefully and in conjunction with other InnoDB configuration parameters to achieve the desired balance between performance and durability.