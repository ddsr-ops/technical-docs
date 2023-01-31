[reference](https://dev.mysql.com/doc/refman/5.6/en/replication-gtids-concepts.html)

17.1.3.1 GTID Concepts
A global transaction identifier (GTID) is a unique identifier created and associated with each transaction committed on the server of origin (source). This identifier is unique not only to the server on which it originated, but is unique across all servers in a given replication setup. There is a 1-to-1 mapping between all transactions and all GTIDs.

A GTID is represented as a pair of coordinates, separated by a colon character (:), as shown here:
```
GTID = source_id:transaction_id
```
The source_id identifies the originating server. Normally, the server's server_uuid is used for this purpose. The transaction_id is a sequence number determined by the order in which the transaction was committed on this server; for example, the first transaction to be committed has 1 as its transaction_id, and the tenth transaction to be committed on the same originating server is assigned a transaction_id of 10. It is not possible for a transaction to have 0 as a sequence number in a GTID. For example, the twenty-third transaction to be committed originally on the server with the UUID 3E11FA47-71CA-11E1-9E33-C80AA9429562 has this GTID:

```
3E11FA47-71CA-11E1-9E33-C80AA9429562:23
```
This format is used to represent GTIDs in the output of statements such as SHOW SLAVE STATUS as well as in the binary log. They can also be seen when viewing the log file with mysqlbinlog --base64-output=DECODE-ROWS or in the output from SHOW BINLOG EVENTS.

As written in the output of statements such as SHOW MASTER STATUS or SHOW SLAVE STATUS, a sequence of GTIDs originating from the same server may be collapsed into a single expression, as shown here.

```
3E11FA47-71CA-11E1-9E33-C80AA9429562:1-5
```
The example just shown represents the first through fifth transactions originating on the MySQL Server whose server_uuid is 3E11FA47-71CA-11E1-9E33-C80AA9429562.

In MySQL 5.6.6 and later, this format is also used to supply the argument required by the START SLAVE options SQL_BEFORE_GTIDS and SQL_AFTER_GTIDS.

GTID Sets
A GTID set is a set of global transaction identifiers which is represented as shown here:

```
gtid_set:
    uuid_set [, uuid_set] ...
    | ''

uuid_set:
    uuid:interval[:interval]...

uuid:
    hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh

h:
    [0-9|A-F]

interval:
    n[-n]

    (n >= 1)
```

GTID sets are used in the MySQL Server in several ways. For example, the values stored by the gtid_executed and gtid_purged system variables are represented as GTID sets. In addition, the functions GTID_SUBSET() and GTID_SUBTRACT() require GTID sets as input.

GTIDs are always preserved between source and replica. This means that you can always determine the source for any transaction applied on any replica by examining its binary log. In addition, once a transaction with a given GTID is committed on a given server, any subsequent transaction having the same GTID is ignored by that server. Thus, a transaction committed on the source can be applied no more than once on the replica, which helps to guarantee consistency.

When GTIDs are in use, the replica has no need for any nonlocal data, such as the name of a file on the source and a position within that file. All necessary information for synchronizing with the source is obtained directly from the replication data stream. From the perspective of the database administrator or developer, GTIDs entirely take the place of the file-offset pairs previously required to determine points for starting, stopping, or resuming the flow of data between source and replica. This means that, when you are using GTIDs for replication, you do not need (or want) to include MASTER_LOG_FILE or MASTER_LOG_POS options in the CHANGE MASTER TO statement used to direct a replica to replicate from a given source; in place of these options, it is necessary only to enable the MASTER_AUTO_POSITION option introduced in MySQL 5.6.5. For the exact steps needed to configure and start sources and replicas using GTID-based replication, see Section 17.1.3.2, ¡°Setting Up Replication Using GTIDs¡±.

The generation and lifecycle of a GTID consists of the following steps:

1. A transaction is executed and committed on the source.

    This transaction is assigned a GTID using the source's UUID and the smallest nonzero transaction sequence number not yet used on this server; the GTID is written to the source's binary log (immediately preceding the transaction itself in the log).

2. After the binary log data is transmitted to the replica and stored in the replica's relay log (using established mechanisms for this process¡ªsee Section 17.2, ¡°Replication Implementation¡±, for details), the replica reads the GTID and sets the value of its gtid_next system variable as this GTID. This tells the replica that the next transaction must be logged using this GTID.

    The replica sets gtid_next in a session context.

3. The replica checks to make sure that this GTID has not already been used to log a transaction in its own binary log. If and only if this GTID has not been used, the replica then writes the GTID and applies the transaction (and writes the transaction to its binary log). By reading and checking the transaction's GTID first, before processing the transaction itself, the replica guarantees not only that no previous transaction having this GTID has been applied on the replica, but also that no other session has already read this GTID but has not yet committed the associated transaction. In other words, multiple clients are not permitted to apply the same transaction concurrently.

4. Because gtid_next is not empty, the replica does not attempt to generate a GTID for this transaction but instead writes the GTID stored in this variable, that is, the GTID obtained from the source, immediately preceding the transaction in its binary log.