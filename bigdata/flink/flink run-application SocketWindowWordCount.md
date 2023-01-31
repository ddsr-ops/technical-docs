nc -l 11992


/opt/flink1.11/flink-1.11.3-cdh6.2/bin/flink run-application -t yarn-application \
-Djobmanager.memory.process.size=2048m \
-Dtaskmanager.memory.process.size=4096m \
-Dclassloader.resolve-order="parent-first" \
-Dexecution.checkpointing.interval='6s' \
-Drestart-strategy.fixed-delay.attempts=3 \
-Drestart-strategy.fixed-delay.delay='10s' \
/opt/flink1.11/flink-1.11.3-cdh6.2/examples/streaming/SocketWindowWordCount.jar --port 11992 --hostname 88.88.16.189

Must enable checkpoint mode, restart strategy can take effects.

/opt/flink1.11/flink-1.11.3-cdh6.2/bin/flink run-application -t yarn-application \
-Djobmanager.memory.process.size=2048m \
-Dtaskmanager.memory.process.size=4096m \
-Dclassloader.resolve-order="parent-first" \
/opt/flink1.11/flink-1.11.3-cdh6.2/examples/streaming/SocketWindowWordCount.jar --port 11992 --hostname 88.88.16.189