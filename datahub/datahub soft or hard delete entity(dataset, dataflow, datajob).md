datahub delete --platform kafka-connect --entity_type=dataset --hard

datahub delete --platform kafka-connect --entity_type=dataflow --hard # kafka connect pipeline

datahub delete --platform kafka-connect --entity_type=datajob --hard # kafka connect task

[References](https://datahubproject.io/docs/cli#delete)