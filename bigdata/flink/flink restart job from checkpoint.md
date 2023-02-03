flink使用checkpoint方式保存task的状态，当task失败时，可以从之前checkpoint地方恢复状态；

如果说整个应用挂了，如何根据之前checkpoint来恢复应用的状态；

首先应用挂了的话，它默认会删除之前checkpoint数据，当然我们可以在代码中设置应用退出时保留checkpoint数据

```
CheckpointConfig config = env.getCheckpointConfig(); 
config.enableExternalizedCheckpoints(ExternalizedCheckpointCleanup.RETAIN_ON_CANCELLATION);
```

第二步：指定checkpoint目录重启应用

bin/flink run -s hdfs://aba/aa.... ...

-s 指定checkpoint目录，类似`hdfs://nameservice1/flink/flink-checkpoints/tft-flink-act-balance/d12348cac41c41900b51be2f0bf4638e/chk-96380`

接下来模拟下整个过程，以WordCount为例；我们定义了一个叫TMap的MapFunction，他的作用就是在收到“error”字符串的时候抛出异常;

我们的重启策略是task失败时，重启3次，每次间隔2秒

```
object StateWordCount {
  def main(args: Array[String]): Unit = {
    val env = StreamExecutionEnvironment.getExecutionEnvironment
    //开启checkpoint才会有重启策略
    env.enableCheckpointing(5000)
    //失败后最多重启3次，每次重启间隔2000ms
    env.setRestartStrategy(RestartStrategies.fixedDelayRestart(3, 2000))
    val config = env.getCheckpointConfig
    config.enableExternalizedCheckpoints(ExternalizedCheckpointCleanup.RETAIN_ON_CANCELLATION)
    env.setStateBackend(new FsStateBackend("hdfs://hadoop:8020/tmp/flinkck"))
    val inputStream = env.socketTextStream("hadoop7", 9999) //nc -lk 9999
    inputStream.flatMap(_.split(" ")).map(new TMap()).map((_, 1)).keyBy(0).sum(1).print()
    env.execute("stream word count job")
  }
}
/**当接收的数据是error字符串时候，抛出异常*/
class TMap() extends MapFunction[String, String] {
  override def map(t: String): String = {
    if ("error".equals(t)) {
      throw new RuntimeException("error message ")
    }
    t
  }
}
```


在hadoop7机器启动一个nc服务

nc -lk 9999

第一次执行程序

/data2/flink-1.10.0/bin/flink run -yD yarn.containers.vcores=2 -m yarn-cluster  -c StateWordCount wordcount.jar
 
往9999端口发送数据

```
[root@hadoop7]$ nc -lk 9999
spark
spark
flink
flink
```

此时打印日志

```
(spark,1) 
(spark,2) 
(flink,1) 
(flink,2)
```
 
现在发送一条错误数据“error”,task已经失败了

```
2020-03-26 16:04:00,424 INFO org.apache.flink.runtime.taskmanager.Task - Source: Socket Stream -> Flat Map -> Map -> Map (1/1) (f7348fec435dcd81fca53edd5042d791) 
switched from RUNNING to FAILED. java.lang.RuntimeException: error message     at TMap.map(StateWordCount.scala:42)     at TMap.map(StateWordCount.scala:39)     at 
org.apache.flink.streaming.api.operators.StreamMap.processElement(StreamMap.java:41)     at org.apache.flink.streaming.runtime.tasks.OperatorChain$CopyingChainingOutput.pushToOperator
```

但是大概两秒后，task恢复了

```
2020-03-26 16:04:02,496 INFO org.apache.flink.runtime.taskmanager.Task - aggregation -> Sink: Print to Std. Out (1/1) (33a473ca0606f0b96ad9542e8fc41bef) switched from DEPLOYING to RUNNING.
```

重新发送一条数据“flink”

```
[hdfs@hadoop7 hz_adm]$ nc -lk 9999
spark
spark
flink
flink
error
flink
```

查看结果
```
(spark,1) 
(spark,2) 
(flink,1) 
(flink,2) 
(flink,3)
```
可以看到task恢复了，计算结果也是基于task失败前保存的state上计算的

在代码里设置的是程序最多可以重启三次，接下来我们输入3条“error”数据，让程序彻底崩溃

```
[hdfs@hadoop7]$ nc -lk 9999
spark
spark
flink
flink
error
flink                                                                                                 
error
error
error
```

因为之前设置过保存checkpoint数据，在hdfs上查看下保存的state的数据

```
hdfs dfs -ls /tmp/flinkck/d3fad3e90704e5440fa605a00b9a9b97/chk-987
Found 2 items
-rw-r--r--   3 hdfs supergroup       2019 2020-03-26 17:17 /tmp/flinkck/d3fad3e90704e5440fa605a00b9a9b97/chk-987/88073e87-e08d-4206-a7e3-59b82da2b7fa
-rw-r--r--   3 hdfs supergroup       1292 2020-03-26 17:17 /tmp/flinkck/d3fad3e90704e5440fa605a00b9a9b97/chk-987/_metadata
```

指定checkpoint目录，重启应用

```
/data2/flink-1.10.0/bin/flink run -s hdfs://hadoop:8020/tmp/flinkck/d3fad3e90704e5440fa605a00b9a9b97/chk-987 \
 -yD yarn.containers.vcores=2 -m yarn-cluster -c StateWordCount wordcount.jar
```

输入两条数据“flink”和“spark”
```
[hdfs@hadoop7]$ nc -lk 9999
spark
spark
flink
flink
error
flink                                                                                                 
error
error
error
flink
spark
```
可以看到结果是在程序崩溃之前保存的state基础之上计算的

```
(flink,4)
(spark,3)
```