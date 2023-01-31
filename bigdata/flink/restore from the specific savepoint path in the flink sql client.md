Use the command `set execution.checkpointing.interval='6s';` in the sql client to enable the checkpoint mode. 

Reference commands to enable the checkpoint mode:

```
set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';
```

```
[root@flinkdb01 flinksqljob]# flink list

2)web查看job

3、查看JOB的checkpoint

4、cancel JOB

5、从checkpoint恢复
1）查看cancel后的checkpoint
可以看到最后一个checkpoint是：/u01/soft/flink/flinkjob/flinksqljob/checkpoint/f39957c3386e1e943f50ac16d4e3f809/chk-59

2）从最后的checkpoint恢复
配置用于恢复的DML文件

[root@flinkdb01 flinksqljob]# cat myjob-dml-restore
– set sync mode
–SET ‘table.dml-sync’ = ‘true’;

– set the job name
–SET pipeline.name = SqlJob_mysql_result;

– set the queue that the job submit to
–SET ‘yarn.application.queue’ = ‘root’;

– set the job parallism
–SET ‘parallism.default’ = ‘100’;

– restore from the specific savepoint path
SET ‘execution.savepoint.path’ = ‘/u01/soft/flink/flinkjob/flinksqljob/checkpoint/f39957c3386e1e943f50ac16d4e3f809/chk-59’;

–设置savepoint 时间
–set ‘execution.checkpointing.interval’ = ‘2sec’;

insert into mysql_result (id,name,description,weight,company)
select
a.id,
a.name,
a.description,
a.weight,
b.company
from products a
left join company b
on a.id = b.id;

3）恢复job
[root@flinkdb01 flinksqljob]# flinksql -i myjob-ddl -f myjob-dml-restore
No default environment specified.
Searching for ‘/u01/soft/flink/flink-1.13.2/conf/sql-client-defaults.yaml’…not found.
Successfully initialized from sql script: file:/u01/soft/flink/flinkjob/flinksqljob/myjob-ddl
[INFO] Executing SQL from file.
Flink SQL>

SET ‘execution.savepoint.path’ = ‘/u01/soft/flink/flinkjob/flinksqljob/checkpoint/f39957c3386e1e943f50ac16d4e3f809/chk-59’;
[INFO] Session property has been set.
Flink SQL>

insert into mysql_result (id,name,description,weight,company)
select
a.id,
a.name,
a.description,
a.weight,
b.company
from products a
left join company b
on a.id = b.id;
[INFO] Submitting SQL update statement to the cluster…
[INFO] SQL update statement has been successfully submitted to the cluster:
Job ID: f6f481776a2f24fbb9d050ea150e77cf
```


Other settings:

* execution.checkpointing.interval: 5000 ##单位毫秒，checkpoint时间间隔
* state.checkpoints.num-retained: 20 ##单位个，保存checkpoint的个数
* execution.checkpointing.mode: EXACTLY_ONCE
* execution.checkpointing.externalized-checkpoint-retention: RETAIN_ON_CANCELLATION
* state.backend: rocksdb
* state.checkpoints.dir: hdfs:///namenode-host:port/flink-checkpoints
* state.savepoints.dir: hdfs://namenode-host:port/flink-savepoints
* state.backend.incremental: true