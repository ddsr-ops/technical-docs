oracle cdc entrance  - io.debezium.pipeline.ChangeEventSourceCoordinator#streamEvents - io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource#execute

Q: test when using log.mining.strategy with online_catalog, see whether to decrease archive log number, 
  and whether cdc includes data of which schema has changed.
  
A: When table structure has changed, in the case, connector will block since it can not parse DML.  