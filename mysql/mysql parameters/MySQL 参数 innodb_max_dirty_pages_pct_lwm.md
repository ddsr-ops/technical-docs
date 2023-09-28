### innodb_max_dirty_pages_pct_lwm

* Variable Scope: Global
* Dynamic Variable: Yes
* Type: numeric , Default Value: 0, Minimum Value: 0, Maximum: 99.99

Defines a low water mark representing the percentage of dirty pages at which <u>preflushing</u> is enabled
to control the dirty page ratio. The default of 0 disables the pre-flushing behavior entirely.

The innodb_max_dirty_pages_pct_lwm is a MySQL variable that stands for "InnoDB Maximum Dirty Pages Low Water Mark Percentage." It represents the low water mark threshold for the percentage of dirty pages in the InnoDB buffer pool.

Dirty pages in the buffer pool are modified data pages that have not yet been written to disk. The **innodb_max_dirty_pages_pct_lwm** variable specifies the target percentage of dirty pages at which *pre-flushing* is enabled to control the dirty page ratio and ideally prevent the percentage of dirty pages from reaching the maximum threshold defined by **innodb_max_dirty_pages_pct**.

When the percentage of dirty pages exceeds the value set in innodb_max_dirty_pages_pct_lwm, InnoDB initiates pre-flushing to reduce the number of dirty pages and maintain a balance between write performance and data durability. Pre-flushing involves writing dirty pages to disk in the background to ensure a reasonable number of dirty pages are available for write operations.

By default, the value of innodb_max_dirty_pages_pct_lwm is set to 0, which disables the pre-flushing behavior. However, you can modify this value to specify a different low water mark percentage based on your workload and performance requirements.

A higher value for innodb_max_dirty_pages_pct_lwm means that pre-flushing will be triggered when a larger percentage of dirty pages is reached, potentially prioritizing write performance over durability. Conversely, a lower value will initiate pre-flushing at a smaller percentage of dirty pages, ensuring more frequent writes to disk and improving data durability at the cost of some write performance.
