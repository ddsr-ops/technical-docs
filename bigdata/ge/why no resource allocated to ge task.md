# Spark Config in the code

```
    spark_conf = {
        "spark.sql.extensions": "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
        "spark.sql.catalog.hadoop_catalog": "org.apache.iceberg.spark.SparkCatalog",
        "spark.sql.catalog.hadoop_catalog.type": "hadoop",
        "spark.sql.debug.maxToStringFields": "100",
        "spark.sql.catalog.hadoop_catalog.warehouse": "hdfs:///hadoop_catalog",
        "spark.sql.sources.partitionOverwriteMode": "dynamic",
        "spark.sql.adaptive.enabled": "true",
        "spark.sql.adaptive.coalescePartitions.enabled": "true",
        "spark.sql.adaptive.localShuffleReader.enabled": "true",
        "spark.sql.adaptive.advisoryPartitionSizeInBytes": "128M",
        "spark.sql.adaptive.coalescePartitions.minPartitionNum": "1",
        "spark.sql.shuffle.partitions": "200",
        "spark.jars": "hdfs:///spark_tool/jars/iceberg-spark3-runtime-0.11.1.jar",
        "spark.app.name": app_name + "_ge",
        "spark.master": "spark://namenode1:7077,namenode2:7077",
        "spark.cores.max": "1" <====================
    }

```

# Configurations in the Spark Standalone Cluster

Some settings in the `spark-defaults.conf` file.

> spark.deploy.defaultCores=20
spark.executor.memory=8G
spark.executor.cores=4

# Analysis

Field `spark.cores.max`  is set to 1 which means total cpu cores(--total-executor-cores) running the task is 1.
The value `1` is less than cpu cores `4` which an executor holds.
Spark Master can not allocate an executor, so tasks are submitted but cpu cores which tasks occupy is zero.
Yeah, task details are seen in the Spark UI.

# Solution

```text
spark_conf = {
        "spark.sql.extensions": "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",
        "spark.sql.catalog.hadoop_catalog": "org.apache.iceberg.spark.SparkCatalog",
        "spark.sql.catalog.hadoop_catalog.type": "hadoop",
        "spark.sql.debug.maxToStringFields": "100",
        "spark.sql.catalog.hadoop_catalog.warehouse": "hdfs:///hadoop_catalog",
        "spark.sql.sources.partitionOverwriteMode": "dynamic",
        "spark.sql.adaptive.enabled": "true",
        "spark.sql.adaptive.coalescePartitions.enabled": "true",
        "spark.sql.adaptive.localShuffleReader.enabled": "true",
        "spark.sql.adaptive.advisoryPartitionSizeInBytes": "128M",
        "spark.sql.adaptive.coalescePartitions.minPartitionNum": "1",
        "spark.sql.shuffle.partitions": "200",
        "spark.jars": "hdfs:///spark_tool/jars/iceberg-spark3-runtime-0.11.1.jar",
        "spark.app.name": app_name + "_ge",
        "spark.master": "spark://namenode1:7077,namenode2:7077",
        "spark.cores.max": "1",
        "spark.executor.memory": "2G",
        "spark.executor.cores": "1"
    }
```

# TODO

spark.cores.max == total-executor-cores ?