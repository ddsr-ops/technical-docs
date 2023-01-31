insert into msx_online.debezium_signal values('ad-hoc-1', 'execute-snapshot', '{"data-collections": ["msx_online.user_base"],"type":"incremental"}');

```text
[2023-01-05 09:39:18,108] ERROR Producer failure (io.debezium.pipeline.ErrorHandler:35)
io.debezium.DebeziumException: Error processing binlog event
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleEvent(MySqlStreamingChangeEventSource.java:402)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$execute$25(MySqlStreamingChangeEventSource.java:909)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.notifyEventListeners(BinaryLogClient.java:1125)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.listenForEventPackets(BinaryLogClient.java:973)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.connect(BinaryLogClient.java:599)
	at com.github.shyiko.mysql.binlog.BinaryLogClient$7.run(BinaryLogClient.java:857)
	at java.lang.Thread.run(Thread.java:748)
Caused by: org.apache.kafka.connect.errors.ConnectException: Error while processing event at offset {transaction_id=null, ts_sec=1672882757, file=mysql_bin.000108, pos=691265940, incremental_snapshot_maximum_key=aced000570, row=1, server_id=1, event=2, incremental_snapshot_collections=msx_online.user_base, incremental_snapshot_primary_key=aced000570}
	at io.debezium.pipeline.EventDispatcher.dispatchDataChangeEvent(EventDispatcher.java:254)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$handleInsert$4(MySqlStreamingChangeEventSource.java:732)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleChange(MySqlStreamingChangeEventSource.java:790)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleInsert(MySqlStreamingChangeEventSource.java:730)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$execute$16(MySqlStreamingChangeEventSource.java:885)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleEvent(MySqlStreamingChangeEventSource.java:382)
	... 6 more
Caused by: io.debezium.DebeziumException: Database error while executing incremental snapshot for table 'msx_online.user_base'
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.readChunk(AbstractIncrementalSnapshotChangeEventSource.java:332)
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.addDataCollectionNamesToSnapshot(AbstractIncrementalSnapshotChangeEventSource.java:418)
	at io.debezium.pipeline.signal.ExecuteSnapshot.arrived(ExecuteSnapshot.java:57)
	at io.debezium.pipeline.signal.Signal.process(Signal.java:135)
	at io.debezium.pipeline.signal.Signal.process(Signal.java:173)
	at io.debezium.pipeline.EventDispatcher$2.changeRecord(EventDispatcher.java:228)
	at io.debezium.relational.RelationalChangeRecordEmitter.emitCreateRecord(RelationalChangeRecordEmitter.java:79)
	at io.debezium.relational.RelationalChangeRecordEmitter.emitChangeRecords(RelationalChangeRecordEmitter.java:47)
	at io.debezium.pipeline.EventDispatcher.dispatchDataChangeEvent(EventDispatcher.java:217)
	... 11 more
Caused by: java.sql.SQLNonTransientConnectionException: No operations allowed after connection closed.
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:110)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:89)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:63)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:73)
	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:73)
	at com.mysql.cj.jdbc.ConnectionImpl.setSessionMaxRows(ConnectionImpl.java:2428)
	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:369)
	at io.debezium.jdbc.JdbcConnection.prepareUpdate(JdbcConnection.java:765)
	at io.debezium.pipeline.source.snapshot.incremental.SignalBasedIncrementalSnapshotChangeEventSource.emitWindowOpen(SignalBasedIncrementalSnapshotChangeEventSource.java:59)
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.readChunk(AbstractIncrementalSnapshotChangeEventSource.java:281)
	... 19 more
Caused by: com.mysql.cj.exceptions.ConnectionIsClosedException: No operations allowed after connection closed.
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:61)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:105)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:151)
	at com.mysql.cj.NativeSession.checkClosed(NativeSession.java:762)
	at com.mysql.cj.jdbc.ConnectionImpl.checkClosed(ConnectionImpl.java:569)
	at com.mysql.cj.jdbc.ConnectionImpl.setSessionMaxRows(ConnectionImpl.java:2421)
	... 23 more
[2023-01-05 09:39:18,148] INFO Error processing binlog event, and propagating to Kafka Connect so it stops this connector. Future binlog events read before connector is shutdown will be ignored. (io.debezium.connector.mysql.MySqlStreamingChangeEventSource:407)
[2023-01-05 09:39:18,285] INFO WorkerSourceTask{id=mysql_msx-0} Committing offsets (org.apache.kafka.connect.runtime.WorkerSourceTask:478)
[2023-01-05 09:39:18,285] INFO WorkerSourceTask{id=mysql_msx-0} flushing 0 outstanding messages for offset commit (org.apache.kafka.connect.runtime.WorkerSourceTask:495)
[2023-01-05 09:39:18,289] INFO WorkerSourceTask{id=mysql_msx-0} Finished commitOffsets successfully in 4 ms (org.apache.kafka.connect.runtime.WorkerSourceTask:574)
[2023-01-05 09:39:18,289] ERROR WorkerSourceTask{id=mysql_msx-0} Task threw an uncaught and unrecoverable exception. Task is being killed and will not recover until manually restarted (org.apache.kafka.connect.runtime.WorkerTask:187)
org.apache.kafka.connect.errors.ConnectException: An exception occurred in the change event producer. This connector will be stopped.
	at io.debezium.pipeline.ErrorHandler.setProducerThrowable(ErrorHandler.java:50)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleEvent(MySqlStreamingChangeEventSource.java:402)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$execute$25(MySqlStreamingChangeEventSource.java:909)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.notifyEventListeners(BinaryLogClient.java:1125)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.listenForEventPackets(BinaryLogClient.java:973)
	at com.github.shyiko.mysql.binlog.BinaryLogClient.connect(BinaryLogClient.java:599)
	at com.github.shyiko.mysql.binlog.BinaryLogClient$7.run(BinaryLogClient.java:857)
	at java.lang.Thread.run(Thread.java:748)
Caused by: io.debezium.DebeziumException: Error processing binlog event
	... 7 more
Caused by: org.apache.kafka.connect.errors.ConnectException: Error while processing event at offset {transaction_id=null, ts_sec=1672882757, file=mysql_bin.000108, pos=691265940, incremental_snapshot_maximum_key=aced000570, row=1, server_id=1, event=2, incremental_snapshot_collections=msx_online.user_base, incremental_snapshot_primary_key=aced000570}
	at io.debezium.pipeline.EventDispatcher.dispatchDataChangeEvent(EventDispatcher.java:254)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$handleInsert$4(MySqlStreamingChangeEventSource.java:732)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleChange(MySqlStreamingChangeEventSource.java:790)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleInsert(MySqlStreamingChangeEventSource.java:730)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.lambda$execute$16(MySqlStreamingChangeEventSource.java:885)
	at io.debezium.connector.mysql.MySqlStreamingChangeEventSource.handleEvent(MySqlStreamingChangeEventSource.java:382)
	... 6 more
Caused by: io.debezium.DebeziumException: Database error while executing incremental snapshot for table 'msx_online.user_base'
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.readChunk(AbstractIncrementalSnapshotChangeEventSource.java:332)
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.addDataCollectionNamesToSnapshot(AbstractIncrementalSnapshotChangeEventSource.java:418)
	at io.debezium.pipeline.signal.ExecuteSnapshot.arrived(ExecuteSnapshot.java:57)
	at io.debezium.pipeline.signal.Signal.process(Signal.java:135)
	at io.debezium.pipeline.signal.Signal.process(Signal.java:173)
	at io.debezium.pipeline.EventDispatcher$2.changeRecord(EventDispatcher.java:228)
	at io.debezium.relational.RelationalChangeRecordEmitter.emitCreateRecord(RelationalChangeRecordEmitter.java:79)
	at io.debezium.relational.RelationalChangeRecordEmitter.emitChangeRecords(RelationalChangeRecordEmitter.java:47)
	at io.debezium.pipeline.EventDispatcher.dispatchDataChangeEvent(EventDispatcher.java:217)
	... 11 more
Caused by: java.sql.SQLNonTransientConnectionException: No operations allowed after connection closed.
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:110)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:89)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:63)
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:73)
	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:73)
	at com.mysql.cj.jdbc.ConnectionImpl.setSessionMaxRows(ConnectionImpl.java:2428)
	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:369)
	at io.debezium.jdbc.JdbcConnection.prepareUpdate(JdbcConnection.java:765)
	at io.debezium.pipeline.source.snapshot.incremental.SignalBasedIncrementalSnapshotChangeEventSource.emitWindowOpen(SignalBasedIncrementalSnapshotChangeEventSource.java:59)
	at io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource.readChunk(AbstractIncrementalSnapshotChangeEventSource.java:281)
	... 19 more
Caused by: com.mysql.cj.exceptions.ConnectionIsClosedException: No operations allowed after connection closed.
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:61)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:105)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:151)
	at com.mysql.cj.NativeSession.checkClosed(NativeSession.java:762)
	at com.mysql.cj.jdbc.ConnectionImpl.checkClosed(ConnectionImpl.java:569)
	at com.mysql.cj.jdbc.ConnectionImpl.setSessionMaxRows(ConnectionImpl.java:2421)
	... 23 more
```

When the above errors occur, connector task need to be restarted.
Of course, you can restart connector tasks before issuing incremental snapshot.

```shell
curl -X POST datanode4:8083/connectors/mysql_msx/tasks/0/restart
```

Note: I look for relevant problems in the [forum](https://issues.redhat.com/projects/DBZ/issues), but nothing can`t be found.
