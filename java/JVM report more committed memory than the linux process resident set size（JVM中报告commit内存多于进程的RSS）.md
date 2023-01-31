[Reference](https://stackoverflow.com/questions/31173374/why-does-a-jvm-report-more-committed-memory-than-the-linux-process-resident-set#answer-31178912)

When running a Java app (in YARN) with native memory tracking enabled (-XX:NativeMemoryTracking=detail see https://docs.oracle.com/javase/8/docs/technotes/guides/vm/nmt-8.html and https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr007.html), I can see how much memory the JVM is using in different categories.

My app on jdk 1.8.0_45 shows:

Native Memory Tracking:
```
Total: reserved=4023326KB, committed=2762382KB
-                 Java Heap (reserved=1331200KB, committed=1331200KB)
                            (mmap: reserved=1331200KB, committed=1331200KB) 

-                     Class (reserved=1108143KB, committed=64559KB)
                            (classes #8621)
                            (malloc=6319KB #17371) 
                            (mmap: reserved=1101824KB, committed=58240KB) 

-                    Thread (reserved=1190668KB, committed=1190668KB)
                            (thread #1154)
                            (stack: reserved=1185284KB, committed=1185284KB)
                            (malloc=3809KB #5771) 
                            (arena=1575KB #2306)

-                      Code (reserved=255744KB, committed=38384KB)
                            (malloc=6144KB #8858) 
                            (mmap: reserved=249600KB, committed=32240KB) 

-                        GC (reserved=54995KB, committed=54995KB)
                            (malloc=5775KB #217) 
                            (mmap: reserved=49220KB, committed=49220KB) 

-                  Compiler (reserved=267KB, committed=267KB)
                            (malloc=137KB #333) 
                            (arena=131KB #3)

-                  Internal (reserved=65106KB, committed=65106KB)
                            (malloc=65074KB #29652) 
                            (mmap: reserved=32KB, committed=32KB) 

-                    Symbol (reserved=13622KB, committed=13622KB)
                            (malloc=12016KB #128199) 
                            (arena=1606KB #1)

-    Native Memory Tracking (reserved=3361KB, committed=3361KB)
                            (malloc=287KB #3994) 
                            (tracking overhead=3075KB)

-               Arena Chunk (reserved=220KB, committed=220KB)
                            (malloc=220KB) 
```
This shows 2.7GB of committed memory, including 1.3GB of allocated heap and almost 1.2GB of allocated thread stacks (using many threads).

However, when running ps ax -o pid,rss | grep <mypid> or top it shows only 1.6GB of RES/rss resident memory. Checking swap says none in use:

```
free -m
             total       used       free     shared    buffers     cached
Mem:        129180      99348      29831          0       2689      73024
-/+ buffers/cache:      23633     105546
Swap:        15624          0      15624
```

Why does the JVM indicate 2.7GB memory is committed when only 1.6GB is resident? Where did the rest go?









    I'm beginning to suspect that stack memory (unlike the JVM heap) seems to be precommitted without becoming resident and over time becomes resident only up to the high water mark of actual stack usage.

Yes, at least on linux mmap is lazy unless told otherwise. Anonymous pages are only backed by physical memory once they're written to (reads are not sufficient due to the zero-page optimization)

GC heap memory effectively gets touched by the copying collector or by pre-zeroing (-XX:+AlwaysPreTouch), so it'll always be resident. Thread stacks otoh aren't affected by this.

For further confirmation you can use pmap -x <java pid> and cross-reference the RSS of various address ranges with the output from the virtual memory map from NMT.

Reserved memory has been mmaped with PROT_NONE. Which means the virtual address space ranges have entries in the kernel's vma structs and thus will not be used by other mmap/malloc calls. But they will still cause page faults being forwarded to the process as SIGSEGV, i.e. accessing them is an error.

This is important to have contiguous address ranges available for future use, which in turn simplifies pointer arithmetic.

Committed-but-not-backed-by-storage memory has been mapped with - for example - PROT_READ | PROT_WRITE but accessing it still causes a page fault. But that page fault is silently handled by the kernel by backing it with actual memory and returning to execution as if nothing happened.
I.e. it's an implementation detail/optimization that won't be noticed by the process itself.

To give a breakdown of the concepts:

* Used Heap: the amount of memory occupied by live objects according to the last GC

* Committed: Address ranges that have been mapped with something other than PROT_NONE. They may or may not be backed by physical or swap due to lazy allocation and paging.

* Reserved: The total address range that has been pre-mapped via mmap for a particular memory pool.
The reserved ? committed difference consists of PROT_NONE mappings, which are guaranteed to not be backed by physical memory

* Resident: Pages which are currently in physical ram. This means code, stacks, part of the committed memory pools but also portions of mmaped files which have recently been accessed and allocations outside the control of the JVM.

* Virtual: The sum of all virtual address mappings. Covers committed, reserved memory pools but also mapped files or shared memory. This number is rarely informative since the JVM can reserve very large address ranges in advance or mmap large files.