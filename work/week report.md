1、完成编写数据湖SDM层BWT的度量标准及度量作业，并发布成功
2、开发Oracle字典构建组件，应对运维DBA不按照规范变更元数据
3、使用PythonExternalOp组件部署Oracle字典构建组件， 开发完成待部署上线
4、复现Oracle CDC组件将Update事件识别成Delete时间，因无法复现目前尚未找到原因；提交官方Issue，官方反馈让使用最新版复现问题
5、重新配置tft-bigdata-monitor服务，解决kafka url错误问题

1、在生产环境发布Oracle字典构建组件，每天凌晨执行一次构建，发布完成
2、探索其他方式构建Oracle CDC通路（Xstream）：完成在测试环境的验证，正在进行在生产环境的验证 
3、跟踪已上线BWT的度量作业，并根据错误进行修复

1. 在生产环境部署以Xstream为引擎的Oracle CDC链路，与旧链路并行
2. 在1的基础上，跟进T_TRADE_INFO的数据情况，形成新链路是否可行的结论