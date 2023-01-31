Flink的提交作业方式：

flink同样支持两种提交方式，默认不指定就是客户端方式。如果需要使用集群方式提交的话。可以在提交作业的命令行中指定-d或者--detached 进行进群模式提交。

        -d,--detached                                  If present, runs the job in  detached mode（分离模式）


客户端提交方式：$FLINK_HOME/bin/flink run   -c com.daxin.batch.App flinkwordcount.jar ，客户端会多出来一个CliFrontend进程，就是驱动进程。
集群模式提交：$FLINK_HOME/bin/flink run -d  -c com.daxin.batch.App flinkwordcount.jar 程序提交完毕退出客户端，不在打印作业进度等信息！


更多细节参考flink的帮助文档，$FLINK_HOME/bin/flink  --help


两种提交作业方式的实现原理：

通过翻阅Flink的源码不难发现，关于所谓的客户端提交其实就是同步提交，作业提交之后一直跟踪作业的执行进度以及控制台输出信息打印。而后台提交其实就是异步提交，将作业提交之后返回一个Future之后就不在跟踪作业了！