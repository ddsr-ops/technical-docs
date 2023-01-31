由于Kafka Connect的意图是以服务的方式去运行，所以它提供了RESTAPI去管理connectors，
默认的端口是8083（我们也可以在启动Kafka Connect之前在配置文件中添加rest.port配置）

* GET /connectors：返回所有正在运行的connector名
* POST /connectors：新建一个connector；请求体必须是json格式并且需要包含name字段和config字段，name是connector的名字，config是json格式，必须包含你的connector的配置信息。
* GET /connectors/{name}：获取指定connetor的信息
* GET /connectors/{name}/config：获取指定connector的配置信息
* PUT /connectors/{name}/config：更新指定connector的配置信息
* GET /connectors/{name}/status：获取指定connector的状态，包括它是否在运行、停止、或者失败，如果发生错误，还会列出错误的具体信息。
* GET /connectors/{name}/tasks：获取指定connector正在运行的task。
* GET /connectors/{name}/tasks/{taskid}/status：获取指定connector的task的状态信息
* PUT /connectors/{name}/pause：暂停connector和它的task，停止数据处理直到它被恢复；
  对oracle来说，虽paused, 但挖掘任务不会停止，仅停止写入数据到kafka（resume即可写入）
* PUT /connectors/{name}/resume：恢复一个被暂停的connector
* POST /connectors/{name}/restart：仅重启一个connector，尤其是在一个connector运行失败的情况下比较常用
* POST /connectors/{name}/tasks/{taskId}/restart：仅重启一个task，一般是因为它运行失败才这样做。
* DELETE /connectors/{name}：删除一个connector，停止它的所有task并删除配置。


[fail to restart kafka connector](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=181308623)

通常来说，Connector失败主要表现在Connector其下的Task失败。如果仅是Task失败，使用/connectors/{name}/tasks/{taskId}/restart接口
重启任务便可恢复。

一般来说， 重启Connector，推荐使用DELETE后新建的形式，彻底重启Connector实例及其Task。

```
[root@namenode1 connector-json]# ./get_all_connector_status.sh 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    43  100    43    0     0   6790      0 --:--:-- --:--:-- --:--:--  7166
{"name":"oracle_ups","connector":{"state":"RUNNING","worker_id":"10.50.253.7:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.7:8084"}],"type":"source"}
{"name":"oracle_tftfxq","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.6:8085"}],"type":"source"}
{"name":"oracle_tsm","connector":{"state":"UNASSIGNED","worker_id":"10.50.253.7:8084"},"tasks":[{"id":0,"state":"FAILED","worker_id":"10.50.253.7:8084","trace":"org.apache.kafka.connect.errors.ConnectException: OffsetStorageWriter is already flushing\n\tat org.apache.kafka.connect.storage.OffsetStorageWriter.beginFlush(OffsetStorageWriter.java:111)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.commitOffsets(WorkerSourceTask.java:490)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.execute(WorkerSourceTask.java:274)\n\tat org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:185)\n\tat org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:234)\n\tat java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)\n\tat java.util.concurrent.FutureTask.run(FutureTask.java:266)\n\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\n\tat java.lang.Thread.run(Thread.java:748)\n"}],"type":"source"}
[root@namenode1 connector-json]# curl -X POST http://namenode1:8085/connectors/oracle_tsm/restart 
[root@namenode1 connector-json]# ./get_all_connector_status.sh 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    43  100    43    0     0   6211      0 --:--:-- --:--:-- --:--:--  7166
{"name":"oracle_ups","connector":{"state":"RUNNING","worker_id":"10.50.253.7:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.7:8084"}],"type":"source"}
{"name":"oracle_tftfxq","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.6:8085"}],"type":"source"}
{"name":"oracle_tsm","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"FAILED","worker_id":"10.50.253.7:8084","trace":"org.apache.kafka.connect.errors.ConnectException: OffsetStorageWriter is already flushing\n\tat org.apache.kafka.connect.storage.OffsetStorageWriter.beginFlush(OffsetStorageWriter.java:111)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.commitOffsets(WorkerSourceTask.java:490)\n\tat org.apache.kafka.connect.runtime.WorkerSourceTask.execute(WorkerSourceTask.java:274)\n\tat org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:185)\n\tat org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:234)\n\tat java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)\n\tat java.util.concurrent.FutureTask.run(FutureTask.java:266)\n\tat java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)\n\tat java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)\n\tat java.lang.Thread.run(Thread.java:748)\n"}],"type":"source"}
[root@namenode1 connector-json]# curl -X POST http://namenode1:8085/connectors/oracle_tsm/tasks/0/restart 
[root@namenode1 connector-json]# ./get_all_connector_status.sh 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    43  100    43    0     0   4159      0 --:--:-- --:--:-- --:--:--  4300
{"name":"oracle_ups","connector":{"state":"RUNNING","worker_id":"10.50.253.7:8084"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.7:8084"}],"type":"source"}
{"name":"oracle_tftfxq","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.6:8085"}],"type":"source"}
{"name":"oracle_tsm","connector":{"state":"RUNNING","worker_id":"10.50.253.6:8085"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"10.50.253.6:8085"}],"type":"source"}
```