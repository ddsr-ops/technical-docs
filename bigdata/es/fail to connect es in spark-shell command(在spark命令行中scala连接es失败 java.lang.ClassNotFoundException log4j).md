**Symptom**

```text

sh /opt/spark3/spark_3.0.1/bin/spark-shell  --jars hdfs:///spark_tool/jars/* 
Note: Here, es elasticsearch-rest-high-level-client jar is included in ///spark_tool/jars/. With this jar, you can create a es index


import org.elasticsearch.client.{RestClient, RestHighLevelClient}
import org.apache.http.HttpHost

val client = new RestHighLevelClient(RestClient.builder(new HttpHost("10.50.253.2"	, 9200, "http")))

报错在这里，创建es连接 val client = new RestHighLevelClient(
  RestClient.builder(
    ips.split(",").map(x=>new HttpHost(x,port.toInt)): _*
    )
)

Caused by: java.lang.ClassNotFoundException: org.apache.logging.log4j.core.appender.AbstractAppender
```


**Solution**

spark 使用的是log4j1，es使用的是log4j2，让spark启动的时候，使用log4j2就解决了

```shell
sh /opt/spark3/spark_3.0.1/bin/spark-shell  --conf spark.driver.extraClassPath=/opt/spark3/spark_3.0.1/spark_extras/* \
--conf spark.executor.userClassPathFirst=true   --jars hdfs:///spark_tool/jars/*
```