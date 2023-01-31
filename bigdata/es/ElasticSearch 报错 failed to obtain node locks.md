failed to obtain node locks, tried [[/var/lib/elasticsearch]] with lock id [0];

错误信息：

failed to obtain node locks, tried [[/var/lib/elasticsearch]] with lock id [0]; maybe these locations are not writable or multiple nodes were started without increasing [node.max_local_storage_nodes]
Elasticsearch version 6.8.2

# 解决方法一：
查找ES进程号，杀掉进程然后重启。

ps -ef | grep elastic
kill -9 进程号

此处查询出来，有两个进程， 都杀掉

# 解决方法二：
给予操作ES的管理员权限，chown -R 用户名:组名 文件目录 

chown -R elastic /var/lib/elasticsearch/

# 解决方法三：
可能是因为安装了ES的插件，修改了配置文件 elasticsearch.yml

将这些注释或删除掉后重启

http.cors.allow-origin: 'http://localhost:1358'
http.cors.enabled: true
http.cors.allow-headers: X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
http.cors.allow-credentials: true