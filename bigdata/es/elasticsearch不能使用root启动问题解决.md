# ����

es��װ��֮��ʹ��root�����ᱨ��can not run elasticsearch as root

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

# ԭ��

Ϊ�˰�ȫ������ʹ��root�û�����

# ���

es5֮��Ķ�����ʹ������������������޸������ļ��ȷ��������ˣ�����Ҫ�����û�

```shell
#1�������û���elasticsearch

[root@iZbp1bb2egi7w0ueys548pZ bin]# adduser elasticsearch
#2�������û����룬��Ҫ��������

[root@iZbp1bb2egi7w0ueys548pZ bin]# passwd elasticsearch
#3������Ӧ���ļ���Ȩ�޸������û�

[root@iZbp1bb2egi7w0ueys548pZ local]# chown -R elasticsearch elasticsearch-6.0.0
#4���л���elasticsearch�û�

[root@iZbp1bb2egi7w0ueys548pZ etc]# su elasticsearch
#5����������Ŀ¼���� /usr/local/elasticsearch-6.0.0/bin  ʹ�ú�̨������ʽ��./elasticsearch -d

[elasticsearch@vmt10003 bin]$ ./elasticsearch -d
#6�����������
#����curl ip:9200,�������һ��json����˵�������ɹ�

```
