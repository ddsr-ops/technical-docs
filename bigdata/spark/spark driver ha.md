**Demo**

```
package com.sparkStreaming.Demo10_HA

import org.apache.spark.SparkContext
import org.apache.spark.sql.SparkSession
import org.apache.spark.storage.StorageLevel
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.streaming.dstream.DStream

/**
 * Created by Shi shuai RollerQing on 2019/11/16 14:23
 *
 * SparkStreaming应用之Driver进程的高可用HA
 */
object DriverHADemo {
  def main(args: Array[String]): Unit = {
    val spark: SparkSession = SparkSession
      .builder()
      .appName(DriverHADemo.getClass.getSimpleName)
      .getOrCreate()
    val sc : SparkContext = spark.sparkContext
    //      .master("local[*]") //这个要打包到集群 这个就不用了

    val ck = "/spark-streaming/ck_ha"
//    val ck = "D:\\installs\\SparkStreamingTest\\data"

    val ssc : StreamingContext = StreamingContext.getOrCreate(ck, () => {
      val tmpSsc: StreamingContext = new StreamingContext(sc, Seconds(2))

      tmpSsc.checkpoint(ck)

      val ds: DStream[(String, Int)] = tmpSsc.socketTextStream("hadoop01", 8888, StorageLevel.MEMORY_ONLY)
        .flatMap(_.split("\\s+")) //     \\s表示 空格,回车,换行等空白符,+号表示一个或多个的意思,所以...
        .map((_, 1))
        .reduceByKey(_ + _)
      ds.print

      tmpSsc
    })
    ssc.start
    ssc.awaitTermination
  }
}
```

**Launch**
```
./bin/spark-submit \
--class com.sparkStreaming.Demo10_HA.DriverHADemo \
--master spark://hadoop01:7077 \
--deploy-mode cluster \
--supervise \
hdfs://hadoop01:8020/spark-streaming/submitjars/ninthTest.jar
```

**Note**

因为不能通过kill 杀死
所以需要到UI界面 spark的8080端口 去kill掉该application
