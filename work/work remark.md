* **MILESTONE** 
* **NOTABLE DETAILS**
***************************************************************************************************************************************************************************************************
es scripting, lang - painless

DataX/core/src/main/java/com/alibaba/datax/core/transport/channel/Channel.java

todo: check sdm and dictionary table to judge whether new dict value appears, essential to notify us via sms?  
checked it, but there are some codes in sql statements and no notification to us.  

sql audit : yearning, soar, sql advisor, sqlE

operation and maintenance management platform : spug

todo: new features of maxscale 

https://www.runoob.com/w3cnote/java-annotation.html

[gc log](https://www.cnblogs.com/wuzhenzhao/p/12486840.html)

场景：在集中某段时间内，某表发生的集中操作， 当天内不再有后续操作， 在cdc情况下，如何判断该表写入完毕。 

在当天的时间范围内，spark metrics表批次时间为spark streaming同批内数据的时间，该时间是一致的。首先判断对应表的metrics是否存在，存在则取出max时间；
下一步取出metrics表中该数据库实例下的所有表的max时间，如果该max时间大于上一步的max时间，则判定该表写入完毕。

按当天每批次一小时计，如果spark metrics表中最大批次时间 - 某表最大批次时间 > 1(or 2), 则认定该表写入完毕。

todo: ingest griffin result to visualize in the grafana.
If great_expectations will be engaged to manage data quality, griffin could be deprecated.
GE job running overview

todo: 凡影响生产流水线的复杂脚本，上线前需经过测试和脚本审计，大家看下pipeline如何制定合适？不拘泥于形式，但过程必须有。

2月工作计划：
1. 完成Kafka集群的迁移方案制定，并完成迁移
2. 完成服务器主机资源监控，纳入Grafana管理
3. 推进老年卡年审人脸比对，包括开发计划、照片采集策略
4. 设计StarRocks内部ETL血缘信息采集架构

smart eyes:   
https://my2ylp9qe3.feishu.cn/sheets/shtcnnbIqeW2swlRIAiORPywuOw

https://www.it610.com/article/1297799168231809024.htm

[利用jemalloc解决flink的内存溢出问题](https://blog.csdn.net/Deepexi_Date/article/details/125396199)
todo: flink 1.11.3 job no metrics, consider upgrading flink version

https://www.cnblogs.com/huxi2b/p/6223228.html

https://www.astronomer.io/blog/apache-nifi-vs-airflow/

Specify the worker to special tasks : https://blog.csdn.net/doublezsx/article/details/125065994 

1. Supply a dummy data
2. Estimate how long to work around it  

https://www.processon.com/view/6347c6f57d9c080c4253287d?fromnew=1

Dictionary built in the log mining session, session use it track the schema evolution . 
If not enable DDL tracking before DDL events occur, some relevant DML events can not be recognized appropriately.

Grafana Mimir
Scalable, long-term storage for Prometheus, Influx, Graphite, and Datadog metrics

todo: check one source, one destination, three etls 

todo: need quality check of adm layer

https://juejin.cn/post/7096426868848459806

https://blog.csdn.net/xingxingmingyue/article/details/121204715
https://blog.csdn.net/xingxingmingyue/article/details/121680210

https://help.aliyun.com/document_detail/253392.html
https://wiki.ubuntu.com/Kernel/Reference/stress-ng
https://blog.csdn.net/weixin_43991475/article/details/124980475

https://blog.csdn.net/lovetechlovelife/article/details/112471839

Todo: ingest StarRocks metadata and profile ?

during 00:00-00:15 every morning, `UPDATE DC_USER_DIS_CARD_RESTRICT T SET T.DAY_USE_TIMES = 0`
Fix has been done, but not published.

1. 撰写GE操作说明文档质量规则上线部署部分
2. 针对已审阅的Kafka集群迁移方案，整理整改意见
3. 调研GE Action的定制开发，以便打通异常度量结果的告警通路
4. 恢复研发、测试环境的数据库服务

todo: GE结果能顺利投递至DATAHUB中，但是失败和成功的度量结果展示密集后，不可见, BooleanTimeline.tsx
一般来说， 短时间内，多次投递度量结果在度量结果上可能存在显示不友好，不利于阅读。

config_with_defaults ships correct action_list, but instantiate SimpleCheckPoint with config_with_defaults which returns default action_list
excluding user customized actions

observed_value field in the result object is customized for this expectation to be a float representing the proportion of unique values in the column

done: whether stg, sdm layer data arrive

done: tasks take occupation of pool parallelism for long time

done: mechanism to check which tasks run for too long time and not run at the scheduled time

https://github.com/apache/airflow/issues/27232, manually fixed it in the prod env.

datahub.action && sqllineage==1.3.6

configurator.py in the GE && custom_actions.py located at Plugin dir

https://airflow.apache.org/docs/apache-airflow/stable/concepts/timetable.html#
https://airflow.apache.org/docs/apache-airflow/stable/faq.html#faq-what-does-execution-date-mean
https://airflow.apache.org/docs/apache-airflow/stable/templates-ref.html#templates-variables

[spark decimal type can not be profile](https://github.com/great-expectations/great_expectations/issues/6393)

The government's first concern was to augment(o) the army and auxiliary forces.

[Kafka MirrorMaker](https://www.cnblogs.com/felixzh/p/11508192.html)

https://github.com/didi/KnowStreaming

todo: **Star product**

January，February，March，April，May，June，July，August，September，October，November，December

https://github.com/open-falcon/falcon-plus

todo: (column) lineage, doris lineage ?

https://blog.csdn.net/woloqun/article/details/128649833

https://juejin.cn/post/7169910747810496543

https://blog.csdn.net/weixin_39894473/article/details/112076395?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-112076395-blog-51308695.pc_relevant_3mothn_strategy_and_data_recovery&spm=1001.2101.3001.4242.1&utm_relevant_index=3

Inner dataset lineage:

Flume1 on FE1    ----\
Flume2 on FE2    ----\
Flume3 on FE3    ----> One topic In kafka ----> Flink(Py) ----> DATAHUB
Flume4 on FE4    ----/
......           ----/

todo: kafka schema and connect schema

https://www.cnblogs.com/shanfeng1000/p/14691301.html

done: make three dashboards to get overview infos of separated clusters,
hadoop cluster(including spark), flink cluster, starrocks and kafka cluster?  

Yeah, three clusters are divided into three jobs which job names might be specified by cluster name other than 'node_exporter' 

todo: metro mlc diff analysis, deadline date: 2023-02-24

todo: nfc trade status evolution <<< prerequisites

1、地铁MLC差异分析程序在新清算的配置和上线，因CSR
2、Kafka及Kafka Connect元数据摄入数据治理平台，Ingestion rollback存在异常，官方尚未解决
3、推进GE量产工作, TSM数据库
4、参与个人统计信息收集V1.0.0数据库审计
5、复审APP6.1.0数据库操作

mysql_tftactdb_master  - provided_configs, refer to kafka_connect_to_file.yml

1. Database configuration and get real time of frms to be online
2. Let liuyi explain what script of GE to make
3. nfc trade status evolution <<< prerequisites
4. doris --> starrocks, they serve together ? incremental migration

todo: Migrate flink jobs

Deploy software on SSD disk?

todo: Wi-Fi of original home 

todo: knowstreaming

todo: review database manipulation of 6.3 

when rollback kafka or kafka-connect ingestion, some problems appear, refer to https://github.com/datahub-project/datahub/issues/6733. 