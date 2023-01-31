# 问题

es安装好之后，使用root启动会报错：can not run elasticsearch as root

```shell
[root@iZbp1bb2egi7w0ueys548pZ bin]# ./elasticsearch
[2019-01-21T09:50:59,387][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [] uncaught exception in thread [main]
org.elasticsearch.bootstrap.StartupException: java.lang.RuntimeException: can not run elasticsearch as root
    at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:134) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:121) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:69) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:134) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.cli.Command.main(Command.java:90) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:92) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:85) ~[elasticsearch-6.0.0.jar:6.0.0]
Caused by: java.lang.RuntimeException: can not run elasticsearch as root
    at org.elasticsearch.bootstrap.Bootstrap.initializeNatives(Bootstrap.java:104) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:171) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:322) ~[elasticsearch-6.0.0.jar:6.0.0]
    at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:130) ~[elasticsearch-6.0.0.jar:6.0.0]
    ... 6 more
```

# 原因

为了安全不允许使用root用户启动

# 解决

es5之后的都不能使用添加启动参数或者修改配置文件等方法启动了，必须要创建用户

```shell
#1、创建用户：elasticsearch

[root@iZbp1bb2egi7w0ueys548pZ bin]# adduser elasticsearch
#2、创建用户密码，需要输入两次

[root@iZbp1bb2egi7w0ueys548pZ bin]# passwd elasticsearch
#3、将对应的文件夹权限赋给该用户

[root@iZbp1bb2egi7w0ueys548pZ local]# chown -R elasticsearch elasticsearch-6.0.0
#4、切换至elasticsearch用户

[root@iZbp1bb2egi7w0ueys548pZ etc]# su elasticsearch
#5、进入启动目录启动 /usr/local/elasticsearch-6.0.0/bin  使用后台启动方式：./elasticsearch -d

[elasticsearch@vmt10003 bin]$ ./elasticsearch -d
#6、启动后测试
#输入curl ip:9200,如果返回一个json数据说明启动成功

```
