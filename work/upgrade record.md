#### 2023-10-20 FXQ DB Patch application

1. 关闭入口 关闭user_core_sync_data
   /opt/cloudera/cm-agent/bin/supervisorctl -c /run/cloudera-scm-agent/supervisor/supervisord.conf stop user_core_sync_data
2. 迁移Flink程序
    * 停止监控
    * 页面上停止老Flink
    * update bigdata_monitor.t_bigdata_service_item set app_start_shell = '/opt/flink-1.16.1/bin/flink run-application -t yarn-application -Dyarn.application.name=act_balance_redis  -Djobmanager.memory.process.size=2048m -Dtaskmanager.memory.process.size=2048m -Dclassloader.resolve-order=parent-first --allowNonRestoredState  hdfs:///flink_new/main_jars/tft-flink-act-balance.jar -flink.profile.active=prod', app_start_host='flink1' where id = 16;
    * 启动监控，启动短信
    * 观察是否正常启动，UI界面是否消费数据，日志正常否
3. 升级数据库完成后
   ALTER SYSTEM SET streams_pool_size = 8G SCOPE = BOTH SID = '*';
4. 检查SQL执行计划
5. 启动FXQ CDC链路(启动Xstream，再启动Connect)，检查Topic名称及数据，恢复fxq alerter
6. 启动user_core_sync_data，检查是否启动成功
   /opt/cloudera/cm-agent/bin/supervisorctl -c /run/cloudera-scm-agent/supervisor/supervisord.conf start user_core_sync_data
   /opt/cloudera/cm-agent/bin/supervisorctl -c /run/cloudera-scm-agent/supervisor/supervisord.conf status
7. 检查数据
    1. 打开入口后登录 app
    2. 更新用户信息（例如：生日、职业）
    3. 打开user_core_sync_data 日志，查看是否有手机号下“更新用户信息成功”日志
       grep 18011449543 /opt/logs/tft-user-core-sync-data/spring.log
8. 通知升级成功，失败更改uos模块jdbc地址