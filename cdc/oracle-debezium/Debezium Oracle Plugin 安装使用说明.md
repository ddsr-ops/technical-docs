# 目标

说明Oracle CDC的部署，不含插件包的部署。

# 部署说明

部署请求体：
```json
{
  "connector.class": "io.debezium.connector.oracle.OracleConnector",
  "message.key.columns": "logminer.log_mining_config:connector_name;tft_ups.cp_activity_issue:activity_issue_id;tft_ups.cp_award:award_id;tft_ups.cp_coupon:coupon_id;tft_ups.cp_coupon_issue:coupon_issue_id;tft_ups.cp_coupon_issue_coupon_list:coupon_issue_coupon_id;tft_ups.cp_coupon_package_detail:coupon_package_detail_id;tft_ups.cp_coupon_package_download:coupon_package_download_id;tft_ups.cp_coupon_package_issue:coupon_package_issue_id;tft_ups.cp_coupon_package_issue_list:coupon_package_issue_list_id;tft_ups.cp_coupon_product:coupon_product_id;tft_ups.cp_coupon_template:coupon_temp_id;tft_ups.cp_issue:issue_id;tft_ups.cp_my_coupon:receive_id;tft_ups.cp_outside_issue:outside_issue_id;tft_ups.cp_outside_issue_package_d:outside_issue_package_id;tft_ups.cp_prize:prize_id;tft_ups.cp_product_package_detail:product_package_detail_id;tft_ups.dc_act_discount_card:id;tft_ups.dc_discount_card:id;tft_ups.dc_discount_card_hold_rec:id;tft_ups.dc_discount_card_list:id;tft_ups.dc_orient_discount_card:id;tft_ups.dc_sell_discount_card:id;tft_ups.dc_trip_order:order_no;tft_ups.dc_user_dis_card_restrict:id;tft_wallet.account_info:account_id,is_delete,user_id;tft_wallet.bind_card:bind_card_id;tft_wallet.contract_apply_record:apply_record_id;tft_wallet.open_account_log:open_log_id;tft_wallet.traffic_order:order_id;tft_wallet.traffic_order_consume:order_id;tft_wallet.traffic_order_refund:order_id;tft_wallet.wallet_order:order_id;tft_wallet.credit_apply_log:log_id;tft_ups.cp_activity:activity_id",
  "rac.nodes": "10.60.6.11,10.60.6.12",
  "tasks.max": "1",
  "database.history.kafka.topic": "oracle_ups_his",
  "log.mining.strategy": "online_catalog", <<============
  "tombstones.on.delete": "false",
  "decimal.handling.mode": "string",
  "log.mining.continuous.mine": "true", <<============
  "database.history.skip.unparseable.ddl": "true",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "log.mining.transaction.retention.hours": "3",
  "database.user": "logminer",
  "database.dbname": "tftups",
  "database.history.kafka.bootstrap.servers": "10.50.253.201:9093,10.50.253.202:9093,10.50.253.203:9093",
  "database.server.name": "oracle_ups",
  "database.port": "1521",
  "key.converter.schemas.enable": "false",
  "database.hostname": "10.60.6.11",
  "database.password": "Logminer#$321",
  "value.converter.schemas.enable": "false",
  "name": "oracle_ups",
  "table.include.list": "logminer.log_mining_config,tft_ups.cp_activity_issue,tft_ups.cp_award,tft_ups.cp_coupon,tft_ups.cp_coupon_issue,tft_ups.cp_coupon_issue_coupon_list,tft_ups.cp_coupon_package_detail,tft_ups.cp_coupon_package_download,tft_ups.cp_coupon_package_issue,tft_ups.cp_coupon_package_issue_list,tft_ups.cp_coupon_product,tft_ups.cp_coupon_template,tft_ups.cp_issue,tft_ups.cp_my_coupon,tft_ups.cp_outside_issue,tft_ups.cp_outside_issue_package_d,tft_ups.cp_prize,tft_ups.cp_product_package_detail,tft_ups.dc_act_discount_card,tft_ups.dc_discount_card,tft_ups.dc_discount_card_hold_rec,tft_ups.dc_discount_card_list,tft_ups.dc_orient_discount_card,tft_ups.dc_sell_discount_card,tft_ups.dc_trip_order,tft_ups.dc_user_dis_card_restrict,tft_wallet.account_info,tft_wallet.bind_card,tft_wallet.contract_apply_record,tft_wallet.open_account_log,tft_wallet.traffic_order,tft_wallet.traffic_order_consume,tft_wallet.traffic_order_refund,tft_wallet.wallet_order,tft_wallet.credit_apply_log,tft_ups.cp_activity",
  "snapshot.mode": "schema_only"
}
```

特殊配置项说明：
* "log.mining.strategy"：该配置仅是为兼容connector，实际无效，真实值从配置表中读取，详见配置表说明。
* "log.mining.continuous.mine"：该配置仅是为兼容connector，实际无效，真实值从配置表中读取，详见配置表说明。

其他配置项，请自行阅读[官方文档](https://debezium.io/documentation/reference/1.8/connectors/oracle.html#oracle-connector-properties)

# 配置表说明

```
SQL> desc LOGMINER.LOG_MINING_CONFIG; 
Name                        Type           Nullable Default Comments 
--------------------------- -------------- -------- ------- -------- 
CONNECTOR_NAME              VARCHAR2(64)                             
PGA_LIMIT                   NUMBER(19)     Y                         
LOG_MINING_STRATEGY         VARCHAR2(32)   Y                         
NEED_RESTART_MINING_SESSION VARCHAR2(3)    Y                         
CONTEXT_RUNNING             VARCHAR2(3)    Y                         
ACTION                      VARCHAR2(64)   Y                         
ACTION_TS                   DATE           Y                         
ACK                         VARCHAR2(64)   Y                         
ACK_TS                      DATE           Y                         
EXTRA_ADD_LOGFILE           VARCHAR2(3)    Y                         
LOGFILE_NAME                VARCHAR2(4000) Y                         
EXTRA_ADD_LOGFILE_TS        DATE           Y                         
CONTINUOUS_MINE             VARCHAR2(3)    Y                         
CONTINUOUS_MINE_TS          DATE           Y                         
TS                          DATE           Y                         
```

|    字段名                   |    默认值              | 说明              | 
| :------------------------- | :-------------------- | :---------------- |
| CONNECTOR_NAME             | 请求体中Connector名称   | 主键|
| PGA_LIMIT                  | 200                   | PGA限制，单位MB，超过该值，会话自动重启以释放PGA内存 |
| LOG_MINING_STRATEGY        | ONLINE_CATALOG        | 采集模式：ONLINE_CATALOG、REDO_LOG_CATALOG; CDC不会读取请求体中对应配置项，仅读取配置表的配置；初次启动CDC读取该配置应用采集模式，如果需在采集过程中更改采集模式，则需配合NEED_RESTART_MINING_SESSION使用|
| NEED_RESTART_MINING_SESSION| NO                    | 是否重启CDC会话：YES, NO; 一般来说，更改采集模式或手动额外添加日志，则需置为YES后重启CDC会话应用新的配置|
| CONTEXT_RUNNING            | NO                    | 上下文运行状态：YES, NO|
| ACTION                     | END_MINE              | CDC会话当前的运行动作|
| ACTION_TS                  | 无                    | CDC会话当前的运行动作的时间戳|
| ACK                        | 无                    | CDC ACK动作，适用于多个Connector同时运行|
| ACK_TS                     | 无                    | CDC ACK动作时间，适用于多个Connector同时运行|
| EXTRA_ADD_LOGFILE          | NO                    | 是否额外添加日志：YES, NO；两种采集模式都支持额外添加日志，需配合NEED_RESTART_MINING_SESSION,LOGFILE_NAME使用 |
| LOGFILE_NAME               | 无                    | 添加日志文件的序列号，以英文逗号作为分隔符，如'15180,15182'，在EXTRA_ADD_LOGFILE值为YES时生效 |
| EXTRA_ADD_LOGFILE_TS       | 无                    | 额外添加日志时间 | 
| CONTINUOUS_MINE            | YES                   | 是否启用连续挖掘：YES, NO；推荐启用，可有效避免数据丢失，该配置更改不需重启CDC会话 |
| CONTINUOUS_MINE_TS         | 无                    | 更改CONTINUOUS_MINE时间 |
| TS                         | 无                    | 数据变更时间 |


# 其他说明

## ONLINE_CATALOG、REDO_LOG_CATALOG

ONLINE_CATALOG：解析日志时，在线获取元数据信息，不具备字典跟踪能力

REDO_LOG_CATALOG： 字典存储在REDO中，具备字典跟踪能力

什么时候用何种模式？

通常情况下，使用ONLINE_CATALOG模式采集日志稳定高效；当采集过程中被采集表发生元信息进化，则需在进化前切换为REDO_LOG_CATALOG模式，以跟踪元信息变化。

模式切换，应同时配合NEED_RESTART_MINING_SESSION使用：

```
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
		TS = SYSDATE;
COMMIT;
```

在跟踪完元信息变化后，应将模式切换回ONLINE_CATALOG；

```
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'ONLINE_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
	    	TS = SYSDATE;
COMMIT;
```

## 手动添加额外日志

在CDC正常运行过程中，其会自动控制待分析日志的添加，按理不需人为干预控制。在某些特定的场景下，需要手动添加额外日志，例如日志可用，但是CDC会话没有添加该日志，报错Missing logfile。
这时候，便需认为干预添加日志。

什么时候添加日志？

初次启动CDC时：
```
UPDATE LOG_MINING_CONFIG SET EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```

执行CDC过程中：
```
UPDATE LOG_MINING_CONFIG SET NEED_RESTART_MINING_SESSION = 'YES', EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```
如果在运行过程中，则需配合NEED_RESTART_MINING_SESSION使用，必须重启CDC会话，以应用新配置。

更改采集模式+添加额外日志
```
UPDATE LOG_MINING_CONFIG SET NEED_RESTART_MINING_SESSION = 'YES', LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG',  EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```

**NOTE:** 如果添加的是日志中包含字典信息（添加字典），则需保证添加的日志文件包括完整的字典信息，即要选择DICT_START和DICT_END都为YES之间的所有日志。

例如日志如下：

|序号|DICT_START|DICT_END|
| :--- | :--- | :--- |
| 1 | NO | NO |
| 2 | YES | NO |
| 3 | NO | YES |
| 4 | NO | NO |

如果单独添加4日志，CDC会一直报缺失日志(missing logfile)的错误。因为4日志为CDC构建字典信息后生成的，不应该单独添加该日志。
正确的方式，仅需同时添加2,3日志即可解决，4日志不用添加。


# 查询可用日志SQL

```
WITH T AS
 (SELECT MIN(F.MEMBER) AS FILE_NAME,
         L.FIRST_CHANGE# FIRST_CHANGE,
         L."FIRST_TIME",
         L.NEXT_CHANGE# NEXT_CHANGE,
         L."NEXT_TIME",
         L.ARCHIVED,
         L.STATUS,
         'ONLINE' AS TYPE,
         L.SEQUENCE# AS SEQ,
         'NO' AS DICT_START,
         'NO' AS DICT_END
    FROM V$LOGFILE F, V$LOG L
    LEFT JOIN V$ARCHIVED_LOG A
      ON A.FIRST_CHANGE# = L.FIRST_CHANGE#
     AND A.NEXT_CHANGE# = L.NEXT_CHANGE#
   WHERE (A.STATUS <> 'A' OR A.FIRST_CHANGE# IS NULL)
     AND F.GROUP# = L.GROUP#
   GROUP BY F.GROUP#,
            L.FIRST_CHANGE#,
            L."FIRST_TIME",
            L.NEXT_CHANGE#,
            L.NEXT_TIME,
            L.STATUS,
            L.ARCHIVED,
            L.SEQUENCE#
  UNION
  SELECT A.NAME             AS FILE_NAME,
         A.FIRST_CHANGE#    FIRST_CHANGE,
         A."FIRST_TIME",
         A.NEXT_CHANGE#     NEXT_CHANGE,
         A.NEXT_TIME,
         'YES',
         NULL,
         'ARCHIVED',
         A.SEQUENCE#        AS SEQ,
         A.DICTIONARY_BEGIN,
         A.DICTIONARY_END
    FROM V$ARCHIVED_LOG A
   WHERE A.NAME IS NOT NULL
     AND A.ARCHIVED = 'YES'
     AND A.STATUS = 'A'
     AND A.NEXT_CHANGE# >  2650170 -- and A."FIRST_CHANGE#" < 2697169
     AND A.DEST_ID IN (SELECT DEST_ID
                         FROM V$ARCHIVE_DEST_STATUS
                        WHERE STATUS = 'VALID'
                          AND TYPE = 'LOCAL'
                          AND ROWNUM = 1))
select * from T;
```