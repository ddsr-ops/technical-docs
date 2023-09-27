# Symptom

```
2023-09-20T08:23:13.524999+08:00 0 [Note] InnoDB: page_cleaner: 1000ms intended loop took 10548ms. The settings might not be optimal. (flushed=344 and evicted=0, during the time.)
```

Running INSERT statements is slow occasionally, and only one insert statement spent about 7 seconds to be finished. This case doesn't appear all the time, but occasionally about several times one day. In addition to earlier, the architecture of MySQL server is that two MySQL servers replicate from each other (master-master) based on traditional replication, neither semi-replication nor group replication.


# Recommended Actions

## innodb_page_cleaners

The number of page cleaner threads(innodb_page_cleaners) that flush dirty pages from buffer pool instances. Page
cleaner threads perform flush list and LRU flushing. A single page cleaner thread was introduced
in MySQL 5.6 to offload buffer pool flushing work from the InnoDB master thread. In MySQL
5.7, InnoDB provides support for multiple page cleaner threads. A value of 1 maintains the
pre-MySQL 5.7 configuration in which there is a single page cleaner thread. When there are
multiple page cleaner threads, buffer pool flushing tasks for each buffer pool instance are
dispatched to idle page cleaner threads. The innodb_page_cleaners default value was
changed from 1 to 4 in MySQL 5.7. If the number of page cleaner threads exceeds the number
of buffer pool instances, innodb_page_cleaners is automatically set to the same value as
innodb_buffer_pool_instances.

> **innodb_buffer_pool_instances**
> 
> The number of regions that the InnoDB buffer pool is divided into. For systems with buffer pools in
the multi-gigabyte range, dividing the buffer pool into separate instances can improve concurrency,
by reducing contention as different threads read and write to cached pages. Each page that is stored
in or read from the buffer pool is assigned to one of the buffer pool instances randomly, using a
hashing function. Each buffer pool manages its own free lists, flush lists, LRUs, and all other data
structures connected to a buffer pool, and is protected by its own buffer pool mutex.
This option only takes effect when setting innodb_buffer_pool_size to 1GB or more. The total
buffer pool size is divided among all the buffer pools. For best efficiency, specify a combination of
innodb_buffer_pool_instances and innodb_buffer_pool_size so that each buffer pool
instance is at least 1GB.

If your workload is write-IO bound when flushing dirty pages from buffer pool instances to data files,
and if your system hardware has available capacity, increasing the number of page cleaner threads
may help improve write-IO throughput.

Multi-threaded page cleaner support is extended to shutdown and recovery phases in MySQL 5.7.

Here are the steps you can follow to adjust the parameter:

Open the MySQL configuration file (my.cnf or my.ini).

Locate the innodb_page_cleaners parameter. If it is not present, you can add it under the [mysqld] section.

Adjust the value of innodb_page_cleaners to a higher number. The default value is typically 4 in MySQL 5.7.8 and later version.
You can try increasing it to higher, depending on your system resources.

## innodb_flush_neighbors

Specifies whether flushing a page from the InnoDB buffer pool also flushes other dirty pages in the
same extent.
*  The default value of 1 flushes contiguous dirty pages in the same extent from the buffer pool. (HDD)
*  A setting of 0 turns innodb_flush_neighbors off and no other dirty pages are flushed from the
buffer pool. (SSD)
*  A setting of 2 flushes dirty pages in the same extent from the buffer pool.

When the table data is stored on a traditional HDD storage device, flushing such neighbor pages
in one operation reduces I/O overhead (primarily for disk seek operations) compared to flushing
individual pages at different times. For table data stored on SSD, seek time is not a significant
factor and you can turn this setting off to spread out write operations.

## innodb_lru_scan_depth

The default value is 1024, minimum value is 100.

A parameter that influences the algorithms and heuristics for the flush operation for the InnoDB
buffer pool. Primarily of interest to performance experts tuning I/O-intensive workloads. It specifies,
per buffer pool instance, how far down the buffer pool LRU list the page cleaner thread scans looking
for dirty pages to flush. This is a background operation performed once per second.

A setting smaller than the default is generally suitable for most workloads. A value that is much
higher than necessary may impact performance. Only consider increasing the value if you have
spare I/O capacity under a typical workload. Conversely, if a write-intensive workload saturates your
I/O capacity, decrease the value, especially in the case of a large buffer pool.

When tuning innodb_lru_scan_depth, start with a low value and configure the setting upward
with the goal of rarely seeing zero free pages. Also, consider adjusting innodb_lru_scan_depth
when changing the number of buffer pool instances, since `innodb_lru_scan_depth *
innodb_buffer_pool_instances` defines the amount of work performed by the page cleaner
thread each second.


# 15.6.3.7 Fine-tuning InnoDB Buffer Pool Flushing

The content of this section are from MySQL official documents, which describes how to finely tune the Innodb flushing. If you want to read the relevant contents, please refer to the official document of MySQL.

The configuration options *innodb_flush_neighbors* and *innodb_lru_scan_depth* let you
fine-tune certain aspects of the flushing process for the InnoDB buffer pool. These options primarily
help write-intensive workloads. With heavy DML activity, flushing can fall behind if it is not aggressive
enough, resulting in excessive memory use in the buffer pool; or, disk writes due to flushing can
saturate your I/O capacity if that mechanism is too aggressive. The ideal settings depend on your
workload, data access patterns, and storage configuration (for example, whether data is stored on HDD(innodb_flush_neighbors=1)
or SSD devices(innodb_flush_neighbors = 0)).

For systems with constant heavy workloads, or workloads that fluctuate widely, several configuration
options let you fine-tune the flushing behavior for InnoDB tables:
* innodb_adaptive_flushing_lwm
* innodb_max_dirty_pages_pct_lwm
* innodb_io_capacity_max
* innodb_flushing_avg_loops

These options feed into the formula used by the innodb_adaptive_flushing option.
The innodb_adaptive_flushing, innodb_io_capacity and innodb_max_dirty_pages_pct
options are limited or extended by the following options:
• innodb_adaptive_flushing_lwm
• innodb_io_capacity_max
• innodb_max_dirty_pages_pct_lwm
The InnoDB adaptive flushing mechanism is not appropriate in all cases. It gives the most benefit
when the redo log is in danger of filling up. The innodb_adaptive_flushing_lwm option specifies
a “low water mark” percentage of redo log capacity; when that threshold is crossed, InnoDB turns on
adaptive flushing even if not specified by the innodb_adaptive_flushing option.
If flushing activity falls far behind, InnoDB can flush more aggressively than specified by
innodb_io_capacity. innodb_io_capacity_max represents an upper limit on the I/O capacity
used in such emergency situations, so that the spike in I/O does not consume all the capacity of the
server.
InnoDB tries to flush data from the buffer pool so that the percentage of dirty pages
does not exceed the value of innodb_max_dirty_pages_pct. The default value for
innodb_max_dirty_pages_pct is 75.
Note
The innodb_max_dirty_pages_pct setting establishes a target for flushing
activity. It does not affect the rate of flushing. For information about managing
the rate of flushing, see Section 15.6.3.6, “Configuring InnoDB Buffer Pool
Flushing”.
The innodb_max_dirty_pages_pct_lwm option specifies a “low water mark” value that represents
the percentage of dirty pages where pre-flushing is enabled to control the dirty page ratio and ideally
prevent the percentage of dirty pages from reaching innodb_max_dirty_pages_pct. A value of
innodb_max_dirty_pages_pct_lwm=0 disables the “pre-flushing” behavior.
Most of the options referenced above are most applicable to servers that run write-heavy workloads for
long periods of time and have little reduced load time to catch up with changes waiting to be written to
disk.
2199
InnoDB Buffer Pool Configuration
innodb_flushing_avg_loops defines the number of iterations for which InnoDB keeps the
previously calculated snapshot of the flushing state, which controls how quickly adaptive flushing
responds to foreground load changes. Setting a high value for innodb_flushing_avg_loops
means that InnoDB keeps the previously calculated snapshot longer, so adaptive flushing
responds more slowly. A high value also reduces positive feedback between foreground and
background work, but when setting a high value it is important to ensure that InnoDB redo log
utilization does not reach 75% (the hardcoded limit at which async flushing starts) and that the
innodb_max_dirty_pages_pct setting keeps the number of dirty pages to a level that is
appropriate for the workload.
Systems with consistent workloads, a large innodb_log_file_size, and small spikes that do not
reach 75% redo log space utilization should use a high innodb_flushing_avg_loops value to keep
flushing as smooth as possible. For systems with extreme load spikes or log files that do not provide
a lot of space, consider a smaller innodb_flushing_avg_loops value. A smaller value allows
flushing to closely track the load and helps avoid reaching 75% redo log space utilization.