1. 完成编写数据湖SDM层BWT的度量标准及度量作业，并发布成功
2. 开发Oracle字典构建组件，应对运维DBA不按照规范变更元数据
3. 使用PythonExternalOp组件部署Oracle字典构建组件， 开发完成待部署上线
4. 复现Oracle CDC组件将Update事件识别成Delete时间，因无法复现目前尚未找到原因；提交官方Issue，官方反馈让使用最新版复现问题
5. 重新配置tft-bigdata-monitor服务，解决kafka url错误问题


1. 在生产环境发布Oracle字典构建组件，每天凌晨执行一次构建，发布完成
2. 探索其他方式构建Oracle CDC通路（Xstream）：完成在测试环境的验证，正在进行在生产环境的验证 
3. 跟踪已上线BWT的度量作业，并根据错误进行修复


1. 在生产环境部署以Xstream为引擎的Oracle CDC链路，与旧链路并行
2. 在1的基础上，跟进T_TRADE_INFO的数据情况，形成新链路是否可行的结论: 可行
3. Xstream为引擎的Oracle CDC链路，完美解决以LogMiner为引擎的链路将U事件识别为D事件的问题
4. 解决Oracle CDC链路中Shrink table partition失败的问题
5. 改造Oracle CDC新Jar中的时区问题，包括Date/Timestamp/TimestampTZ
6. 完善上述改造的测试工作，并解决其中遇到的TimestampTZ字段引起的ORA-26824问题

2023-05-04
1、基于上周就Oracle CDC的技术调研，形成是否替换线上链路的结论
2、初步编写Oracle CDC新老链路切换预案，基于生产环境的切换方案还需完善
3、参与并完成商户中心1.0数据库审计工作
4、经与使用Oracle CDC数据的相干同事沟通，不建议在白天进行链路切换

2023-05-08
1、就Oracle CDC链路现状进行汇报，完善基于生产环境的新老链路切换预案
2、继续推进数据湖SDM层的质量检核工作
3、调研Flink/Iceberg/Spark各组件的版本兼容性，以Iceberg版本为基础
4、配合运维处理账户系统数据库重启，维稳CDC总线
5、解决Oracle CDC总线解析Index Partition Shrink DDL语句失败的问题
6、撰写账户系统跑批作业迁移初步方案

