[Reference](https://stackoverflow.com/questions/48798024/java-consumes-memory-more-than-xmx-argument)


As the comments and answers have alluded to, there are a number of other factors to take into account when measuring JVM memory usage. However, I don't think any answer has gone into nearly enough depth.

# JVM Memory Overview
Lets hit the question "I was wondering what is that 30MB used for?" head on. To do this, here is a simple java class:

```// HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello world!");
        Thread.sleep(10000); // wait 10 seconds so we can get memory usage
    }
}
```
Now compile and run it with heap constraints:

```$ nohup java -Xms2m -Xmx2m HelloWorld & # run in background
$ ps aux | awk 'NR==1; /[H]elloWorld/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
chaospie  6204  6.0  0.1 2662860 23040 pts/2   Sl   19:15   0:00 java -Xms2m -Xmx2m HelloWorld
```
Looking at the RSS (Resident Set Size, or how much memory this process is using) above we see that the JVM's process is using about 23MB of memory. To see why, lets do some analysis. The quickest way to get a good overview is to turn on NativeMemorytracking use the jcmd tool's VM.native_memory command. So, let's run our app again:
```
$ nohup java -XX:NativeMemoryTracking=summary -Xms2M -Xmx2M HelloWorld &
[2] 6661
nohup: ignoring input and appending output to 'nohup.out'

$ ps aux | awk 'NR==1; /[H]elloWorld/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
chaospie  6661  5.0  0.1 2662860 23104 pts/2   Sl   19:21   0:00 java -XX:NativeMemoryTracking=summary -Xms2M -Xmx2M HelloWorld

$ jcmd 6661 VM.native_memory summary
6661:

Native Memory Tracking:

Total: reserved=1360145KB, committed=61177KB
-                 Java Heap (reserved=2048KB, committed=2048KB)
                            (mmap: reserved=2048KB, committed=2048KB)

-                     Class (reserved=1066093KB, committed=14189KB)
                            (classes #402)
                            (malloc=9325KB #146)
                            (mmap: reserved=1056768KB, committed=4864KB)

-                    Thread (reserved=20646KB, committed=20646KB)
                            (thread #21)
                            (stack: reserved=20560KB, committed=20560KB)
                            (malloc=62KB #110)
                            (arena=23KB #40)

-                      Code (reserved=249632KB, committed=2568KB)
                            (malloc=32KB #299)
                            (mmap: reserved=249600KB, committed=2536KB)

-                        GC (reserved=10467KB, committed=10467KB)
                            (malloc=10383KB #129)
                            (mmap: reserved=84KB, committed=84KB)

-                  Compiler (reserved=132KB, committed=132KB)
                            (malloc=1KB #21)
                            (arena=131KB #3)

-                  Internal (reserved=9453KB, committed=9453KB)
                            (malloc=9421KB #1402)
                            (mmap: reserved=32KB, committed=32KB)

-                    Symbol (reserved=1358KB, committed=1358KB)
                            (malloc=902KB #86)
                            (arena=456KB #1)

-    Native Memory Tracking (reserved=143KB, committed=143KB)
                            (malloc=86KB #1363)
                            (tracking overhead=57KB)

-               Arena Chunk (reserved=175KB, committed=175KB)
                            (malloc=175KB)
```
# Memory Regions
Let's break it down 1:

* Java Heap : this is the heap -
* Class : this is Metaspace, assuming you are using java 8.
* Thread : this shows the number of threads, and the overall mem usage of the threads (note that the used stack in this section reflects the Xss value times the number of threads, you can get the default -Xssvalue with java -XX:+PrintFlagsFinal -version |grep ThreadStackSize).
* Code : the code cache - this is used by the JIT (Just In Time Compiler) to cache compiled code.
* GC : space used by the garbage collector.
* Compiler : space used by the JIT when generating code.
* Symbols : this is for symbols, field names, method signatures etc...
* Native Memory Tracking : memory used by the native memory tracker itself.
* Arena Chunk : this is related to malloc arenas 2.
Much more than just the heap!

# Reserved, Committed And RSS
Note that each region has a committed and a reserved section. To keep it short reserved is what it can grow to and committed is what is currently committed to be used. For example see the Java Heap section: Java Heap (reserved=2048KB, committed=2048KB), reserved is our -Xmx value and committed would be our -Xms value, in this case they are equal .

Note too that the total committed size - it does not reflect actual usage reported by RSS (or the RES column in top). The reason they differ is that RSS shows the size of all memory pages which have been, and still are in use in physical memory, whereas committed shows the memory which is used including that which is not in physical memory 3.

There is a lot more to this, however JVM and OS memory management is a complex topic, so I hope this answers your question at least at a high level.

1. See https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr022.html
2. From the JVM Native Memory Tracking docs (https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr007.html#BABJGHDB):
> Arena is a chunk of memory allocated using malloc. Memory is freed from these chunks in bulk, when exiting a scope or leaving an area of code. These chunks may be reused in other subsystems to hold temporary memory, for example, pre-thread allocations. Arena malloc policy ensures no memory leakage. So Arena is tracked as a whole and not individual objects. Some amount of initial memory can not by tracked.

3. To go into the difference between RSS, Reserved and Committed memory would be too much here, OS memory management is a complex topic, but see this answer for a good overview.