[Reference](https://docs.confluent.io/platform/current/kafka/deployment.html#network)


Running Kafka in Production
This section describes the key considerations before going to production with Confluent Platform.

#Hardware
If you¡¯ve been following the normal development path, you¡¯ve probably been playing with Apache Kafka? on your laptop or on a small cluster of machines laying around. But when it comes time to deploying Kafka to production, there are a few recommendations that you should consider. Nothing is a hard-and-fast rule; Kafka is used for a wide range of use cases and on a bewildering array of machines. But these recommendations provide a good starting point based on the experiences of Confluent with production clusters.

##Memory
Kafka relies heavily on the filesystem for storing and caching messages. All data is immediately written to a persistent log on the filesystem without necessarily flushing to disk. In effect this just means that it is transferred into the kernel¡¯s pagecache. A modern OS will happily divert all free memory to disk caching with little performance penalty when the memory is reclaimed. Furthermore, Kafka uses heap space very carefully and does not require setting heap sizes more than 6 GB. This will result in a file system cache of up to 28-30 GB on a 32 GB machine.

You need sufficient memory to buffer active readers and writers. You can do a back-of-the-envelope estimate of memory needs by assuming you want to be able to buffer for 30 seconds and compute your memory need as write_throughput * 30.

A machine with 64 GB of RAM is a decent choice, but 32 GB machines are not uncommon. Less than 32 GB tends to be counterproductive (you end up needing many, many small machines).

##CPUs
Most Kafka deployments tend to be rather light on CPU requirements. As such, the exact processor setup matters less than the other resources. Note that if SSL is enabled, the CPU requirements can be significantly higher (the exact details depend on the CPU type and JVM implementation).

You should choose a modern processor with multiple cores. Common clusters utilize 24 core machines.

If you need to choose between faster CPUs or more cores, choose more cores. The extra concurrency that multiple cores offers will far outweigh a slightly faster clock speed.

##Disks

**Note**

* Tiered Storage requires a single mount point and therefore does not support JBOD (just a bunch of disks), as described under Known Limitations. If you want to use Tiered Storage, do not use JBOD.
* Self-Balancing Clusters requires a single mount point and therefore does not support JBOD, as described under Limitations. If you want to use Self-Balancing Clusters, do not use JBOD.
You should use multiple drives to maximize throughput. Do not share the same drives used for Kafka data with application logs or other OS filesystem activity to ensure good latency. You can either combine these drives together into a single volume as a Redundant Array of Independent Disks (RAID) or format and mount each drive as its own directory. Because Kafka has replication the redundancy provided by RAID can also be provided at the application level. This choice has several tradeoffs.

If you configure multiple data directories, the broker places a new partition in the path with the least number of partitions currently stored. Each partition will be entirely in one of the data directories. If data is not well balanced among partitions, this can lead to load imbalance among disks.

RAID can potentially do better at balancing load between disks (although it doesn¡¯t always seem to) because it balances load at a lower level.

RAID 10 is recommended as the best ¡°sleep at night¡± option for most use cases. It provides improved read and write performance, data protection (ability to tolerate disk failures), and fast rebuild times.

The primary downside of RAID is that it reduces the available disk space. Another downside is the I/O cost of rebuilding the array when a disk fails. The rebuild cost applies to RAID in general, with nuances between the different versions.

Finally, you should avoid network-attached storage (NAS). NAS is often slower, displays larger latencies with a wider deviation in average latency, and is a single point of failure.

##Network
A fast and reliable network is an essential performance component in a distributed system. Low latency ensures that nodes can communicate easily, while high bandwidth helps shard movement and recovery. Modern data-center networking (1 GbE, 10 GbE) is sufficient for the vast majority of clusters.

##Filesystem
You should run Kafka on XFS or ext4.

#General Considerations
In general, medium-to-large machines are preferred for Kafka:

Avoid small machines because you don¡¯t want to manage a cluster with a thousand nodes, and the overhead of running Kafka is more apparent on such small boxes.
Avoid the large machines because they often lead to imbalanced resource usage. For example, all the memory is being used, but none of the CPU. They can also add logistical complexity if you have to run multiple nodes per machine.
##VMware optimization
Confluent and VMWare recommend enabling compression to help mitigate the performance impacts while maintaining business continuity.

**Warning**

* Disable vMotion and disk snapshotting for Confluent Platform as the features could cause a full cluster outage when used with Kafka.

#JVM
Java 8 and Java 11 are supported in this version of Confluent Platform. From a security perspective, we recommend the latest released patch version as older freely available versions have disclosed security vulnerabilities.

Java 9 and 10 are not supported.

For more information, see Java supported versions.

You need to separately install the correct version of Java before you start the Confluent Platform installation process.

The recommended GC tuning (tested on a large deployment with JDK 1.8 u5) looks like this:

-Xms6g -Xmx6g -XX:MetaspaceSize=96m -XX:+UseG1GC -XX:MaxGCPauseMillis=20
       -XX:InitiatingHeapOccupancyPercent=35 -XX:G1HeapRegionSize=16M
       -XX:MinMetaspaceFreeRatio=50 -XX:MaxMetaspaceFreeRatio=80
For reference, here are the stats on one of LinkedIn¡¯s busiest clusters (at peak):

60 brokers
50k partitions (replication factor 2)
800k messages/sec in
300 MBps inbound, 1 GBps + outbound
The tuning looks fairly aggressive, but all of the brokers in that cluster have a 90% GC pause time of about 21ms, and they¡¯re doing less than 1 young GC per second.

#Production Configuration Options
The Kafka default settings should work in most cases, especially the performance-related settings and options, but there are some logistical configurations that should be changed for production depending on your cluster layout.

**Tip**

* To learn how Kafka architecture has been greatly simplified by the introduction of Apache Kafka Raft Metadata mode (KRaft), see KRaft: Apache Kafka without ZooKeeper.
* To learn about benchmark testing and results for Kafka performance on the latest hardware in the cloud, see Apache Kafka Performance, Latency, Throughput, and Test
##General configurations
zookeeper.connect
The list of ZooKeeper hosts that the broker registers at. It is recommended that you configure this to all the hosts in your ZooKeeper cluster

Type: string
Importance: high
broker.id
Integer ID that identifies a broker. Brokers in the same Kafka cluster must not have the same ID.
Type: int
Importance: high
log.dirs
The directories in which the Kafka log data is located.

Type: string
Default: ¡°/tmp/kafka-logs¡±
Importance: high
listeners
Comma-separated list of URIs (including protocol) that the broker will listen on. Specify hostname as 0.0.0.0 to bind to all interfaces or leave it empty to bind to the default interface. An example is PLAINTEXT://myhost:9092.

Type: string
Default: PLAINTEXT://host.name:port where the default for host.name is an empty string and the default for port is 9092
Importance: high
advertised.listeners
Listeners to publish to ZooKeeper for clients to use. In IaaS environments, this may need to be different from the interface to which the broker binds. If this is not set, the value for listeners will be used.

Type: string
Default: listeners
Importance: high
num.partitions
The default number of log partitions for auto-created topics. You should increase this since it is better to over-partition a topic. Over-partitioning a topic leads to better data balancing and aids consumer parallelism. For keyed data, you should avoid changing the number of partitions in a topic.

Type: int
Default: 1
Valid Values: [1,¡­]
Importance: medium
Dynamic Update Mode: read-only
##Replication configs
default.replication.factor
The default replication factor that applies to auto-created topics. You should set this to at least 2.

Type: int
Default: 1
Importance: medium
min.insync.replicas
The minimum number of replicas in ISR needed to commit a produce request with required.acks=-1 (or all).

Type: int
Default: 1
Importance: medium
unclean.leader.election.enable
Indicates whether to enable replicas not in the ISR set to be elected as leader as a last resort, even though doing so may result in data loss.

Type: boolean
Default: false
Importance: medium
#File Descriptors and mmap
Kafka uses a very large number of files and a large number of sockets to communicate with the clients. All of this requires a relatively high number of available file descriptors.

Many modern Linux distributions ship with only 1,024 file descriptors allowed per process. This is too low for Kafka.

You should increase your file descriptor counttoat least 100,000. This process can be difficult and is highly dependent on your particular OS and distribution. Consult the documentation for your OS to determine how best to change the allowed file descriptor count.

Here are some recommendations:

To calculate the current mmap number, you can count the .index files in the Kafka data directory. The .index files represent the majority of the memory mapped files. Here is the procedure:

Count the .index files using this command:

find . -name '*index' | wc -l
Set the vm.max_map_count for the session. This will calculate the current number of memory mapped files. The minimum value for mmap limit (vm.max_map_count) is the number of open files ulimit.

Important

You should set vm.max_map_count sufficiently higher than the number of .index files to account for broker segment growth.

sysctl -w vm.max_map_count=262144
Set the vm.max_map_count so that it will survive a reboot use this command:

echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
sysctl -p
#Multi-node Configuration
In a production environment, multiple brokers are required. During startup brokers register themselves in ZooKeeper to become a member of the cluster.

Navigate to the Apache Kafka? properties file (/etc/kafka/server.properties) and customize the following:

Connect to the same ZooKeeper ensemble by setting the zookeeper.connect in all nodes to the same value. Replace all instances of localhost to the hostname or FQDN (fully qualified domain name) of your node. For example, if your hostname is zookeeper:

zookeeper.connect=zookeeper:2181
Configure the broker IDs for each node in your cluster using one of these methods.

Dynamically generate the broker IDs: add broker.id.generation.enable=true and comment out broker.id. For example:

```text
############################# Server Basics #############################

# The ID of the broker. This must be set to a unique integer for each broker.
#broker.id=0
```

broker.id.generation.enable=true
Manually set the broker IDs: set a unique value for broker.id on each node.

Configure how other brokers and clients communicate with the broker using listeners, and optionally advertised.listeners.

listeners: Comma-separated list of URIs and listener names to listen on.
advertised.listeners: Comma-separated list of URIs and listener names for other brokers and clients to use. The advertised.listeners parameter ensures that the broker advertises an address that is accessible from both local and external hosts.
For more information, see Production Configuration Options.

Configure security for your environment.

For general security guidance, see Security Overview.
For role-based access control (RBAC), see Configure Metadata Service (MDS).
For SSL encryption, SASL authentication, and authorization, see Security Tutorial.