java.lang.IllegalStateException: No current assignment for partition xxx.xxx.xxx

原因：同时启动两个消费Kafka的应用程序，出现同一个消费者组在同一时刻多次消费同一个 topic，引发 offset 记录问题。

解决：排查是否存在多个使用相同group id的消费同一topic的的程序