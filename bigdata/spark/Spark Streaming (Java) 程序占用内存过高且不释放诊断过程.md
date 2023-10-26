# Background

Spark Streaming programs are employed to fetch cdc data from kafka topics, then deliver it to Iceberg tables. The interval duration of Spark Streaming batch is 5 minutes. That's to write Iceberg tables every 5 minutes.

# Symptoms

Only one cpu core and 2G memory are permitted for Spark Streaming programs to run, but it consumes much more than 2 G memory.

```text
[root@datanode3 temp]# ps -eo pid,ppid,rss,%mem,%cpu,cmd |grep 259708
166024 450015   968  0.0  0.0 grep --color=auto 259708
259708 114843 12213776  9.2 3.6 /usr/java/jdk1.8.0_144/bin/java -cp /opt/cloudera/parcels/GPLEXTRAS-6.2.1-1.gplextras6.2.1.p0.1425774/jars/hadoop-lzo-0.4.15-cdh6.2.1.jar:/opt/spark3/spark_3.0.1/conf/:/opt/spark3/spark_3.0.1/jars/*:/etc/hadoop/conf/ -Xmx2048M -Dspark.network.timeout=60000 -Dspark.rpc.askTimeout=60s -Dspark.driver.port=39283 org.apache.spark.executor.CoarseGrainedExecutorBackend --driver-url spark://CoarseGrainedScheduler@datanode2:39283 --executor-id 0 --hostname 10.50.253.3 --cores 1 --app-id app-20231016145648-150992 --worker-url spark://Worker@10.50.253.3:43639

[root@datanode3 temp]# top -p 259708
top - 11:13:31 up 1168 days, 20:44,  1 user,  load average: 5.39, 7.60, 7.40
......
   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                          
259708 root      20   0   25.9g  11.6g  28508 S   0.6  9.3 520:28.91 java
```

As you see, much more than 11g physical memory is occupied by the Spark Streaming program. Moreover, it continues increasing without stopping phenomenon.

# Diagnosis

## 1. Jmap

The Spark Streaming program is a Java Program, witnessing the memory allocations via tool sets of Java.

```
[root@datanode3 temp]# jmap -histo:live 259708 | more

 num     #instances         #bytes  class name
----------------------------------------------
   1:        103316       14551920  [C
   2:          2482        9907568  [B
   3:         77955        2494560  java.util.concurrent.ConcurrentHashMap$Node
   4:        102876        2469024  java.lang.String
   5:         18244        2001216  java.lang.Class
   6:         33139        1836600  [Ljava.lang.Object;
   7:         48121        1539872  java.util.HashMap$Node
   8:         19988        1293160  [Ljava.util.HashMap$Node;
   9:         26316        1052640  java.util.LinkedHashMap$Entry
  10:         11041         971608  java.lang.reflect.Method
  11:         19964         958272  java.util.zip.Inflater
  12:         20996         839840  java.lang.ref.Finalizer
  13:         14464         809984  java.util.LinkedHashMap
  14:         43559         696944  java.lang.Object
  ......
6373:             1             16  sun.util.locale.provider.CalendarDataUtility$CalendarWeekParameterGetter
6374:             1             16  sun.util.locale.provider.CalendarNameProviderImpl$LengthBasedComparator
6375:             1             16  sun.util.locale.provider.SPILocaleProviderAdapter
6376:             1             16  sun.util.resources.LocaleData
6377:             1             16  sun.util.resources.LocaleData$LocaleDataResourceBundleControl
6378:             1             16  sun.util.resources.LocaleData$SupplementaryResourceBundleControl
Total       1063698       59331608
```

Find the total occupied memory by Java Objects is 59331608,  much less than 11.6 G. Therefore, that much memory used by process is not caused by Java Object instances. Native memory leaking should be considered.

# 2. Pmap

```text
pmap -X 259708

259708:   /usr/java/jdk1.8.0_144/bin/java -cp /opt/cloudera/parcels/GPLEXTRAS-6.2.1-1.gplextras6.2.1.p0.1425774/jars/hadoop-lzo-0.4.15-cdh6.2.1.jar:/opt/spark3/spark_3.0.1/conf/:/opt/spark3/spark_3.0.1/jars/*:/etc/hadoop/conf/ -Xmx2048M -Dspark.network.timeout=60000 -Dspark.rpc.askTimeout=60s -Dspark.driver.port=39283 org.apache.spark.executor.CoarseGrainedExecutorBackend --driver-url spark://CoarseGrainedScheduler@datanode2:39283 --executor-id 0 --hostname 10.50.253.3 --cores 1 --app-id app-20231016145648-150992 -
         Address Perm   Offset Device     Inode     Size      Rss      Pss Referenced Anonymous  Swap Locked ProtectionKey Mapping
        00400000 r-xp 00000000  fd:00     46349        4        4        0          4         0     0      0             0 java
        00600000 rw-p 00000000  fd:00     46349        4        4        4          4         4     0      0             0 java
        01716000 rw-p 00000000  00:00         0     1096       92       92         92        92     0      0             0 [heap]
        80000000 rw-p 00000000  00:00         0  1398272  1398272  1398272    1394220   1398272     0      0             0 
        d5580000 rw-p 00000000  00:00         0   698880   696092   696092     696092    696092     0      0             0 
       100000000 rw-p 00000000  00:00         0    40960    27620    27620      27596     27620     0      0             0 
       102800000 ---p 00000000  00:00         0  1007616        0        0          0         0     0      0             0 
    7f2dc4000000 rw-p 00000000  00:00         0     5280     2568     2568       2564      2568     0      0             0 
    7f2dc4528000 ---p 00000000  00:00         0    60256        0        0          0         0     0      0             0 
    7f2dcc000000 rw-p 00000000  00:00         0     1952      752      752        752       752     0      0             0 
......
    7f31afffc000 ---p 00000000  00:00         0       16        0        0          0         0     0      0             0 
    7f31b0000000 rw-p 00000000  00:00         0    65512    43960    43960      43644     43960   228      0             0 
    7f31b3ffa000 ---p 00000000  00:00         0       24        0        0          0         0     0      0             0 
    7f31b4000000 rw-p 00000000  00:00         0    59896    39868    39868      39720     39868   352      0             0 
    7f31b7a7e000 ---p 00000000  00:00         0     5640        0        0          0         0     0      0             0 
    7f31bc000000 rw-p 00000000  00:00         0    65516    43464    43464      42952     43464   340      0             0 
    7f31bfffb000 ---p 00000000  00:00         0       20        0        0          0         0     0      0             0 
    7f31c4000000 rw-p 00000000  00:00         0    65516    42712    42712      42336     42712   256      0             0 
    7f31c7ffb000 ---p 00000000  00:00         0       20        0        0          0         0     0      0             0 
    7f31cc000000 rw-p 00000000  00:00         0    65500    45348    45348      44444     45348   584      0             0 
    7f31cfff7000 ---p 00000000  00:00         0       36        0        0          0         0     0      0             0 
    7f31d4000000 rw-p 00000000  00:00         0    65476    45292    45292      44704     45292    52      0             0 
    7f31d7ff1000 ---p 00000000  00:00         0       60        0        0          0         0     0      0             0 
    7f31dc000000 rw-p 00000000  00:00         0    65512    42572    42572      41668     42572   184      0             0 
......
    7f3511655000 r--s 006a8000  fd:00 136624421      204      204       67        204         0     0      0             0 spire_2.12-0.17.0-M1.jar
    7f3511688000 r--s 0004e000  fd:00 136624420       12       12        3         12         0     0      0             0 spark-yarn_2.12-3.0.1.jar
    7f351168b000 r--s 0000b000  fd:00 136624419        8        8        2          8         0     0      0             0 spark-unsafe_2.12-3.0.1.jar
    7f351168d000 r--s 00002000  fd:00 136624418        4        4        1          4         0     0      0             0 spark-tags_2.12-3.0.1-tests.jar
    7f351168e000 r--s 00003000  fd:00 136624417        4        4        1          4         0     0      0             0 spark-tags_2.12-3.0.1.jar
    7f351168f000 r--s 0010b000  fd:00 136624416       44       44       14         44         0     0      0             0 spark-streaming_2.12-3.0.1.jar
......
    7ffc10163000 r-xp 00000000  00:00         0        8        4        0          4         0     0      0             0 [vdso]
ffffffffff600000 r-xp 00000000  00:00         0        4        0        0          0         0     0      0             0 [vsyscall]
                                                ======== ======== ======== ========== ========= ===== ====== ============= 
                                                27107036 12189800 12168166   12088928  12161172 69772      0             0 KB 
```
The number 12189800 matches 11.6g that occupied by 259708 process. Many memory extents can not be mapped any objects, which might be leaked . 

# When native memory leak

Refer to local docs named `造成Java程序原生native内存泄漏的原因.md`

# Look for memory-leaking issues

The Spark Streaming Programs engage Java jars related Iceberg to write data, and Iceberg tables have metadata organized by Iceberg dependencies. Go to github issues looking for issues about memory-leaking.

https://github.com/apache/iceberg/pull/5126  
https://github.com/apache/iceberg/pull/3974

So, the Iceberg jar should be upgraded to solve the problem.