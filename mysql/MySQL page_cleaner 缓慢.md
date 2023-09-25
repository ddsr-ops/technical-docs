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
*  The default value of 1 flushes contiguous dirty pages in the same extent from the buffer pool.
*  A setting of 0 turns innodb_flush_neighbors off and no other dirty pages are flushed from the
buffer pool.
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