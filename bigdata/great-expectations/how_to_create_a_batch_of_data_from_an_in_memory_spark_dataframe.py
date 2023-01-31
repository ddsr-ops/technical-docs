import great_expectations as ge
import pyspark
from great_expectations import DataContext
from great_expectations.checkpoint import SimpleCheckpoint
from great_expectations.core import ExpectationSuite
from great_expectations.core.batch import RuntimeBatchRequest
from great_expectations.core.util import get_or_create_spark_application
from ruamel import yaml


import os
os.environ["PYSPARK_PYTHON"] = "/usr/local/bin/python3"
os.environ["PYSPARK_DRIVER_PYTHON"] = "/usr/local/bin/python3"

table_name = "hadoop_catalog.fdm.f_trp_trip_info"
data_dt = "20220205"
# spark-sql> select data_dt, count(*) from f_trp_trip_info  group by data_dt order by 1;
# 20220205	5484164
# 20220206	6784834
# 20220207	12181386

# Filter section
# Run name, Asset name, Expectation suite

context: DataContext = ge.get_context()
yaml = yaml.YAML(typ="safe")

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
    "spark.jars": "hdfs:///spark_tool/jars/spark_util-1.0-SNAPSHOT.jar,hdfs:///spark_tool/jars/iceberg-spark3-runtime-0.11.1.jar",
    "spark.app.name": table_name + "_great_expectations_spark_job"
}

spark_session: pyspark.sql.session.SparkSession = (
    get_or_create_spark_application(spark_conf)
)

# Create a expectation suite by context
context.create_expectation_suite(
    expectation_suite_name=table_name,
    overwrite_existing=True
)
# suite: ExpectationSuite = context.get_expectation_suite(
#     expectation_suite_name=table_name
# )

# Create a datasource
datasource_yaml = f"""
name: spark_iceberg_datasource
class_name: Datasource
module_name: great_expectations.datasource
execution_engine:
    module_name: great_expectations.execution_engine
    class_name: SparkDFExecutionEngine
data_connectors:
    my_runtime_data_connector:
        class_name: RuntimeDataConnector
        batch_identifiers:
            - some_key_maybe_pipeline_stage
            - some_other_key_maybe_airflow_run_id
"""
context.add_datasource(**yaml.load(datasource_yaml))

# RuntimeBatchRequest with batch_data as Spark Dataframe
sql = "select * from {} where data_dt = {}".format(table_name, data_dt) if data_dt else "select * from {}".format(
    table_name)
df: pyspark.sql.dataframe.DataFrame = spark_session.sql(sql)

# Datasource spark_iceberg_datasource has been added ago
runtime_batch_request = RuntimeBatchRequest(
    datasource_name="spark_iceberg_datasource",
    data_connector_name="my_runtime_data_connector",
    data_asset_name=table_name,
    runtime_parameters={"batch_data": df},
    batch_identifiers={
        "some_key_maybe_pipeline_stage": "ingestion step 1",
        "some_other_key_maybe_airflow_run_id": "run 18",
    },
)

exclude_column_names = []

expectation_suite = context.create_expectation_suite(
    expectation_suite_name=table_name, overwrite_existing=True
)

data_assistant_result = context.assistants.onboarding.run(
    batch_request=runtime_batch_request,
    exclude_column_names=exclude_column_names,
)

# expectation_suite = data_assistant_result.get_expectation_suite(
#     expectation_suite_name=expectation_suite_name
# )

# noinspection PyTypeChecker
context.save_expectation_suite(
    expectation_suite=expectation_suite, discard_failed_expectations=False
)

checkpoint_config = {
    "class_name": "SimpleCheckpoint",
    "validations": [
        {
            "batch_request": runtime_batch_request,
            "expectation_suite_name": table_name,
        }
    ],
}

checkpoint = SimpleCheckpoint(
    table_name,
    context,
    **checkpoint_config,
)

# context.add_checkpoint()

checkpoint_result = checkpoint.run()

# assert checkpoint_result["success"] is True

# data_assistant_result.plot_metrics()
