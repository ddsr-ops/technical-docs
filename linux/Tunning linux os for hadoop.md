# References
* [OS Configurations for Better Hadoop Performance](https://community.cloudera.com/t5/Community-Articles/OS-Configurations-for-Better-Hadoop-Performance/ta-p/247300)
* [swap size howrtonworks recommendation in hadoop clusters](https://community.cloudera.com/t5/Support-Questions/swap-size-howrtonworks-recommendation-in-hadoop-clusters/td-p/182102)
* [Swappiness setting recommendation](https://community.cloudera.com/t5/Community-Articles/Swappiness-setting-recommendation/ta-p/246165)
* [What is the Hortonworks recommendation on Swap usage?](https://community.cloudera.com/t5/Support-Questions/What-is-the-Hortonworks-recommendation-on-Swap-usage/m-p/123717)
* [HDFS Settings for Better Hadoop Performance](https://community.cloudera.com/t5/Community-Articles/HDFS-Settings-for-Better-Hadoop-Performance/ta-p/245799)
* [Best Practices: Linux File Systems for HDFS](https://community.cloudera.com/t5/Community-Articles/Best-Practices-Linux-File-Systems-for-HDFS/ta-p/245284)

# Tuning items

## Disable Transparent Huge Pages (THP)
Transparent Huge Pages (THP) is a Linux memory management system that reduces the overhead of Translation Lookaside Buffer (TLB) 
lookups on machines with large amounts of memory by using larger memory pages.

However THP feature is known to perform poorly in Hadoop cluster and results in excessively high CPU utilization.

Disable THP to reduce the amount of system CPU utilization on your worker nodes.  
This can be done by ensuring that both proc entries are set to [never] instead of [always].

When system is running, Disabling actions can be done. 
```shell
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
```
Note: show thp status via `cat /sys/kernel/mm/transparent_hugepage/enabled; cat /sys/kernel/mm/transparent_hugepage/defrag`

After that, ensure it takes effect when system restarting.
```shell
chmod +x /etc/rc.d/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.d/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.d/rc.local
```

## Use Recommended File System Types
Some file systems offer better performance and stability than others. As such, the HDFS dfs.datanode.data.dir 
and YARN yarn.nodemanager.local-dirs should be configured to use mount points that are not formatted with the most optimal file systems.

Take a look at this article on file system choices: https://community.hortonworks.com/articles/14508/best-practices-linux-file-systems-for-hdfs.html

EXT4 file system is a good choice.

## Disable Host Swappiness
The Linux kernel provides a tweakable setting that controls how often the swap file is used, called swappiness.

A swappiness setting of zero means that the disk will be avoided unless absolutely necessary (when host runs out of memory), 
while a swappiness setting of 100 means that programs will be swapped to disk almost instantly.

Reducing the value for swappiness reduces the likelihood that the Linux kernel will push application memory from memory into swap space. 
Swap space is much slower than memory as it is backed by disk instead of RAM. Processes that are swapped to disk are likely to 
experience pauses, which may cause issues and missed SLAs.

Add `vm.swappiness=0` to /etc/sysctl.conf and reboot for the change to take effect. 

Or you can also change the value while your system is still running `sysctl -w vm.swappiness=0`. 

Also clear your swap by running `swapoff -a` and then `swapon -a` as root instead of rebooting to achieve the same effect.
## Improve Virtual Memory Usage
The vm.dirty_background_ratio and vm.dirty_ratio parameters control the percentage of system memory that can be filled with memory pages that still need to be written to disk. Ratios too small force frequent IO operations, and too large leave too much data stored in volatile memory, so optimizing this ration is a careful balance between optimizing IO operations and reducing risk of data loss.

Update vm.dirty_background_ratio=20 and vm.dirty_ratio=50 in /etc/sysctl.conf and reboot for the change to take effect, or change the values while your system is still running using `sysctl -p`.

## Configure CPUs for Performance Scaling
CPU Scaling is configurable and defaults commonly to favor power saving over performance. 
For Hadoop clusters, it is important that we configure then for better performance over other options.

Please set scaling governors to performance, which means running the CPU at maximum frequency.  
To do so run `cpufreq-set -r -g performance` OR edit /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 
and set the content to 'performance'

## Tune SSD Configurations
SSDs provide great performance boost. If configured optimally for Hadoop workloads, they can provide even better results. Scheduler, read buffers, number of requests etc are the parameters to consider for tuning.

Refer following link for further details: https://wiki.archlinux.org/index.php/Solid_State_Drives#I.2FO_Scheduler

For all of SSD devices, set following things 
```shell
echo 'deadline' > {{device}}/queue/scheduler ;
echo '256' > {{device}}/queue/read_ahead_kb ;
echo '256' > {{device}}/queue/nr_requests ; 
```
*** You might also be interested in the following articles: ***

HDFS Settings for Better Hadoop Performance