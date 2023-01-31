����Kafka Connect����ͼ���Է���ķ�ʽȥ���У��������ṩ��RESTAPIȥ����connectors��
Ĭ�ϵĶ˿���8083������Ҳ����������Kafka Connect֮ǰ�������ļ������rest.port���ã�

* GET /connectors�����������������е�connector��
* POST /connectors���½�һ��connector�������������json��ʽ������Ҫ����name�ֶκ�config�ֶΣ�name��connector�����֣�config��json��ʽ������������connector��������Ϣ��
* GET /connectors/{name}����ȡָ��connetor����Ϣ
* GET /connectors/{name}/config����ȡָ��connector��������Ϣ
* PUT /connectors/{name}/config������ָ��connector��������Ϣ
* GET /connectors/{name}/status����ȡָ��connector��״̬���������Ƿ������С�ֹͣ������ʧ�ܣ�����������󣬻����г�����ľ�����Ϣ��
* GET /connectors/{name}/tasks����ȡָ��connector�������е�task��
* GET /connectors/{name}/tasks/{taskid}/status����ȡָ��connector��task��״̬��Ϣ
* PUT /connectors/{name}/pause����ͣconnector������task��ֹͣ���ݴ���ֱ�������ָ���
  ��oracle��˵����paused, ���ھ����񲻻�ֹͣ����ֹͣд�����ݵ�kafka��resume����д�룩
* PUT /connectors/{name}/resume���ָ�һ������ͣ��connector
* POST /connectors/{name}/restart��������һ��connector����������һ��connector����ʧ�ܵ�����±Ƚϳ���
* POST /connectors/{name}/tasks/{taskId}/restart��������һ��task��һ������Ϊ������ʧ�ܲ���������
* DELETE /connectors/{name}��ɾ��һ��connector��ֹͣ��������task��ɾ�����á�


[fail to restart kafka connector](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=181308623)

ͨ����˵��Connectorʧ����Ҫ������Connector���µ�Taskʧ�ܡ��������Taskʧ�ܣ�ʹ��/connectors/{name}/tasks/{taskId}/restart�ӿ�
���������ɻָ���

һ����˵�� ����Connector���Ƽ�ʹ��DELETE���½�����ʽ����������Connectorʵ������Task��

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