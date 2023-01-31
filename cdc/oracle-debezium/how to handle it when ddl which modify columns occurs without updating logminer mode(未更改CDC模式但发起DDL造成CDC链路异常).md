When DBA modify table columns issuing the following statements without updating logminer mode, CDC road was interrupted.

```sql
Alter TABLE T_ACT_TRADE_DETAIL modify CHAR_CHAN varchar2(6);
Alter TABLE T_ACT_TRADE_DETAIL modify PASSAGE_WAY varchar2(6);
```

```text
{"name":"oracle_tsm","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"FAILED","worker_id":"10.50.253.6:8085","trace":"org.apache.kafka.connect.errors.ConnectException: An exception occurred in the change event producer. This connector will be stopped.\n\tat io.debezium.pipeline.ErrorHandler.setProducerThrowable(ErrorHandler.java:42)\n\tat io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource.execute(LogMinerStreamingChangeEventSource.java:258)\n\tat io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource.execute(LogMinerStreamingChangeEventSource.java:55)\n\tat io.debezium.pipeline.ChangeEventSourceCoordinator.streamEvents(ChangeEventSourceCoordinator.java:172)\n\tat io.debezium.pipeline.ChangeEventSourceCoordinator.executeChangeEventSources(ChangeEventSourceCoordinator.java:139)\n\tat io.debezium.pipeline.ChangeEventSourceCoordinator.lambda$start$0(ChangeEventSourceCoordinator.java:108)\n\tat java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)\n\tat java.util.concurrent.FutureTask.run(FutureTask.java:266)\n\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\n\tat java.lang.Thread.run(Thread.java:748)\nCaused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed. Please open a Jira issue with the statement 'insert into \"TFT_TSM\".\"T_ACT_TRADE_DETAIL\"(\"COL 1\",\"COL 2\",\"COL 3\",\"COL 4\",\"COL 5\",\"COL 6\",\"COL 7\",\"COL 8\",\"COL 9\",\"COL 10\",\"COL 11\",\"COL 12\",\"COL 13\",\"COL 14\",\"COL 15\",\"COL 16\",\"COL 17\",\"COL 18\",\"COL 19\",\"COL 20\",\"COL 21\") values (HEXTORAW('3230323231313038313433353033323233303932'),HEXTORAW('32333033323537363330363731383732'),HEXTORAW('41353130313230313830303030303332'),HEXTORAW('37323432373532333434363838363430'),HEXTORAW('37303838313031373432363135353532'),HEXTORAW('3132323032323131303831343335303332323
```

Modifying columns is different from adding columns, refer to <Conquer DML statements unparsed when some DDLs happen in the oracle connector.md>
for details.

Here, Mock DDL events to emit to connector history topic , it not works.

Some actions are taken:

1. Delete connector via kafka restful api

2. Remove T_ACT_TRADE_DETAIL table from "table.include.list" and "message.key.columns"

3. Re-create the connector using above modified configuration

4. Until the connector has gone through the DDL events , add the T_ACT_TRADE_DETAIL to "table.include.list" and "message.key.columns"
to re-create the connector
   
5. Look for records related to the table T_ACT_TRADE_DETAIL via select statement to emit them to the destination kafka topic(op_mode is 'r')

Note: as for select statement, `select * from table where update_time >= ? and update_time < ?` 