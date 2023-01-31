说明
在 redhat 4/5/6/7版本中的NOOP调度策略，从8开始修改为NONE，官方解释：

* none

Implements a first-in first-out (FIFO) scheduling algorithm. 
It merges requests at the generic block layer through a simple last-hit cache.

* mq-deadline

Attempts to provide a guaranteed latency for requests from the point 
at which requests reach the scheduler.

The mq-deadline scheduler sorts queued I/O requests into a read or write batch and then schedules them for execution in increasing logical block addressing (LBA) order. 
By default, read batches take precedence over write batches, 
because applications are more likely to block on read I/O operations. 
After mq-deadline processes a batch, it checks how long write operations have been starved of processor time and schedules the next read or write batch as appropriate.

This scheduler is suitable for most use cases, 
but particularly those in which the write operations are mostly asynchronous.

* bfq

Targets desktop systems and interactive tasks.

The bfq scheduler ensures that a single application is never using all of the bandwidth. In effect, the storage device is always as responsive as if it was idle. In its default configuration, bfq focuses on delivering the lowest latency rather than achieving the maximum throughput.

bfq is based on cfq code. It does not grant the disk to each process for a fixed time slice but assigns a budget measured in number of sectors to the process.

This scheduler is suitable while copying large files and the system does not become unresponsive in this case.

* kyber

The scheduler tunes itself to achieve a latency goal by calculating the latencies of every I/O request submitted to the block I/O layer. You can configure the target latencies for read, in the case of cache-misses, and synchronous write requests.

This scheduler is suitable for fast devices, for example NVMe, SSD, or other low latency devices.

官方文档链接: [网址](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/monitoring_and_managing_system_status_and_performance/setting-the-disk-scheduler_monitoring-and-managing-system-status-and-performance)

# 修改方法

临时
```$ echo 'none' > /sys/block/sda/queue/scheduler
$ cat           /sys/block/sda/queue/scheduler
[none] mq-deadline kyber bfq
``` 

永久
```
修改策略，如改为none
mkdir /etc/tuned/ssdlinux
vi /etc/tuned/ssdlinux/tuned.conf
写入以下内容：
[disk]
elevator=none
触发生效
tuned-adm profile ssdlinux
```

如果要指定磁盘策略，可通过以下参数devices_udev_regex
```
[disk]
devices_udev_regex=IDNAME=device system unique id
elevator=selected-scheduler
```

# 使用场景
|Use case|	                    Disk scheduler|
| :----: | :----: |
|Traditional HDD with a SCSI interface	|Use mq-deadline or bfq.|
|High-performance SSD or a CPU-bound system with fast storage	|Use none, especially when running enterprise applications. Alternatively, use kyber.|
|Desktop or interactive tasks	|Use bfq.|
|Virtual guest	Use mq-deadline. With a host bus adapter (HBA) driver that is multi-queue capable, |use none.|