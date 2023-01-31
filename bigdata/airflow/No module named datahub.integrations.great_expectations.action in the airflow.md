When debugging great_expectation task in the Airflow DAG via PythonOperator, some errors occur.

```
great_expectations.exceptions.exceptions.PluginModuleNotFoundError: No module named `datahub.integrations.great_expectations.action` could be found in your plugins directory.
    - Please verify your plugins directory is configured correctly.
    - Please verify you have a module named `datahub.integrations.great_expectations.action` in your plugins directory.
```

# Diagnose:

Manually import `datahub.integrations.great_expectations.action` package in the airflow venv.

```
(airflow_env) [root@namenode1 01_zhongguang]# python
Python 3.9.14 (main, Oct 28 2022, 09:42:04) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import datahub.integrations.great_expectations.action
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/root/airflow_env/lib/python3.9/site-packages/datahub/integrations/great_expectations/action.py", line 57, in <module>
    from datahub.utilities.sql_parser import DefaultSQLParser
  File "/root/airflow_env/lib/python3.9/site-packages/datahub/utilities/sql_parser.py", line 10, in <module>
    from datahub.utilities.sql_lineage_parser_impl import SqlLineageSQLParserImpl
  File "/root/airflow_env/lib/python3.9/site-packages/datahub/utilities/sql_lineage_parser_impl.py", line 8, in <module>
    from sqllineage.core.holders import Column, SQLLineageHolder
ModuleNotFoundError: No module named 'sqllineage'
```

So download `sqllineage` package, then install it.

```shell
pip3 download -d /tmp/sqllineage sqllineage==1.3.6

cd /tmp/sqllineage

tar -czf sqllineage.tgz *

source /root/airflow_env/bin/activate

tar -zxf sqllineage.tgz

pip3 install --no-index --find-links=./ sqllineage
```

Import `datahub.integrations.great_expectations.action` package again, it works. 
Rerun the DAG, it finished as expected.


DAG details as follows:
```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: Changhua Gong


import os
import sys

import pendulum
import pyspark
from airflow.decorators import dag
from airflow.operators.python import PythonOperator
from airflow.utils.trigger_rule import TriggerRule
from great_expectations.core.batch import RuntimeBatchRequest
from great_expectations.core.util import get_or_create_spark_application
from ruamel import yaml

import great_expectations
from great_expectations import DataContext

os.environ["PYTHONIOENCODING"] = "utf-8"
os.environ["HADOOP_USER_NAME"] = "hdfs"
os.environ['SPARK_HOME'] = "/opt/spark3/spark_3.0.1"
sys.path.append("/opt/spark3/spark_3.0.1/python")


def _run_checkpoint(**kwargs):
    ge_root_dir = "/hdp_data/gch/venv/great_expectations/great_expectations"
    _table_name = kwargs["table_name"]
    _data_dt = kwargs["data_dt"]
    include_column_names = kwargs["col_list"]  # ["order_state", "trade_channel"]
    datahub_schema = _table_name.split(".")[1]
    datahub_dataset = app_name = _table_name.split(".")[2]
    checkpoint_name = _table_name.replace(".", "_")
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
    spark_session: pyspark.sql.session.SparkSession = (
        get_or_create_spark_application(spark_conf, True)
    )

    # Explicitly specify columns to prune data
    sql = "select {} from {} where data_dt = '{}'".format(",".join(include_column_names), _table_name,
                                                          _data_dt) if _data_dt else \
        "select * from {}".format(",".join(include_column_names), _table_name)
    df: pyspark.sql.dataframe.DataFrame = spark_session.sql(sql)

    context: DataContext = great_expectations.get_context(context_root_dir=ge_root_dir)
    yaml.YAML(typ="safe")

    # Datasource spark_iceberg_datasource has been added ago
    runtime_batch_request = RuntimeBatchRequest(
        datasource_name="spark_iceberg_datasource",
        data_connector_name="my_runtime_data_connector",
        data_asset_name=_table_name,
        runtime_parameters={"batch_data": df},
        batch_identifiers={
            "datahub_schema": datahub_schema,
            "datahub_dataset": datahub_dataset,
        },
    )
    results = context.run_checkpoint(
        checkpoint_name=checkpoint_name,
        validations=[
            {"batch_request": runtime_batch_request},
        ],
    )
    print(results)


table_name_full_path = "hadoop_catalog.sdm.s_tft_tsm_t_trade"
data_dt = "20230110"
col_list = ["order_state", "trade_channel"]

table_name = table_name_full_path.split(".")[2]


@dag(
    catchup=False,
    dag_id=f"{table_name}_ge",
    schedule="32 16 * * *",
    start_date=pendulum.datetime(2022, 10, 28, tz="Asia/Shanghai"),
    max_active_runs=1,
    tags=['great_expectation', f'{table_name}']

)
# If Obtain spark session here, spark session would be created by airflow when scanning dags code
# So, dataframe reference must be in a single piece code .
def run_this():
    # Queue only for operator level

    # Fix a bug, for details refer to https://github.com/apache/airflow/issues/27232
    # ExternalPythonOperator.template_fields = tuple({'python'} | set(PythonOperator.template_fields))
    # ExternalPythonOperator(python="/hdp_data/gch/venv/great_expectations/bin/python",
    #                        python_callable=_run_checkpoint,
    #                        task_id=f"{table_name}_ge_task",
    #                        op_kwargs={"table_name": table_name_full_path, "data_dt": data_dt,
    #                                   "col_list": col_list},
    #                        trigger_rule=TriggerRule.ALL_SUCCESS,
    #                        retries=0,
    #                        queue="ge")

    PythonOperator(python_callable=_run_checkpoint,
                   task_id=f"{table_name}_ge_task",
                   op_kwargs={"table_name": table_name_full_path, "data_dt": data_dt,
                              "col_list": col_list},
                   trigger_rule=TriggerRule.ALL_SUCCESS,
                   retries=0,
                   queue="ge")


run_this()

```

