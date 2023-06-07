背景：
最近业务方使用Flink SQL 编写任务时用 Mysql 作维表关联时报这个错误
```
FAILED with failure cause: java.lang.RuntimeException: java.lang.ClassCastException: java.math.BigInteger cannot be cast to java.lang.Long
	at org.apache.flink.table.runtime.operators.join.lookup.LookupJoinWithCalcRunner$CalcCollector.collect(LookupJoinWithCalcRunner.java:82)
	at org.apache.flink.table.runtime.operators.join.lookup.LookupJoinWithCalcRunner$CalcCollector.collect(LookupJoinWithCalcRunner.java:69)
	at org.apache.flink.table.runtime.collector.WrappingCollector.outputResult(WrappingCollector.java:39)
	at LookupFunction$16$TableFunctionResultConverterCollector$14.collect(Unknown Source)
	at org.apache.flink.table.functions.TableFunction.collect(TableFunction.java:196)
	at org.apache.flink.connector.nupjdbc.table.NUPJDBCLookupFunction.eval(NUPJDBCLookupFunction.java:170)
	at LookupFunction$16.flatMap(Unknown Source)
	at org.apache.flink.table.runtime.operators.join.lookup.LookupJoinRunner.processElement(LookupJoinRunner.java:81)
	at org.apache.flink.table.runtime.operators.join.lookup.LookupJoinRunner.processElement(LookupJoinRunner.java:34)
	at org.apache.flink.streaming.api.operators.ProcessOperator.processElement(ProcessOperator.java:66)
	at org.apache.flink.streaming.runtime.tasks.CopyingChainingOutput.pushToOperator(CopyingChainingOutput.java:71)
	at org.apache.flink.streaming.runtime.tasks.CopyingChainingOutput.collect(CopyingChainingOutput.java:46)
	at org.apache.flink.streaming.runtime.tasks.CopyingChainingOutput.collect(CopyingChainingOutput.java:26)
	at org.apache.flink.streaming.api.operators.CountingOutput.collect(CountingOutput.java:50)
......
Caused by: java.lang.ClassCastException: java.math.BigInteger cannot be cast to java.lang.Long
	at org.apache.flink.table.data.GenericRowData.getLong(GenericRowData.java:154)
	at TableCalcMapFunction$21.flatMap(Unknown Source)
	at org.apache.flink.table.runtime.operators.join.lookup.LookupJoinWithCalcRunner$CalcCollector.collect(LookupJoinWithCalcRunner.java:80)
	... 31 more
```

问题定位
最开始以为SQL里面那里做了类型转换报错了，后面一看是维表TableSourceScan阶段出现的问题，才想起来我们Flink 1.10升级Flink 1.13后对业务方SQL平滑升级的时候遇到过这个问题，回去看了一下，这个问题产生的原因是：

在维表关联时如果业务方的 mysql 的字段类型定义为 BIGINT，当 mysql 中是 BIGINT UNSIGNED
时，如果用Flink 的BIGINT 去转成 mysql 的 BIGINT UNSIGNED 时会出现上述的报错。在 Flink 1.11
中提出的一个Jira : FLINK-18580 ,官方建议在Flink 的建维表时将 BIGINT 定义为 DECIMAL(20,0)。

回头查看了业务方的Mysql 建表语句，果然定义成了 BIGINT UNSIGNED 类型，那问题就可以解决了：

```
create table opt_live_broadcast_record1 (
-- 这里原来定义成bigint就会出现上面的报错，因为mysql中定义是BIGINT UNSIGNED类型
    id  DECIMAL(20,0),  
    gmv bigint,
    primary key (id) not enforced
)
```