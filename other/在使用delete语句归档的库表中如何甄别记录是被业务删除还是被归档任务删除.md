通常情况下， 在业务库中，使用DML或DDL语句对过期数据删除或移动至归档库，达到减少业务库数据存储体量，
维持数据库平稳的服务能力。

但是，当业务发生了delete动作，同时归档任务发起了delete语句，如何在cdc数据流中友好准确地甄别delete语句
由谁发起，这便影响下游作业如何处理这部分数据。

todo: how to handle rows which are archived
When finished archiving data, someone or program delete some rows which locate in the archived data. 
They want to remove the rows solidly, but the rows have already been archived and saved, which may influence
the quality of model relevant to the rows.

设计cdc总线中过滤归档产生的event逻辑，裁剪下游作业加工量
todo：scripts to handle rows that op is 'd' in the layer sdm bwt , then tftactdb
solution: build a cdc streaming road on the archive databases, then ingest data into iceberg or starrocks.
Keep the data(from archive databases) for a certain long time, such as 2 days,  data from production databases join the relevant data
from archive database to remove the data has been archived.

当前采取的措施：  
就归档数据引入数仓裁剪下游作业计算数据量的问题进行讨论，以表名为依据分类处理”删除数据“，归档表过滤掉操作类型为删除的数据，
不向下游传递这部分数据，非归档表不过滤操作类型为删除的数据，向下游传递这部分数据，下游表根据情况进行删除或合并