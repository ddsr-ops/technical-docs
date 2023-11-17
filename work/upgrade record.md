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
   *升级数据库前xstream因为无法追齐被删除掉了，所以这条链路是新建的，Xstream.OutBound是新建的*
6. 启动user_core_sync_data，检查是否启动成功
   /opt/cloudera/cm-agent/bin/supervisorctl -c /run/cloudera-scm-agent/supervisor/supervisord.conf start user_core_sync_data
   /opt/cloudera/cm-agent/bin/supervisorctl -c /run/cloudera-scm-agent/supervisor/supervisord.conf status
7. 检查数据
    1. 打开入口后登录 app
    2. 更新用户信息（例如：生日、职业）
    3. 打开user_core_sync_data 日志，查看是否有手机号下“更新用户信息成功”日志
       grep 18011449543 /opt/logs/tft-user-core-sync-data/spring.log
8. 通知升级成功，失败更改uos模块jdbc地址


#### 2023-11-17 TSM DB Patch application

1. 12:05停止f_csm_t_consume_info_micro微批作业，
   等任务 check_tsm_data 过了，停止(delete) kafka connector oracle_tsm_gch/oracle_tsm
2. 升级数据库完成后，调整流池大小
   ALTER SYSTEM SET streams_pool_size = 8G SCOPE = BOTH SID = '*';
3. 启动Connector任务oracle_tsm, 不启动oracle_tsm_gch，检查Topic数据（不用启动Xstream，库启动后Xstream进程会自动拉起，如果无法拉起？）  
   ```sql
   -- All relevant Xstream session,  6 in total
   SELECT /*+PARAM('_module_action_old_length',0)*/inst_id, ACTION,
   SID,
   SERIAL#,
   PROCESS,
   SUBSTR(PROGRAM,INSTR(PROGRAM,'(')+1,4) PROCESS_NAME
   FROM GV$SESSION
   WHERE MODULE ='XStream';
   ```
   查询Xstream相关进程没被自动拉起，被自动拉起后进程数应为5  
   先启动connector任务，如果Xstream相关进程仍然没被自动拉起，则使用以下PLSQL命令启动Xstream相关进程
   ```sql
   BEGIN
   DBMS_XSTREAM_ADM.ALTER_OUTBOUND(
   server_name  => 'dbzxout',
   connect_user => 'xstream_user');
   END;
   /
   -- start the capture process if not started, capture name from ALL_CAPTURE
   BEGIN
   dbms_capture_adm.start_capture('CAP$_DBZXOUT_10');
   END;
   /
   ```
4. 观察streaming程序消费情况，待kafka数据消费完毕
5. 启动f_csm_t_consume_info_micro微批作业，观察入表情况