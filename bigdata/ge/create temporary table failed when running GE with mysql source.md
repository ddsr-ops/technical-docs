batch_request = RuntimeBatchRequest(
    datasource_name="my_mysql_datasource",
    data_connector_name="default_runtime_data_connector_name",
    data_asset_name="default_name",  # this can be anything that identifies this data
    runtime_parameters={"query": "SELECT * from msx_online.user_base"},
    batch_identifiers={"default_identifier_name": "default_identifier"},
    batch_spec_passthrough={"create_temp_table": False}  # Inhibit create temporary table action
)
context.create_expectation_suite(
    expectation_suite_name="test_suite", overwrite_existing=True
)
validator = context.get_validator(
    batch_request=batch_request, expectation_suite_name="test_suite"
)
print(validator.head())

[Reference](https://github.com/great-expectations/great_expectations/issues/4168)
