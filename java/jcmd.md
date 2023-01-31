# 查看正在运行的 Java 进程ID、名称和 main 函数参数
jcmd

# 查看某个进程支持的命令
在jcmd 后加上进程 ID，然后加上 help 。
$ jcmd 10614 help

#查看某个进程的 JVM 版本
$ jcmd 10614 VM.version
10614:
Java HotSpot(TM) 64-Bit Server VM version 9.0.1+11
JDK 9.0.1

#查看 JVM 进程信息
$ jcmd 10614 VM.info

#建议进程进行垃圾回收
$ jcmd 10614 GC.run

#获取类的统计信息
$ jcmd 10614 GC.class_histogram | more
可以看到类名、对象数量、占用空间等。

#获取启动参数
$ jcmd 10614 VM.flags

#获取进程到现在运行了多长时间
$ jcmd 10614 VM.uptime

#查看线程信息
$ jcmd 10614 Thread.print

#获取性能相关数据
$ jcmd 10614 PerfCounter.print

#导出堆快照到当前目录
$ jcmd 10614 GC.heap_dump $PWD/heap.dump