datahub delete --platform kafka-connect --entity_type=dataset --hard

datahub delete --platform kafka-connect --entity_type=dataflow --hard # kafka connect pipeline

datahub delete --platform kafka-connect --entity_type=datajob --hard # kafka connect task

datahub delete --platform kafka --hard # delete all data

datahub delete --platform oracle --hard # delete all data

datahub delete --platform oracle --hard -f # delete all data without confirm prompt

[References](https://datahubproject.io/docs/cli#delete)