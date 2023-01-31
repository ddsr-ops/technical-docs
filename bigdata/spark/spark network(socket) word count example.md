```
cd /opt/spark3/spark_3.0.1/examples/jars
scopt_2.12-3.7.1.jar  spark-examples_2.12-3.0.1.jar

./bin/spark-submit --deploy-mode cluster  --driver-memory 1G  --total-executor-cores 1 --executor-memory 3G --executor-cores 1  --class org.apache.spark.examples.streaming.NetworkWordCount examples/jars/spark-examples_2.12-3.0.1.jar 88.88.16.189 9991

/opt/spark3/spark_3.0.1/bin/spark-submit --deploy-mode cluster  --driver-memory 1G  --total-executor-cores 1 --executor-memory 3G --executor-cores 1  --class org.apache.spark.examples.streaming.NetworkWordCount /opt/spark3/spark_3.0.1/examples/jars/spark-examples_2.12-3.0.1.jar hadoop189 9991
```