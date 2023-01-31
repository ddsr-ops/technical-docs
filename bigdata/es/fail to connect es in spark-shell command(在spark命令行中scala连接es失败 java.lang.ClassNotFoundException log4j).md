**Symptom**

```text

sh /opt/spark3/spark_3.0.1/bin/spark-shell  --jars hdfs:///spark_tool/jars/* 
Note: Here, es elasticsearch-rest-high-level-client jar is included in ///spark_tool/jars/. With this jar, you can create a es index


import org.elasticsearch.client.{RestClient, RestHighLevelClient}
import org.apache.http.HttpHost

val client = new RestHighLevelClient(RestClient.builder(new HttpHost("10.50.253.2"	, 9200, "http")))

�������������es���� val client = new RestHighLevelClient(
  RestClient.builder(
    ips.split(",").map(x=>new HttpHost(x,port.toInt)): _*
    )
)

Caused by: java.lang.ClassNotFoundException: org.apache.logging.log4j.core.appender.AbstractAppender
```


**Solution**

spark ʹ�õ���log4j1��esʹ�õ���log4j2����spark������ʱ��ʹ��log4j2�ͽ����

```shell
sh /opt/spark3/spark_3.0.1/bin/spark-shell  --conf spark.driver.extraClassPath=/opt/spark3/spark_3.0.1/spark_extras/* \
--conf spark.executor.userClassPathFirst=true   --jars hdfs:///spark_tool/jars/*
```