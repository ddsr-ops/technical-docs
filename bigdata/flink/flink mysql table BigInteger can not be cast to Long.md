������
���ҵ��ʹ��Flink SQL ��д����ʱ�� Mysql ��ά�����ʱ���������
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

���ⶨλ
�ʼ��ΪSQL����������������ת�������ˣ�����һ����ά��TableSourceScan�׶γ��ֵ����⣬������������Flink 1.10����Flink 1.13���ҵ��SQLƽ��������ʱ��������������⣬��ȥ����һ�£�������������ԭ���ǣ�

��ά�����ʱ���ҵ�񷽵� mysql ���ֶ����Ͷ���Ϊ BIGINT���� mysql ���� BIGINT UNSIGNED
ʱ�������Flink ��BIGINT ȥת�� mysql �� BIGINT UNSIGNED ʱ����������ı����� Flink 1.11
�������һ��Jira : FLINK-18580 ,�ٷ�������Flink �Ľ�ά��ʱ�� BIGINT ����Ϊ DECIMAL(20,0)��

��ͷ�鿴��ҵ�񷽵�Mysql ������䣬��Ȼ������� BIGINT UNSIGNED ���ͣ�������Ϳ��Խ���ˣ�

```
create table opt_live_broadcast_record1 (
-- ����ԭ�������bigint�ͻ��������ı�����Ϊmysql�ж�����BIGINT UNSIGNED����
    id  DECIMAL(20,0),  
    gmv bigint,
    primary key (id) not enforced
)
```