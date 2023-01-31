# log_slave_updates
```
Command-Line Format	--log-slave-updates[={OFF|ON}]
System Variable	log_slave_updates
Scope	Global
Dynamic	No
Type	Boolean
Default Value	OFF
```

Whether updates received by a replica from a replication source server should be logged to the replica's own binary log.

Normally, a replica does not log to its own binary log any updates that are received from a source. Enabling this variable causes the replica to write the updates performed by its replication SQL thread to its own binary log. For this option to have any effect, the replica must also be started with the --log-bin option to enable binary logging. See Section 2.4, ¡°Replication and Binary Logging Options and Variables¡±. A warning is issued if you enable log_slave_updates without also starting the server with the --log-bin option.

log_slave_updates is enabled when you want to chain replication servers. For example, you might want to set up replication servers using this arrangement:

> A -> B -> C

Here, A serves as the source for the replica B, and B serves as the source for the replica C. For this to work, B must be both a source and a replica. You must start both A and B with --log-bin to enable binary logging, and B with log_slave_updates enabled so that updates received from A are logged by B to its binary log.

Updates in binlog file of server A also would be logged in binlog file of server B.