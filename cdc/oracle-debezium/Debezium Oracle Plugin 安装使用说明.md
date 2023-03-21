# Ŀ��

˵��Oracle CDC�Ĳ��𣬲���������Ĳ���

# ����˵��

���������壺
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

����������˵����
* "log.mining.strategy"�������ý���Ϊ����connector��ʵ����Ч����ʵֵ�����ñ��ж�ȡ��������ñ�˵����
* "log.mining.continuous.mine"�������ý���Ϊ����connector��ʵ����Ч����ʵֵ�����ñ��ж�ȡ��������ñ�˵����

����������������Ķ�[�ٷ��ĵ�](https://debezium.io/documentation/reference/1.8/connectors/oracle.html#oracle-connector-properties)

# ���ñ�˵��

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

|    �ֶ���                   |    Ĭ��ֵ              | ˵��              | 
| :------------------------- | :-------------------- | :---------------- |
| CONNECTOR_NAME             | ��������Connector����   | ����|
| PGA_LIMIT                  | 200                   | PGA���ƣ���λMB��������ֵ���Ự�Զ��������ͷ�PGA�ڴ� |
| LOG_MINING_STRATEGY        | ONLINE_CATALOG        | �ɼ�ģʽ��ONLINE_CATALOG��REDO_LOG_CATALOG; CDC�����ȡ�������ж�Ӧ���������ȡ���ñ�����ã���������CDC��ȡ������Ӧ�òɼ�ģʽ��������ڲɼ������и��Ĳɼ�ģʽ���������NEED_RESTART_MINING_SESSIONʹ��|
| NEED_RESTART_MINING_SESSION| NO                    | �Ƿ�����CDC�Ự��YES, NO; һ����˵�����Ĳɼ�ģʽ���ֶ����������־��������ΪYES������CDC�ỰӦ���µ�����|
| CONTEXT_RUNNING            | NO                    | ����������״̬��YES, NO|
| ACTION                     | END_MINE              | CDC�Ự��ǰ�����ж���|
| ACTION_TS                  | ��                    | CDC�Ự��ǰ�����ж�����ʱ���|
| ACK                        | ��                    | CDC ACK�����������ڶ��Connectorͬʱ����|
| ACK_TS                     | ��                    | CDC ACK����ʱ�䣬�����ڶ��Connectorͬʱ����|
| EXTRA_ADD_LOGFILE          | NO                    | �Ƿ���������־��YES, NO�����ֲɼ�ģʽ��֧�ֶ��������־�������NEED_RESTART_MINING_SESSION,LOGFILE_NAMEʹ�� |
| LOGFILE_NAME               | ��                    | �����־�ļ������кţ���Ӣ�Ķ�����Ϊ�ָ�������'15180,15182'����EXTRA_ADD_LOGFILEֵΪYESʱ��Ч |
| EXTRA_ADD_LOGFILE_TS       | ��                    | ���������־ʱ�� | 
| CONTINUOUS_MINE            | YES                   | �Ƿ����������ھ�YES, NO���Ƽ����ã�����Ч�������ݶ�ʧ�������ø��Ĳ�������CDC�Ự |
| CONTINUOUS_MINE_TS         | ��                    | ����CONTINUOUS_MINEʱ�� |
| TS                         | ��                    | ���ݱ��ʱ�� |


# ����˵��

## ONLINE_CATALOG��REDO_LOG_CATALOG

ONLINE_CATALOG��������־ʱ�����߻�ȡԪ������Ϣ�����߱��ֵ��������

REDO_LOG_CATALOG�� �ֵ�洢��REDO�У��߱��ֵ��������

ʲôʱ���ú���ģʽ��

ͨ������£�ʹ��ONLINE_CATALOGģʽ�ɼ���־�ȶ���Ч�����ɼ������б��ɼ�����Ԫ��Ϣ�����������ڽ���ǰ�л�ΪREDO_LOG_CATALOGģʽ���Ը���Ԫ��Ϣ�仯��

ģʽ�л���Ӧͬʱ���NEED_RESTART_MINING_SESSIONʹ�ã�

```
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
		TS = SYSDATE;
COMMIT;
```

�ڸ�����Ԫ��Ϣ�仯��Ӧ��ģʽ�л���ONLINE_CATALOG��

```
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'ONLINE_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
	    	TS = SYSDATE;
COMMIT;
```

## �ֶ���Ӷ�����־

��CDC�������й����У�����Զ����ƴ�������־����ӣ���������Ϊ��Ԥ���ơ���ĳЩ�ض��ĳ����£���Ҫ�ֶ���Ӷ�����־��������־���ã�����CDC�Ựû����Ӹ���־������Missing logfile��
��ʱ�򣬱�����Ϊ��Ԥ�����־��

ʲôʱ�������־��

��������CDCʱ��
```
UPDATE LOG_MINING_CONFIG SET EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```

ִ��CDC�����У�
```
UPDATE LOG_MINING_CONFIG SET NEED_RESTART_MINING_SESSION = 'YES', EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```
��������й����У��������NEED_RESTART_MINING_SESSIONʹ�ã���������CDC�Ự����Ӧ�������á�

���Ĳɼ�ģʽ+��Ӷ�����־
```
UPDATE LOG_MINING_CONFIG SET NEED_RESTART_MINING_SESSION = 'YES', LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG',  EXTRA_ADD_LOGFILE = 'YES', 
  LOGFILE_NAME = '15185,15187,15185,15186',
  EXTRA_ADD_LOGFILE_TS = SYSDATE
 WHERE CONNECTOR_NAME = 'OCP11G';
COMMIT;
```

**NOTE:** �����ӵ�����־�а����ֵ���Ϣ������ֵ䣩�����豣֤��ӵ���־�ļ������������ֵ���Ϣ����Ҫѡ��DICT_START��DICT_END��ΪYES֮���������־��

������־���£�

|���|DICT_START|DICT_END|
| :--- | :--- | :--- |
| 1 | NO | NO |
| 2 | YES | NO |
| 3 | NO | YES |
| 4 | NO | NO |

����������4��־��CDC��һֱ��ȱʧ��־(missing logfile)�Ĵ�����Ϊ4��־ΪCDC�����ֵ���Ϣ�����ɵģ���Ӧ�õ�����Ӹ���־��
��ȷ�ķ�ʽ������ͬʱ���2,3��־���ɽ����4��־������ӡ�


# ��ѯ������־SQL

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