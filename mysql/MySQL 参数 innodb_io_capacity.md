### innodb_io_capacity

* Variable Scope: Global
* Dynamic Variable: Yes
* Type: Integer, Default Value: 200, Minimum Value: 100, Maximum Value: 2**64-1

The innodb_io_capacity parameter sets an upper limit on I/O activity performed by InnoDB
background tasks, such as flushing pages from the buffer pool and merging data from the change
buffer.

*The innodb_io_capacity limit is a total limit for all buffer pool instances*. When dirty pages are
flushed, the limit is divided equally among buffer pool instances.

innodb_io_capacity should be set to approximately the number of I/O operations that the system
can perform per second. Ideally, keep the setting as low as practical, but not so low that background
activities fall behind. If the value is too high, data is removed from the buffer pool and insert buffer
too quickly for caching to provide a significant benefit.

The default value is 200. For busy systems capable of higher I/O rates, you can set a higher value
to help the server handle the background maintenance work associated with a high rate of row
changes.

In general, you can increase the value as a function of the number of drives used for InnoDB I/O.
For example, you can increase the value on systems that use multiple disks or solid-state disks
(SSD).
The default setting of 200 is generally sufficient for a lower-end SSD. For a higher-end, bus-attached
SSD, consider a higher setting such as 1000, for example. For systems with individual 5400 RPM or
7200 RPM drives, you might lower the value to 100, which represents an estimated proportion of the
I/O operations per second (IOPS) available to older-generation disk drives that can perform about
100 IOPS.

```
# 根据服务器IOPS能力适当调整
# 一般配普通SSD盘的话，可以调整到 10000 - 20000
# 配置高端PCIe SSD卡的话，则可以调整的更高，比如 50000 - 80000
# 普通磁盘可往下降低
innodb_io_capacity = 4000
innodb_io_capacity_max = 8000
```

Although you can specify a very high value such as one million, in practice such large values have
little if any benefit. Generally, a value of 20000 or higher is not recommended unless you have
proven that lower values are insufficient for your workload.
Consider write workload when tuning innodb_io_capacity. Systems with large write workloads
are likely to benefit from a higher setting. A lower setting may be sufficient for systems with a small
write workload.
You can set innodb_io_capacity to any number 100 or greater to a maximum defined by
**innodb_io_capacity_max**. innodb_io_capacity can be set in the MySQL option file (my.cnf
or my.ini) or changed dynamically using a SET GLOBAL statement, which requires the SUPER
privilege.

The innodb_flush_sync configuration option causes the innodb_io_capacity setting to be
ignored during bursts of I/O activity that occur at checkpoints. innodb_flush_sync is enabled by
default.
See Section 15.6.8, “Configuring the InnoDB Master Thread I/O Rate” for more information. For
general information about InnoDB I/O performance, see Section 9.5.8, “Optimizing InnoDB Disk I/O”.