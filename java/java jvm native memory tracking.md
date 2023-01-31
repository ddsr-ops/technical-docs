Native Memory Tracking
java8给HotSpot VM引入了Native Memory Tracking (NMT)特性，可以用于追踪JVM的内部内存使用


# 开启
-XX:NativeMemoryTracking=summary  
使用-XX:NativeMemoryTracking=summary可以用于开启NMT，其中该值默认为off，可以设置为summary或者detail来开启；开启的话，大概会增加5%-10%的性能消耗

# 查看
/ # jcmd 1 VM.native_memory summary  
/ # jcmd 1 VM.native_memory summary scale=MB  
这里"1"表示为进程id  
使用jcmd pid VM.native_memory可以查看，后面可以加summary或者detail，如果是开启summary的，就只能使用summary；其中scale参数可以指定展示的单位，可以为KB或者MB或者GB

# 创建baseline
/ # jcmd 1 VM.native_memory baseline    
Baseline succeeded

<u>创建baseline之后可以用summary.diff来对比</u>

# 查看diff
/ # jcmd 1 VM.native_memory summary.diff

使用summary.diff来查看跟baseline对比的统计信息

# shutdown时输出
-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics

使用上述命令可以在jvm shutdown的时候输出整体的native memory统计

# 关闭
/ # jcmd 1 VM.native_memory shutdown  
Native memory tracking has been turned off

使用jcmd pid VM.native_memory shutdown可以用于关闭NMT；注意使用jcmd关闭之后貌似没有对应jcmd命令来开启

#实例
/ # jcmd 1 VM.native_memory summary scale=MB
```
Native Memory Tracking:

Total: reserved=2175MB, committed=682MB
-                 Java Heap (reserved=501MB, committed=463MB)
                            (mmap: reserved=501MB, committed=463MB)

-                     Class (reserved=1070MB, committed=50MB)
                            (classes #8801)
                            (  instance classes #8204, array classes #597)
                            (malloc=2MB #24660)
                            (mmap: reserved=1068MB, committed=49MB)
                            (  Metadata:   )
                            (    reserved=44MB, committed=43MB)
                            (    used=42MB)
                            (    free=1MB)
                            (    waste=0MB =0.00%)
                            (  Class space:)
                            (    reserved=1024MB, committed=6MB)
                            (    used=5MB)
                            (    free=0MB)
                            (    waste=0MB =0.00%)

-                    Thread (reserved=228MB, committed=27MB)
                            (thread #226)
                            (stack: reserved=227MB, committed=26MB)
                            (malloc=1MB #1139)

-                      Code (reserved=243MB, committed=17MB)
                            (malloc=1MB #5509)
                            (mmap: reserved=242MB, committed=16MB)

-                        GC (reserved=23MB, committed=15MB)
                            (malloc=8MB #11446)
                            (mmap: reserved=16MB, committed=7MB)

-                  Compiler (reserved=26MB, committed=26MB)
                            (malloc=2MB #1951)
                            (arena=24MB #13)

-                  Internal (reserved=5MB, committed=5MB)
                            (malloc=3MB #9745)
                            (mmap: reserved=2MB, committed=2MB)

-                     Other (reserved=2MB, committed=2MB)
                            (malloc=2MB #202)

-                    Symbol (reserved=10MB, committed=10MB)
                            (malloc=8MB #233939)
                            (arena=3MB #1)

-    Native Memory Tracking (reserved=5MB, committed=5MB)
                            (tracking overhead=5MB)

-               Arena Chunk (reserved=63MB, committed=63MB)
                            (malloc=63MB)
```

可以看到整个memory主要包含了Java Heap、Class、Thread、Code、GC、Compiler、Internal、Other、Symbol、Native Memory Tracking、
Arena Chunk这几部分；其中reserved表示应用可用的内存大小，committed表示应用正在使用的内存大小
Java Heap部分表示heap内存目前占用了463MB；Class部分表示已经加载的classes个数为8801，其metadata占用了50MB；
Thread部分表示目前有225个线程，占用了27MB；Code部分表示JIT生成的或者缓存的instructions占用了17MB；
GC部分表示目前已经占用了15MB的内存空间用于帮助GC；Code部分表示compiler生成code的时候占用了26MB；Internal部分表示命令行解析、
JVMTI等占用了5MB；Other部分表示尚未归类的占用了2MB；Symbol部分表示诸如string table及constant pool等symbol占用了10MB；
Native Memory Tracking部分表示该功能自身占用了5MB；Arena Chunk部分表示arena chunk占用了63MB
一个arena表示使用malloc分配的一个memory chunk，这些chunks可以被其他subsystems做为临时内存使用，
比如pre-thread的内存分配，它的内存释放是成bulk的

# 小结
java8给HotSpot VM引入了Native Memory Tracking (NMT)特性，可以用于追踪JVM的内部内存使用
使用-XX:NativeMemoryTracking=summary可以用于开启NMT，其中该值默认为off，可以设置summary、detail来开启；
开启的话，大概会增加5%-10%的性能消耗；使用-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics可以在jvm shutdown的时候输出整体的native memory统计；
其他的可以使用jcmd pid VM.native_memory相关命令进行查看、diff、shutdown等
整个memory主要包含了Java Heap、Class、Thread、Code、GC、Compiler、Internal、Other、Symbol、Native Memory Tracking、Arena Chunk这几部分；
其中reserved表示应用可用的内存大小，committed表示应用正在使用的内存大小