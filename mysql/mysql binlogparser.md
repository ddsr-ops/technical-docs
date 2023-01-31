```
$ ./binlogparser -p log/mysql-bin.000024 -c 1
----------------------EVENT-------------------
HEADER
	timestamp: 1573737597 (2019-11-14 13:19:57 +0000 UTC)
	event_type: FORMAT_DESCRIPTION_EVENT
	server_id: 1
	event_size: 119
	log_pos: 123
	flags: 0
PAYLOAD
	binlog_version: 0
	mysql_server_version: 5.7.25-0ubuntu0.16.04.2-log
	create_timestamp: 0
	event_header_length: 0
	event_type_header_length: [56 13 0 8 0 18 0 4 4 4 4 18 0 0 95 0 4 26 8 0 0 0 8 8 8 2 0 0 0 10 10 10 42 42 0 18 52 0]
```


[binlogparser source](https://github.com/chenjianlong/mysql-toolset/tree/master/cmd/binlog-parser)