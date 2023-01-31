消费位点提交 #
Kafka source 在 checkpoint 完成时提交当前的消费位点 ，以保证 Flink 的 checkpoint 状态和 Kafka broker 上的提交位点一致。
如果未开启 checkpoint，Kafka source 依赖于 Kafka consumer 内部的位点定时自动提交逻辑，
自动提交功能由 enable.auto.commit 和 auto.commit.interval.ms 两个 Kafka consumer 配置项进行配置。

注意：Kafka source 不依赖于 broker 上提交的位点来恢复失败的作业。
提交位点只是为了上报 Kafka consumer 和消费组的消费进度，以在 broker 端进行监控。

在flink1.15中，如果没有开启checkpoint，则不会生成cg(consumer group id), 使用`set execution.checkpointing.interval='10s'`开启checkpoint。
无cg的情况下，下次启动作业，无法从上次提交点位继续消费。