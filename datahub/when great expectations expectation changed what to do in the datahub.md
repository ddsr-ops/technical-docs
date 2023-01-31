https://docs.greatexpectations.io/docs/guides/expectations/data_assistants/how_to_create_an_expectation_suite_with_the_onboarding_data_assistant

The Onboarding Data Assistant will create as many applicable Expectations as it can for the permitted columns. This provides a solid base for analyzing your data, but may exceed your needs. It is also possible that you may possess some domain knowledge that is not reflected in the data that was sampled for the Profiling process. In either of these (or any other) cases, you can edit your Expectation Suite to more closely suite your needs.

If you have not modified the expectation json file and run the checkpoint with the old expectation, 
assertion results are emitted into the datahub platform with redundant assertions.
Yeah, here, I directly edit expectation json file in the project directory, such as `/hdp_data/gch/venv/great_expectations/great_expectations/expectations/hadoop_catalog_sdm_s_tft_tsm_t_trade.json`.
I removed some assertions which are rarely needed in the expectation json file. Now, running the checkpoint will succeed but assertions result bar in the validations tab show incorrectly.

# How to resolve it?

Delete all assertions related to the entity in the datahub platform. Running the checkpoint with the new expectation again will generate and render correct assertions result details in the Validation tab.  