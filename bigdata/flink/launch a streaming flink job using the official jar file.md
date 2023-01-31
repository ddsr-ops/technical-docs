nc -l 7779

/opt/flink1.11/flink-1.11.3-cdh6.2/examples/streaming

/opt/flink1.11/flink-1.11.3-cdh6.2/bin/flink run-application -t yarn-application SocketWindowWordCount.jar --hostname 88.88.16.189 --port 7779