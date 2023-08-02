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
1. 基于上周就Oracle CDC的技术调研，形成是否替换线上链路的结论
2. 初步编写Oracle CDC新老链路切换预案，基于生产环境的切换方案还需完善
3. 参与并完成商户中心1.0数据库审计工作
4. 经与使用Oracle CDC数据的相干同事沟通，不建议在白天进行链路切换

2023-05-08
1. 就Oracle CDC链路现状进行汇报，完善基于生产环境的新老链路切换预案
2. 继续推进数据湖SDM层的质量检核工作
3. 调研Flink/Iceberg/Spark各组件的版本兼容性，以Iceberg版本为基础
4. 配合运维处理账户系统数据库重启，维稳CDC总线
5. 解决Oracle CDC总线解析Index Partition Shrink DDL语句失败的问题
6. 撰写账户系统跑批作业迁移初步方案

2023-05-15
1. 按照Oracle CDC新老链路切换方案，在生产环境完成切换作业
2. 继续推进数据湖SDM层的质量检核工作
3. 诊断MySQL CDC插件升级后无法连接MySQL的问题，在2.3版本中手动禁止database.ssl.mode模式即解决问题
4. 参与支付宝外籍人士乘车相关数据库操作文档审计
5. 诊断Oracle CDC 2.3高额占用cpu使用率的问题

2023-05-22
1. 继续诊断Oracle CDC 2.3高额占用cpu使用率的问题，发现是parallelStream方法造成的，
   打上patch后在生产环境发布完成
2. 针对新版Oracle Xstream CDC链路，重新设计Grafana Dashboard和alert策略
3. 将tft-bigdata-monitor服务拆分成告警服务和短信服务，已分别完成部署

2023-05-29
1. 跟进新版LogMiner CDC链路的漏数问题，仍然存在漏数、错数的问题
2. 解决LogMiner CDC链路SourceInfo的ts_ms的时区问题，已解决未发布
3. 调整grafana alert for oracle策略， 当前策略过于敏感；将检查窗口5分钟调整至10分钟
4. 结合会议内容， 补充账户系统方案，尤其数据跑批和稽核的范围圈定，如有必要，则需做数据底层的调研
5. 校验新老用户系统部分存量数据，筛选不一致数据用于修复
6. 初步制定账户系统跑批作业的开发计划

2023-06-05
1. 与社区共同跟进新版LogMiner CDC链路的漏数/错数问题，社区无反馈；在研发环境Debug无法复现问题
2. 测试Xstream更改First_SCN，以应对会话重启后无法正确读取SCN的问题，可通过此方式绕开Oracle Bug；当前运维部门正着力进行Oracle PSU升级测试，为解决此Bug和应对扫描检查做准备
3. 根据账户系统跑批作业需求分析，对账户系统CDC链路进行调整，脚本已调整完毕，拟下周一进行正式环境的调整
4. 参与审计看看租车1.0.6数据库操作部分

2023-06-12
1. 测试expdp/impdp工具对Oracle Xstream链路的影响，如果目标表在被捕获列表内，则通过impdp导入的数据将被Xstream捕获，正常的expdp/impdp对CDC链路无影响
2. 跟进Oracle PSU的测试情况，了解该PSU是否具备上线的条件，单机Oracle已具备PSU上线条件，运维正在准备RAC集群
3. 协助搭建MySQL测试环境，临时挪用Flink节点的机器用于搭建测试MySQL
4. 参与审计农行数币公交卡的数据库初审和复审
5. 分析TSM Streaming程序异常原因，并对已发现问题提出后续处理办法
6. 修改既有GE运行作业的接收告警信息的手机号码

2023-06-25
1. 跟进Oracle PSU升级在RAC模式下的测试情况，升级及回退测试均通过
2. 迁移tft-bigdata-monitor监控服务至新机器，并进行自愈测试，测试进行中
3. * 升级余额处理Flink程序的依赖至Flink1.16.1
4. 改善余额处理Flink程序中的数据版本控制器，解决同个账户在数据更新时间一致情况下，数据版本可能混乱的问题，未进行
5. 处理fxq cdc链路中断问题，使其暂时恢复数据处理
6. 升级大数据环境机器的动态口令验证，更替为手机电子口令
7. 根据已提供的规则，与老系统比对新用户系统数据
8. 改造tft-bigdata-monitor监控服务，使其具备在特定服务器执行特定shell的能力
9. 配合运维DBA打Xstream小补丁，观测cdc链路情况

2023-07-03
1. 继续测试tft-bigdata-monitor监控程序，择机发布
2. 在测试环境复现Oracle CDC无法推进的问题，并在PSU应用后进行回归测试
3. 配合运维DBA打Xstream小补丁，观测cdc链路情况：问题没有被解决，反而愈加严重
4. 配合对UPS数据库进行PSU升级，升级完成后恢复相应CDC链路

2023-07-10
1. 配合对FXQ数据库进行PSU升级，升级完成后恢复相应CDC链路
2. 继续测试tft-bigdata-monitor监控程序，完成在生产环境的发布
3. 升级余额处理Flink程序的依赖至Flink1.16.1，完成测试
4. 增加生产环境ConnectDistributed集群的内存
5. 修复TSM CDC中断的问题，废弃schema.include.list，启用table.include.list

2023-07-17
1. 完成tft-bigdata-monitor监控程序发布
2. 完成配合清结算业务将旧Doris切向新的Doris数据库
3. 停用旧Doris后，调整Spark资源池
4. 完善数据湖SDM层的数据质量治理
5. 解决bwt相关dataset在kafka connect上下文中无法映射的问题，但对于分片的dataset无法完成映射
6. 完成GE从0.15升级至0.17，旨在解决Spark中无法计算Decimal类型的字段

2023-07-24
1. 预计周三停用旧Doris后，释放Hadoop硬件资源，增加Spark资源池
2. 完成解决GE升级至0.17后的部分环境问题，如本地执行checkpoint报import module错误
3. 继续完善数据湖SDM层的数据质量治理，推进剩余部分
4. 完成公交SAAS报表SQL审计，给出审计意见
5. 协助比对新老用户系统数据，按照要求给出具体差异数据
6. 抽取b_order数据，按照要求拼接装载至b_user_credit表的SQL脚本
7. 在GE质量组件与Doris兼容适配过程中，发现缺陷8325，导致质检无法继续进行，待官方修复

2023-07-31
1. 缓慢移除旧Doris数据库的数据，避免对集群其他组件造成影响
2. 跟进数据湖SDM层的数据质量治理处理进度，并完善剩余部分
3. 完成构建聚合支付MySQL数据库CDC链路，接入数据湖SDM层
4. 暂缓GE质量组件与Doris兼容适配，但仍需跟进社区对8325问题处理情况
5. 在Datahub数据源集成中，预研如何摄入Doris元数据，包括表、视图

2023-08-07
