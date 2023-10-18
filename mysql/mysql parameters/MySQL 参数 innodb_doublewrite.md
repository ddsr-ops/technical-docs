### innodb_doublewrite

* Variable Scope: Global
* Dynamic Variable: NO
* Type: boolean , Default Value: ON

> Enabling this feature does not require the much expensive cost, recommend to enable the feature. 

When enabled (the default), InnoDB stores all data twice, first to the doublewrite buffer, then to the actual data files. This variable can be turned off with --skip-innodb_doublewrite for benchmarks or cases when top performance is needed rather than concern for data integrity or possible failures.

If system tablespace data files (ibdata* files) are located on Fusion-io devices that support atomic writes, doublewrite buffering is automatically disabled and Fusion-io atomic writes are used for all data files. Because the doublewrite buffer setting is global, doublewrite buffering is also disabled for data files residing on non-Fusion-io hardware. This feature is only supported on Fusion-io hardware and only enabled for Fusion-io NVMFS on Linux. To take full advantage of this feature, an innodb_flush_method setting of O_DIRECT is recommended.


The innodb_doublewrite variable in MySQL is a configuration option specific to the InnoDB storage engine. It controls whether InnoDB uses doublewrite buffering for write operations to improve data consistency and reduce the risk of data corruption.

When innodb_doublewrite is enabled (set to the default value of ON), InnoDB uses a technique called doublewrite buffering. Before modifying a page in the InnoDB buffer pool, InnoDB first writes the changes to a separate area of the disk called the doublewrite buffer. After the write is confirmed, the changes are then applied to the actual data page. This process helps ensure that the data is written correctly and reduces the possibility of incomplete writes or data corruption.

Enabling innodb_doublewrite provides an additional level of data integrity at the expense of some performance overhead due to the additional disk I/O required for writing to the doublewrite buffer. However, the benefits of improved data consistency are generally considered worth the performance cost.

If you want to disable innodb_doublewrite, you can set the variable to OFF. However, it is generally recommended to keep innodb_doublewrite enabled unless you have specific reasons or requirements to disable it.

To check the current value of innodb_doublewrite, you can run the following SQL command:

SHOW VARIABLES LIKE 'innodb_doublewrite';

To modify the value of innodb_doublewrite, you can use the SET command:

SET GLOBAL innodb_doublewrite = OFF;