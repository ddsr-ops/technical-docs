```python
import great_expectations as ge
from great_expectations.cli.datasource import sanitize_yaml_and_save_datasource, check_if_datasource_name_exists
context = ge.get_context()

datasource_name = "my_datasource"

example_yaml = f"""
name: {datasource_name}
class_name: Datasource
execution_engine:
  class_name: SparkDFExecutionEngine
data_connectors:
  default_inferred_data_connector_name:
    class_name: InferredAssetFilesystemDataConnector
    base_directory: ..\data
    default_regex:
      group_names:
        - data_asset_name
      pattern: (.*)
  default_runtime_data_connector_name:
    class_name: RuntimeDataConnector
    assets:
      my_runtime_asset_name:
        batch_identifiers:
          - runtime_batch_identifier_name
"""

context.test_yaml_config(yaml_config=example_yaml)

sanitize_yaml_and_save_datasource(context, example_yaml, overwrite_existing=True)
context.list_datasources()

import datetime

import pandas as pd

import great_expectations as ge
import great_expectations.jupyter_ux
from great_expectations.core.batch import BatchRequest
from great_expectations.checkpoint import SimpleCheckpoint
from great_expectations.exceptions import DataContextError

context = ge.data_context.DataContext()

batch_request = {'datasource_name': 'my_datasource', 'data_connector_name': 'default_inferred_data_connector_name', 'data_asset_name': 'yellow_tripdata_sample_2019-01.csv', 'limit': 1000}

expectation_suite_name = "getting_started_expectation_suite_taxi.demo"

validator = context.get_validator(
    batch_request=BatchRequest(**batch_request),
    expectation_suite_name=expectation_suite_name
)
column_names = [f'"{column_name}"' for column_name in validator.columns()]
print(f"Columns: {', '.join(column_names)}.")
validator.head(n_rows=5, fetch_all=False)


exclude_column_names = [
    "_c0",
    "_c1",
    "_c2",
    "_c3",
    "_c4",
    "_c5",
    "_c6",
    "_c7",
    #"_c8",
    "_c9",
    "_c10",
    "_c11",
    "_c12",
    "_c13",
    "_c14",
    "_c15",
    "_c16",
    "_c17",
]


result = context.assistants.onboarding.run(
    batch_request=batch_request,
    exclude_column_names=exclude_column_names,
)
validator.expectation_suite = result.get_expectation_suite(
    expectation_suite_name=expectation_suite_name
)

print(validator.get_expectation_suite(discard_failed_expectations=False))
validator.save_expectation_suite(discard_failed_expectations=False)

checkpoint_config = {
    "class_name": "SimpleCheckpoint",
    "validations": [
        {
            "batch_request": batch_request,
            "expectation_suite_name": expectation_suite_name
        }
    ]
}
checkpoint = SimpleCheckpoint(
    f"{validator.active_batch_definition.data_asset_name}_{expectation_suite_name}",
    context,
    **checkpoint_config
)
checkpoint_result = checkpoint.run()

context.build_data_docs()

validation_result_identifier = checkpoint_result.list_validation_result_identifiers()[0]
context.open_data_docs(resource_identifier=validation_result_identifier)

from ruamel.yaml import YAML
import great_expectations as ge
from pprint import pprint

yaml = YAML()
context = ge.get_context()


my_checkpoint_name = "getting_started_checkpoint" # This was populated from your CLI command.

yaml_config = f"""
name: {my_checkpoint_name}
config_version: 1.0
class_name: SimpleCheckpoint
run_name_template: "%Y%m%d-%H%M%S-my-run-name-template"
validations:
  - batch_request:
      datasource_name: my_datasource
      data_connector_name: default_inferred_data_connector_name
      data_asset_name: yellow_tripdata_sample_2019-02.csv
      data_connector_query:
        index: -1
    expectation_suite_name: getting_started_expectation_suite_taxi.demo
"""
print(yaml_config)

# Run this cell to print out the names of your Datasources, Data Connectors and Data Assets
pprint(context.get_available_data_asset_names())

context.list_expectation_suite_names()

my_checkpoint = context.test_yaml_config(yaml_config=yaml_config)

print(my_checkpoint.get_config(mode="yaml"))

context.add_checkpoint(**yaml.load(yaml_config))


context.run_checkpoint(checkpoint_name=my_checkpoint_name)
context.open_data_docs()
```