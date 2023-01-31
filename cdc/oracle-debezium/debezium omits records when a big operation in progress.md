Debezium may omit records, when a big operation is being in progress.

For example, creating indexes on a big table comprised of 10E records, or importing a huge amount of data by using `impdp` command,
these actions produce too much redo logs(archive logs), may cause debezium connector omits some records.

Solution:  
Before an action like running `impdp` command is taken, debezium connector should be stopped gracefully.
After finished the action, recovers debezium connector.

