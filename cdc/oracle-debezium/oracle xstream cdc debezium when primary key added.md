When Debezium plugin engage Xstream engine to capture a table which lacks a primary key,
key of kafka topic would be empty.

In the case, Connector is working, now the captured table was altered due to adding primary key.
Keys of topic will be filled by the added primary key after the table is altered.