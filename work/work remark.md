* **MILESTONE** 
* **NOTABLE DETAILS**
***************************************************************************************************************************************************************************************************
sql audit : yearning, soar, sql advisor, sqlE

[ProxySQL + Failover](https://proxysql.com/documentation/Frequently-Asked-Questions/)
https://www.percona.com/blog/failover-mysql-utilities-part1-mysqlrpladmin/

https://zq99299.github.io/note-book/back-end-storage/
https://www.runoob.com/w3cnote/java-annotation.html

[gc log](https://www.cnblogs.com/wuzhenzhao/p/12486840.html)

https://www.it610.com/article/1297799168231809024.htm

https://www.cnblogs.com/huxi2b/p/6223228.html

https://www.astronomer.io/blog/apache-nifi-vs-airflow/

Specify the worker to special tasks : https://blog.csdn.net/doublezsx/article/details/125065994 

https://www.processon.com/view/6347c6f57d9c080c4253287d?fromnew=1

https://juejin.cn/post/7096426868848459806

https://blog.csdn.net/xingxingmingyue/article/details/121204715
https://blog.csdn.net/xingxingmingyue/article/details/121680210

https://help.aliyun.com/document_detail/253392.html
https://wiki.ubuntu.com/Kernel/Reference/stress-ng
https://blog.csdn.net/weixin_43991475/article/details/124980475

https://blog.csdn.net/lovetechlovelife/article/details/112471839

observed_value field in the result object is customized for this expectation to be a float representing the proportion of unique values in the column

https://github.com/apache/airflow/issues/27232, manually fixed it in the prod env.

https://airflow.apache.org/docs/apache-airflow/stable/concepts/timetable.html#
https://airflow.apache.org/docs/apache-airflow/stable/faq.html#faq-what-does-execution-date-mean
https://airflow.apache.org/docs/apache-airflow/stable/templates-ref.html#templates-variables

https://github.com/didi/KnowStreaming

todo: **Star product**

https://github.com/open-falcon/falcon-plus

todo: doris metadata, (column) lineage, doris inner lineage ?
todo: lineage from iceberg to doris

https://blog.csdn.net/woloqun/article/details/128649833
https://blog.csdn.net/woloqun/article/details/128478981
https://blog.csdn.net/woloqun/article/details/104670976#comments_25056764
https://blog.csdn.net/qq_31866793/article/details/115719358?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-115719358-blog-104670976.pc_relevant_recovery_v2&spm=1001.2101.3001.4242.1&utm_relevant_index=3

> data-lineage-doris open source project

when rollback kafka or kafka-connect ingestion, some problems appear, refer to https://github.com/datahub-project/datahub/issues/6733 

Yeah, three clusters are divided into three jobs which job names might be specified by cluster name other than 'node_exporter'

Infrastructure
doris m / flink rs m + u / iceberg u / spark un-upgrade / 

Governance
great expectation on iceberg , on doris?
lineage across multiple platforms: spark / doris / kafka / flink 
job lineage via airflow 

Spring boot / redis / ES / flink / datahub contributor / numpy pandas

https://www.geeksforgeeks.org/python-intersection-two-lists/

https://docs.oracle.com/en/database/oracle/oracle-database/21/stxjv/oracle/streams/XStreamOut.html

https://github.com/eugenp/tutorials
https://www.v2ex.com/t/901763

https://issues.redhat.com/browse/DBZ-6373
https://issues.redhat.com/browse/DBZ-6334

In PROD env, ts_ms in SourceInfo is wrong when using LogMiner engine, but ok in TEST env due to using fixed jar.
In PROD env, fixed Jars have been uploaded the destination directory named `/opt/kafka*/connector/`. It will apply immediately if connector cluster is restarted

PMM monitoring and management tool for MySQL/PG/MongoDB cooperated by Percona

TODO: HA capability for MySQL

https://zhuanlan.zhihu.com/p/395273289
https://juejin.cn/post/6889704993889189896

https://github.com/fatdba/Oracle-Database-Scripts

TODO: the case that pk updated in the Debezium, diagnose but can not resolve it.
> TODO: After xstream bugs are fixed, add some debug logs in the section of io.debezium.connector.oracle.logminer.parser.LogMinerDmlParser#parseUpdate. As for whether the dml events are logged,  it is determined by io.debezium.connector.oracle.logminer.processor.AbstractLogMinerEventProcessor#handleCommit
> Relevant methods:
> * io.debezium.relational.RelationalChangeRecordEmitter#emitUpdateRecord, emits delete and re-insert events if pk updated
> * io.debezium.pipeline.EventDispatcher.StreamingChangeRecordReceiver#changeRecord emitTombstonesOnDelete judgement and construct SourceRecord
> Finally, CDC engine for Oracle will be reverted to LogMiner 

https://github.com/jeff-zou/flink-connector-redis

TODO: restart d1~d5 machines to modify deployment mode of disk

GE: Not return column types of MySQL when using create_temp_table option set to false
> https://github.com/great-expectations/great_expectations/issues/7593
> relevant files in 189 and local files for debugging are modified. 

[Error when running an expectation with create_temp_table is set to False](https://github.com/great-expectations/great_expectations/issues/8325)
> simultaneously upgrade PyMySQL 1.1.0 SQLAlchemy 1.4.49

seatunnel BitSail kettle datafan(web based on kettle) LarkMidTable(data platform) sqlbuilder

[big data technology](https://github.com/fancyChuan/bigdata-hub)

https://segmentfault.com/a/1190000022521844

https://github.com/alibaba/druid/wiki/Druid_SQL_AST
https://github.com/JupiterMouse/data-lineage-parent

https://github.com/zhisheng17/flink-learning

Source(Rest/Kafka) --> Engine --> Sink(Datahub/Neo4j/Rest/Kafka)

todo: there are still slow queries in the bwt database, a small transaction with one dml statement.
because innodb can not flush dirty pages instantly, the only thing to take is decrease the data to write


todo: otest has a report , swingbench

https://www.percona.com/software/documentation

https://cloud.tencent.com/developer/article/1054463

ob or tidb certification 

todo: remove row_number functions

https://www.v2ex.com/t/814568

https://tech.meituan.com/2017/06/09/maze-framework.html

https://www.percona.com/blog/online-ddl-tools-and-metadata-locks/
https://cloud.tencent.com/developer/article/1671012


todo: a plan of publishing tftactdb process job

https://github.com/bersler/OpenLogReplicator

todo: seamless toggle to switch between batch and micro batch