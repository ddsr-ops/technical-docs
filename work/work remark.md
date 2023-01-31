* **MILESTONE** 
* **NOTABLE DETAILS**

datahub roadmap中，明确表示支持三大数据湖  

***************************************************************************************************************************************************************************************************
es scripting, lang - painless

DataX/core/src/main/java/com/alibaba/datax/core/transport/channel/Channel.java

ENV: batch and streaming, metadata, data quality
todo: (column) lineage, doris lineage ?  

todo: check sdm and dictionary table to judge whether new dict value appears, essential to notify us via sms?  
checked it, but there are some codes in sql statements and no notification to us.  

sql audit : yearning, soar, sql advisor, sqlE

operation and maintenance management platform : spug

在既有的github url前面添加`https://github.91chi.fun/`实现加速克隆

todo: new features of maxscale 

column lineage is accessible via datahub api, but invisible in ui. 

https://www.runoob.com/w3cnote/java-annotation.html

[gc log](https://www.cnblogs.com/wuzhenzhao/p/12486840.html)

场景：在集中某段时间内，某表发生的集中操作， 当天内不再有后续操作， 在cdc情况下，如何判断该表写入完毕。 

在当天的时间范围内，spark metrics表批次时间为spark streaming同批内数据的时间，该时间是一致的。首先判断对应表的metrics是否存在，存在则取出max时间；
下一步取出metrics表中该数据库实例下的所有表的max时间，如果该max时间大于上一步的max时间，则判定该表写入完毕。

按当天每批次一小时计，如果spark metrics表中最大批次时间 - 某表最大批次时间 > 1(or 2), 则认定该表写入完毕。

todo: ingest griffin result to visualize in the grafana.
If great_expectations will be engaged to manage data quality, griffin could be deprecated.

todo: engage supervisor to manage doris or starrocks processes.

todo: 凡影响生产流水线的复杂脚本，上线前需经过测试和脚本审计，大家看下pipeline如何制定合适？不拘泥于形式，但过程必须有。

1月工作计划：
1. 完成年度账单数据跑批和数据上线工作
2. 推进实时数仓的硬件服务器的验收工作，尤其是网络部分回归测试
3. 配合新用户系统的上线工作
4. 交行隐私计算：① 需要再补一次数据求交，扩大匹配量级；② 第二阶段联合建模。
5. 推进唯品富邦消金联合建模（金融贷款营销模型）


smart eyes:   
https://my2ylp9qe3.feishu.cn/sheets/shtcnnbIqeW2swlRIAiORPywuOw

https://www.it610.com/article/1297799168231809024.htm

[利用jemalloc解决flink的内存溢出问题](https://blog.csdn.net/Deepexi_Date/article/details/125396199)
todo: flink 1.11.3 job no metrics

https://www.cnblogs.com/huxi2b/p/6223228.html

down to the bottom fo development

https://www.astronomer.io/blog/apache-nifi-vs-airflow/

Specify the worker to special tasks : https://blog.csdn.net/doublezsx/article/details/125065994 

1. Supply a dummy data
2. Estimate how long to work around it  

annual bill: 2022/12/12	2022/12/27, test start on 2023-01-04  

https://www.processon.com/view/6347c6f57d9c080c4253287d?fromnew=1

Dictionary built in the log mining session, session use it track the schema evolution . 
If not enable DDL tracking before DDL events occur, some relevant DML events can not be recognized appropriately.

Grafana Mimir
Scalable, long-term storage for Prometheus, Influx, Graphite, and Datadog metrics

todo: check one source, one destination, three etls 

todo: need quality check of adm layer

todo: what to do with GE
1. local files merge? can not be merged
2. on which airflow node ge jobs run
3. engage python operator to run ge jobs
4. dags(solved) and ge work directory

https://juejin.cn/post/7096426868848459806

https://blog.csdn.net/xingxingmingyue/article/details/121204715
https://blog.csdn.net/xingxingmingyue/article/details/121680210

https://help.aliyun.com/document_detail/253392.html
https://wiki.ubuntu.com/Kernel/Reference/stress-ng
https://blog.csdn.net/weixin_43991475/article/details/124980475

https://blog.csdn.net/lovetechlovelife/article/details/112471839

todo: inet speed, StarRocks server net speed abnormal

Todo: ingest StarRocks metadata and profile ?

system setting permanently

每日凌晨00:00-00:15, `UPDATE DC_USER_DIS_CARD_RESTRICT T SET T.DAY_USE_TIMES = 0`

source /root/airflow_env/bin/activate  
airflow celery worker -c 6 -q ge -D  
airflow celery stop

create expectation suite >> profile >> add checkpoint >> dag file creation

1. 完成GE与Airflow的ExternalPythonOperator的集成测试，可以正常集成
2. 调整DAG工程目录结构，利于IDE开发，顶级目录下增加etls/great_expectations/tools等目录
3. 撰写GE操作说明文档生成度量规则部分
4. 审阅Kafka集群迁移方案


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

configurator.py in the GE

https://airflow.apache.org/docs/apache-airflow/stable/concepts/timetable.html#
https://airflow.apache.org/docs/apache-airflow/stable/faq.html#faq-what-does-execution-date-mean
https://airflow.apache.org/docs/apache-airflow/stable/templates-ref.html#templates-variables

[spark decimal type can not be profile](https://github.com/great-expectations/great_expectations/issues/6393)

The government's first concern was to augment(o) the army and auxiliary forces.

[Kafka MirrorMaker](https://www.cnblogs.com/felixzh/p/11508192.html)

https://github.com/didi/KnowStreaming

todo: **Star product**

producers --> kafka cluster --> consumers  
connectors                      ss, flink, java programs

todo: 151 network card