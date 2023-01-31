Java垃圾回收器用的比较多的CMS，G1,为什么选用G1垃圾回收器呢。在多处理器和大容量内存环境中，在实现高吞吐量的同时，尽可能的满足垃圾收集暂停时间的要求。官方的描述：

The Garbage-First (G1) collector is a server-style garbage collector, targeted for multi-processor machines with large memories. It meets garbage collection (GC) pause time goals with a high probability, while achieving high throughput. The G1 garbage collector is fully supported in Oracle JDK 7 update 4 and later releases. The G1 collector is designed for applications that:

* Can operate concurrently with applications threads like the CMS collector.

* Compact free space without lengthy GC induced pause times.

* Need more predictable GC pause durations.

* Do not want to sacrifice a lot of throughput performance.

* Do not require a much larger Java heap.

翻译过来大致这样:

像CMS收集器一样，能与应用程序线程并发执行。

整理空闲空间更快。

需要GC停顿时间更好预测。

不希望牺牲大量的吞吐性能。

不需要更大的Java Heap。

项目在压测5000个机器人的时候堆栈占用大概是5G，所以java的总堆栈设置成20G。不合理的GC参数会导致STW较长时间和比较频繁，所以对GC进行调优处理。以下是一些调优细节：

**-XX:G1HeapRegionSize=n**

设置的 G1 区域的大小。值是 2 的幂，范围是 1 MB 到 32 MB 之间。目标是根据最小的 Java 堆大小划分出约 2048 个区域。目前的游戏项目22G内存，所以这个值设定成16。也就是一个内存区域16M，22G大概分成了1408个区域。

-XX:MaxGCPauseMillis=200

为所需的最长暂停时间设置目标值。默认值是 200 毫秒。这个数值是一个软目标，也就是说JVM会尽一切能力满足这个暂停要求，但是不能保证每次暂停一定在这个要求之内。根据测试发现，如果我们将这个值设定成50毫秒或者更低的话，JVM为了达到这个要求会将年轻代内存空间设定的非常小，从而导致youngGC的频率大大增高。所以我们并不设定这个参数。

**-XX:InitiatingHeapOccupancyPercent=45**

设置触发标记周期的 Java 堆占用率阈值。默认占用率是整个 Java 堆的 45%。就是说当使用内存占到堆总大小的45%的时候，G1将开始并发标记阶段。为混合GC做准备，这个数值在测试的时候我想让混合GC晚一些处理所以设定成了70%，经过观察发现如果这个数值设定过大会导致JVM无法启动并发标记，直接进行FullGC处理。G1的FullGC是单线程，一个22G的对GC完成需要8S的时间，所以这个值在调优的时候写的45%

-Xmn

官方文档说使用G1回收器的时候不要指定年轻代大小，使用MaxGCPauseMillis参数让JVM自行决定大小，之前也说过了如果MaxGCPauseMillis时间过小的话会带来younggc频率高，所以这个参数在调优的时候设定成4g

**-XX:ReservedCodeCacheSize=256m**

这个参数特别容易忽略，这个参数JDK8默认是48M，含义是当JIT运行过程中将JAVA代码进行底层代码编译，让程序从解释运行模式变成性能更高的编译运行模式，这个cache就是用来保存编译后代码的内存，之前出现了程序压测30小时之后CPU100%的问题，经过排查就是因为这个cache满了造成优化被关闭。Jvm日志里面会有输出：CodeCache is full. Compiler has been disabled。
G1垃圾回收器的参数配置如下：

JDK7环境

```-Xms22g -Xmx22g -Xmn4g -XX:+UseG1GC -XX:G1HeapRegionSize=16m -XX:InitiatingHeapOccupancyPercent=45 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:PermSize=256M -XX:MaxPermSize=256M -XX:MaxDirectMemorySize=512m```

如果在JDK8的环境下，需要如下配置

```-Xms22g -Xmx22g -Xmn4g -XX:+UseG1GC -XX:-TieredCompilation -XX:G1HeapRegionSize=16m -XX:InitiatingHeapOccupancyPercent=45 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:-UseCompressedClassPointers -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m -XX:ReservedCodeCacheSize=256m -XX:+UseCodeCacheFlushing -XX：ParallelGCThreads= 16 -XX：ConcGCThreads= 16```

测试过程中每次GC间隔3-5秒，GC停顿30-150毫秒，测试2小时未初选FullGc，混合GC大概在内存45%的时候触发，经过5-7次150毫秒所有的GC回收老年代内存。GC表现不错.