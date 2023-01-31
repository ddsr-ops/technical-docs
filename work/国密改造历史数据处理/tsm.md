curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
       "name": "oracle_tsm_sm4",
       "config": {
           "connector.class" : "io.debezium.connector.oracle.OracleConnector",
           "tasks.max" : "1",
           "database.server.name" : "oracle_tsm_sm4",
           "database.user" : "logminer",
           "database.password" : "Logminer#$321",
           "database.dbname" : "tftong",
           "database.port" : "1521",
           "database.hostname" : "10.60.5.2",
           "rac.nodes" : "10.60.5.1,10.60.5.2",
           "log.mining.transaction.retention.hours" : "2",
    	   "decimal.handling.mode":"string",
           "table.include.list":"tft_tsm.t_account_refunds_info,tft_tsm.t_binding_credit_card,tft_tsm.t_credit_remove_record,tft_tsm.t_real_auth,tft_tsm.t_einvoice_info,tft_tsm.t_openid_aliuser,tft_tsm.t_card_topup_count_info,logminer.debezium_signal,tft_tsm.eiv_invoice_email,tft_tsm.eiv_invoice_email_pushrecord,tft_tsm.t_trip_order_export_record,tft_tsm.t_trip_order_export_email,tft_tsm.t_trip_order_exp_cancel_record",
           "message.key.columns":"tft_tsm.t_account_refunds_info:refund_trandno;tft_tsm.t_binding_credit_card:userid,credit_card_no;tft_tsm.t_card_topup_count_info:trade_no;tft_tsm.t_credit_remove_record:id;tft_tsm.t_einvoice_info:order_no;tft_tsm.t_openid_aliuser:id;tft_tsm.t_real_auth:userid;tft_tsm.eiv_invoice_email:id;tft_tsm.eiv_invoice_email_pushrecord:id;tft_tsm.t_trip_order_export_record:id;tft_tsm.t_trip_order_export_email:id;tft_tsm.t_trip_order_exp_cancel_record:id",
           "key.converter":"org.apache.kafka.connect.json.JsonConverter",
           "key.converter.schemas.enable":"false",
           "value.converter":"org.apache.kafka.connect.json.JsonConverter",
           "value.converter.schemas.enable":"false",
           "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
           "database.history.kafka.topic": "oracle_tsm_sm4_his",
           "snapshot.mode" : "schema_only",
           "tombstones.on.delete": "false",
           "database.history.skip.unparseable.ddl": "true",
           "log.mining.strategy": "online_catalog",
           "log.mining.continuous.mine": "true",
           "signal.data.collection":"TFTONG.LOGMINER.DEBEZIUM_SIGNAL",
           "incremental.snapshot.chunk.size":"50000"
       }
    }' \
http://10.50.253.6:8085/connectors



-- The first incremental snapshot

insert into logminer.debezium_signal values('ad-hoc-2', 'execute-snapshot', '{"data-collections": ["TFTONG.TFT_TSM.T_ACCOUNT_REFUNDS_INFO","TFTONG.TFT_TSM.T_BINDING_CREDIT_CARD","TFTONG.TFT_TSM.T_CREDIT_REMOVE_RECORD","TFTONG.TFT_TSM.T_REAL_AUTH","TFTONG.TFT_TSM.T_EINVOICE_INFO","TFTONG.TFT_TSM.T_OPENID_ALIUSER","TFTONG.TFT_TSM.T_CARD_TOPUP_COUNT_INFO"],"type":"INCREMENTAL"}');
commit;

-- The second incremental snapshot, because of addition of new tables 
insert into logminer.debezium_signal values('ad-hoc-3', 'execute-snapshot', '{"data-collections": ["TFTONG.TFT_TSM.EIV_INVOICE_EMAIL","TFTONG.TFT_TSM.EIV_INVOICE_EMAIL_PUSHRECORD","TFTONG.TFT_TSM.T_TRIP_ORDER_EXPORT_RECORD","TFTONG.TFT_TSM.T_TRIP_ORDER_EXPORT_EMAIL","TFTONG.TFT_TSM.T_TRIP_ORDER_EXP_CANCEL_RECORD"],"type":"INCREMENTAL"}');
commit;

insert into logminer.debezium_signal values('ad-hoc-4', 'execute-snapshot', '{"data-collections": ["TFTONG.TFT_TSM.T_TRIP_ORDER_EXP_CANCEL_RECORD"],"type":"INCREMENTAL"}');
commit;

insert into logminer.debezium_signal values('ad-hoc-6', 'execute-snapshot', '{"data-collections": ["TFTONG.TFT_TSM.T_OPENID_ALIUSER"],"type":"INCREMENTAL"}');
commit;


create temporary function tsm_aes_decrypt as 'com.tft.flink.udf.TsmAesDecryptUDF';
create temporary function sm4_encrypt as 'com.tft.flink.udf.SM4EncryptUDF';
set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts='3';
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

CREATE TABLE t_einvoice_info (
ORDER_NO STRING,
EINVOICE_TYPE INT,
EINVOICE_HEADER STRING,
EINVOICE_TAX_NUMBER STRING,
EINVOICE_AMOUNT STRING,
REFUND_AMOUNT STRING,
EINVOICE_CONTENT STRING,
EMAIL_NUMBER STRING,
REMARK STRING,
ADDRESS_AND_PHONE_NO STRING,
BANK_NO STRING,
ORDER_STATUS INT,
CREATE_TIME BIGINT,
UPDATE_TIME BIGINT,
USER_ID STRING,
EINVOICE_NO STRING,
ORDER_TYPE INT,
UP_EINVOICE_NO STRING,
FP_HM STRING,
JYM STRING,
KPRQ STRING,
PDF_URL STRING,
SP_URL STRING,
EINVOICE_ORDER_TYPE INT,
CHANNEL_CODE INT,
FAIL_MSG STRING,
OPERATOR_TYPE INT,
ORDER_CHANNEL INT
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_EINVOICE_INFO',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_einvoice_info',
'scan.startup.mode' = 'earliest-offset',  -- for another new columns to encrypt
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE t_einvoice_info1 (
ORDER_NO STRING,
EINVOICE_TYPE INT,
EINVOICE_HEADER STRING,
EINVOICE_TAX_NUMBER STRING,
EINVOICE_AMOUNT STRING,
REFUND_AMOUNT STRING,
EINVOICE_CONTENT STRING,
EMAIL_NUMBER STRING,
REMARK STRING,
ADDRESS_AND_PHONE_NO STRING,
BANK_NO STRING,
ORDER_STATUS INT,
CREATE_TIME TIMESTAMP,
UPDATE_TIME TIMESTAMP,
USER_ID STRING,
EINVOICE_NO STRING,
ORDER_TYPE INT,
UP_EINVOICE_NO STRING,
FP_HM STRING,
JYM STRING,
KPRQ STRING,
PDF_URL STRING,
SP_URL STRING,
EINVOICE_ORDER_TYPE INT,
CHANNEL_CODE INT,
FAIL_MSG STRING,
OPERATOR_TYPE INT,
ORDER_CHANNEL INT,
PRIMARY KEY (ORDER_NO) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_einvoice_info_new1', 
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '1000',
'sink.buffer-flush.interval' = '0'
);


insert into t_einvoice_info1 select
ORDER_NO,
EINVOICE_TYPE,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', EINVOICE_HEADER) as EINVOICE_HEADER,
EINVOICE_TAX_NUMBER,
EINVOICE_AMOUNT,
REFUND_AMOUNT,
EINVOICE_CONTENT,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', EMAIL_NUMBER) as EMAIL_NUMBER,
REMARK,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', ADDRESS_AND_PHONE_NO) as ADDRESS_AND_PHONE_NO,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', BANK_NO) AS BANK_NO,
ORDER_STATUS,
TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME,
USER_ID,
EINVOICE_NO,
ORDER_TYPE,
UP_EINVOICE_NO,
FP_HM,
JYM,
KPRQ,
PDF_URL,
SP_URL,
EINVOICE_ORDER_TYPE,
CHANNEL_CODE,
FAIL_MSG,
OPERATOR_TYPE,
ORDER_CHANNEL
from t_einvoice_info;

CREATE TABLE t_account_refunds_info(
USERID STRING,
REFUND_TRANDNO STRING,
REFUND_AMOUNT INT,
ACTUAL_REFUND_AMOUNT INT,
DEDUCT_AMOUNT INT,
REFUND_POUNDAGE INT,
REFUND_BANKINFO STRING,
REFUND_STATUS INT,
REFUND_STATUS_MSG STRING,
REFUND_USERNAME STRING,
BANK_CARDNO STRING,
BANK_CARDTYPE STRING,
IDCARD STRING,
CREATETIME BIGINT,
UPDATETIME BIGINT,
POUNDAGE_TYPE INT,
POUNDAGE_REFUND_AMOUNT INT,
AUDIT_STATUS INT
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_ACCOUNT_REFUNDS_INFO',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_account_refunds_info',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE t_account_refunds_info1(
USERID STRING,
REFUND_TRANDNO STRING,
REFUND_AMOUNT INT,
ACTUAL_REFUND_AMOUNT INT,
DEDUCT_AMOUNT INT,
REFUND_POUNDAGE INT,
REFUND_BANKINFO STRING,
REFUND_STATUS INT,
REFUND_STATUS_MSG STRING,
REFUND_USERNAME STRING,
BANK_CARDNO STRING,
BANK_CARDTYPE STRING,
IDCARD STRING,
CREATETIME TIMESTAMP,
UPDATETIME TIMESTAMP,
POUNDAGE_TYPE INT,
POUNDAGE_REFUND_AMOUNT INT,
AUDIT_STATUS INT,
PRIMARY KEY (REFUND_TRANDNO) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_account_refunds_info_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO t_account_refunds_info1
SELECT USERID,
REFUND_TRANDNO,
REFUND_AMOUNT,
ACTUAL_REFUND_AMOUNT,
DEDUCT_AMOUNT,
REFUND_POUNDAGE,
REFUND_BANKINFO,
REFUND_STATUS,
REFUND_STATUS_MSG,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',REFUND_USERNAME) as REFUND_USERNAME,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',BANK_CARDNO) AS BANK_CARDNO,
BANK_CARDTYPE,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',IDCARD) AS IDCARD,
TO_TIMESTAMP(FROM_UNIXTIME(CREATETIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') AS CREATETIME,
TO_TIMESTAMP(FROM_UNIXTIME(UPDATETIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') AS UPDATETIME,
POUNDAGE_TYPE,
POUNDAGE_REFUND_AMOUNT,
AUDIT_STATUS
FROM t_account_refunds_info;


CREATE TABLE t_binding_credit_card(
CREDIT_CARD_NO STRING,
USERID STRING,
CREDIT_CARD_PHONENO STRING,
TOKEN STRING,
TRID STRING,
TOKENLEVEL STRING,
TOKENBEGIN STRING,
TOKENEND STRING,
TOKENTYPE STRING,
BINDING_TIME BIGINT,
UPDATE_TIME BIGINT,
ORDERID STRING,
STATUS INT,
IDCARD STRING,
BANKCARD_REALNAME STRING,
CREDIT_CARD_TYPE STRING,
CREDIT_CARD_BANKNAME STRING,
SINGLE_LIMIT_AMOUNT INT,
EVERYDAY_LIMIT_AMOUNT INT,
BANK_LOGO STRING,
CREDIT_CARD_BGDLOGO STRING
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_BINDING_CREDIT_CARD',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_binding_credit_card',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE t_binding_credit_card1(
CREDIT_CARD_NO STRING,
USERID STRING,
CREDIT_CARD_PHONENO STRING,
TOKEN STRING,
TRID STRING,
TOKENLEVEL STRING,
TOKENBEGIN STRING,
TOKENEND STRING,
TOKENTYPE STRING,
BINDING_TIME TIMESTAMP,
UPDATE_TIME TIMESTAMP,
ORDERID STRING,
STATUS INT,
IDCARD STRING,
BANKCARD_REALNAME STRING,
CREDIT_CARD_TYPE STRING,
CREDIT_CARD_BANKNAME STRING,
SINGLE_LIMIT_AMOUNT INT,
EVERYDAY_LIMIT_AMOUNT INT,
BANK_LOGO STRING,
CREDIT_CARD_BGDLOGO STRING,
PRIMARY KEY (CREDIT_CARD_NO, USERID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_binding_credit_card_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO t_binding_credit_card1
SELECT
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',CREDIT_CARD_NO) AS CREDIT_CARD_NO,
USERID,
CREDIT_CARD_PHONENO,
TOKEN,
TRID,
TOKENLEVEL,
TOKENBEGIN,
TOKENEND,
TOKENTYPE,
TO_TIMESTAMP(FROM_UNIXTIME(BINDING_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') AS BINDING_TIME,
TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') AS UPDATE_TIME,
ORDERID,
STATUS,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',IDCARD) AS IDCARD,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',BANKCARD_REALNAME) AS BANKCARD_REALNAME,
CREDIT_CARD_TYPE,
CREDIT_CARD_BANKNAME,
SINGLE_LIMIT_AMOUNT,
EVERYDAY_LIMIT_AMOUNT,
BANK_LOGO,
CREDIT_CARD_BGDLOGO
FROM t_binding_credit_card;


CREATE TABLE T_CREDIT_REMOVE_RECORD(
    CARD_NO STRING,
    CREATE_TIME BIGINT,
    ID STRING,
    ORDERID STRING,
    REMARK STRING,
    STATUS STRING,
    USERID STRING
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_CREDIT_REMOVE_RECORD',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_credit_remove_record',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE T_CREDIT_REMOVE_RECORD1(
    CARD_NO STRING,
    CREATE_TIME TIMESTAMP,
    ID STRING,
    ORDERID STRING,
    REMARK STRING,
    STATUS STRING,
    USERID STRING,
    PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_credit_remove_record_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_CREDIT_REMOVE_RECORD1
SELECT
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',CARD_NO) as CARD_NO,
    TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') AS CREATE_TIME,
    ID,
    ORDERID,
    REMARK,
    STATUS,
    USERID
  FROM T_CREDIT_REMOVE_RECORD;

CREATE TABLE T_REAL_AUTH(
    ACCNO STRING,
    CREATE_TIME BIGINT,
    IDCARD STRING,
    PICFRONT STRING,
    PICHANDCARD STRING,
    PICREVERSE STRING,
    REALNAME STRING,
    REAL_STATUS STRING,
    UPDATE_TIME BIGINT,
    USERID STRING
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_REAL_AUTH',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_real_auth',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE T_REAL_AUTH1(
    ACCNO STRING,
    CREATE_TIME TIMESTAMP,
    IDCARD STRING,
    PICFRONT STRING,
    PICHANDCARD STRING,
    PICREVERSE STRING,
    REALNAME STRING,
    REAL_STATUS STRING,
    UPDATE_TIME TIMESTAMP,
    USERID STRING,
    PRIMARY KEY (USERID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_real_auth_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_REAL_AUTH1
  SELECT ACCNO,
        TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
        sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', IDCARD) as IDCARD,
        PICFRONT,
        PICHANDCARD,
        PICREVERSE,
        sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', REALNAME) as REALNAME,
        REAL_STATUS,
        TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME,
        USERID
  FROM T_REAL_AUTH;

CREATE TABLE T_OPENID_ALIUSER(
    ALI_APPID STRING,
    ALI_PHONE STRING,
    ALI_USER_ID STRING,
    CERT_NO STRING,
    CERT_TYPE STRING,
    ID STRING,
    OPENED_STATUS STRING,
    OPENID STRING,
    USERNAME STRING
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_OPENID_ALIUSER',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_openid_aliuser',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE T_OPENID_ALIUSER1(
    ALI_APPID STRING,
    ALI_PHONE STRING,
    ALI_USER_ID STRING,
    CERT_NO STRING,
    CERT_TYPE STRING,
    ID STRING,
    OPENED_STATUS STRING,
    OPENID STRING,
    USERNAME STRING,
    PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 't_openid_aliuser_new',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);


INSERT INTO T_OPENID_ALIUSER1
  SELECT ALI_APPID,
        ALI_PHONE,
        ALI_USER_ID,
        IF(CHAR_LENGTH(CERT_NO) > 18, sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', tsm_aes_decrypt(CERT_NO)), sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', CERT_NO)) as CERT_NO,
        CERT_TYPE,
        ID,
        OPENED_STATUS,
        OPENID,
        IF(CHAR_LENGTH(CERT_NO) > 18, sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', tsm_aes_decrypt(USERNAME)), sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', USERNAME)) as USERNAME
    FROM T_OPENID_ALIUSER;


//////////////////////////////////////////////////////////////////////////////////////////

CREATE TABLE EIV_INVOICE_EMAIL
   (ID STRING,
    PHONE STRING,
    EMAIL STRING,
    BIZ_TYPE STRING,
    EMAIL_TEMPLATE_ID STRING,
    EMAIL_TEMPLATE_NAME STRING,
    LAST_PUSH_TIME BIGINT,
    INVOICE_AMOUNT STRING,
    INVOICE_NO STRING,
    FP_HM STRING,
    JYM STRING,
    KPRQ STRING,
    PDF_URL STRING,
    SP_URL STRING,
    CREATE_TIME BIGINT,
    SOURCE_ID STRING,
    INVOICE_TYPE STRING)
 WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.EIV_INVOICE_EMAIL',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.eiv_invoice_email',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE EIV_INVOICE_EMAIL1
   (ID STRING,
    PHONE STRING,
    EMAIL STRING,
    BIZ_TYPE STRING,
    EMAIL_TEMPLATE_ID STRING,
    EMAIL_TEMPLATE_NAME STRING,
    LAST_PUSH_TIME TIMESTAMP,
    INVOICE_AMOUNT STRING,
    INVOICE_NO STRING,
    FP_HM STRING,
    JYM STRING,
    KPRQ STRING,
    PDF_URL STRING,
    SP_URL STRING,
    CREATE_TIME TIMESTAMP,
    SOURCE_ID STRING,
    INVOICE_TYPE STRING,
    PRIMARY KEY (ID) NOT ENFORCED)
 WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'EIV_INVOICE_EMAIL_NEW',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO EIV_INVOICE_EMAIL1
SELECT
      ID,
      PHONE,
      sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',EMAIL) as EMAIL,
      BIZ_TYPE,
      EMAIL_TEMPLATE_ID,
      EMAIL_TEMPLATE_NAME,
      TO_TIMESTAMP(FROM_UNIXTIME(LAST_PUSH_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as LAST_PUSH_TIME,
      INVOICE_AMOUNT,
      INVOICE_NO,
      FP_HM,
      JYM,
      KPRQ,
      PDF_URL,
      SP_URL,
      TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
      SOURCE_ID,
      INVOICE_TYPE
  FROM EIV_INVOICE_EMAIL;


CREATE TABLE EIV_INVOICE_EMAIL_PUSHRECORD(
    ID STRING,
    INVOICE_EMAIL_ID STRING,
    PUSH_TIME BIGINT,
    `RESULT` STRING,
    ERROR_MSG STRING,
    SEND_REASON STRING,
    INVOICE_EMAIL_TIME BIGINT,
    EMAIL STRING
)  WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.EIV_INVOICE_EMAIL_PUSHRECORD',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.eiv_invoice_email_pushrecord',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE EIV_INVOICE_EMAIL_PUSHRECORD1(
    ID STRING,
    INVOICE_EMAIL_ID STRING,
    PUSH_TIME TIMESTAMP,
    `RESULT` STRING,
    ERROR_MSG STRING,
    SEND_REASON STRING,
    INVOICE_EMAIL_TIME TIMESTAMP,
    EMAIL STRING,
    PRIMARY KEY (ID) NOT ENFORCED
)  WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'EIV_INVOICE_EMAIL_PUSHRECORD_N',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

insert into EIV_INVOICE_EMAIL_PUSHRECORD1
select 
        ID,
        INVOICE_EMAIL_ID,
        TO_TIMESTAMP(FROM_UNIXTIME(PUSH_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as PUSH_TIME ,
        `RESULT`,
        ERROR_MSG,
        SEND_REASON,
        TO_TIMESTAMP(FROM_UNIXTIME(INVOICE_EMAIL_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as INVOICE_EMAIL_TIME,
        sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',EMAIL) as EMAIL
  from EIV_INVOICE_EMAIL_PUSHRECORD;


CREATE TABLE T_TRIP_ORDER_EXPORT_RECORD
(
    ID STRING,
    BATCH_NO STRING,
    APPLY_TIME BIGINT,
    APPLY_PHONE STRING,
    USER_ID STRING,
    STATUS STRING,
    TRIP_TYPE STRING,
    TRIP_ORDER_NUM STRING,
    LAST_SEND_EMAIL STRING,
    LAST_SEND_TIME BIGINT,
    SEND_TIMES STRING,
    TRIP_ORDER_AMT STRING,
    CREATE_TIME BIGINT,
    UPDATE_TIME BIGINT
)   WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_TRIP_ORDER_EXPORT_RECORD',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_trip_order_export_record',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE T_TRIP_ORDER_EXPORT_RECORD1
(
    ID STRING,
    BATCH_NO STRING,
    APPLY_TIME TIMESTAMP,
    APPLY_PHONE STRING,
    USER_ID STRING,
    STATUS STRING,
    TRIP_TYPE STRING,
    TRIP_ORDER_NUM STRING,
    LAST_SEND_EMAIL STRING,
    LAST_SEND_TIME TIMESTAMP,
    SEND_TIMES STRING,
    TRIP_ORDER_AMT STRING,
    CREATE_TIME TIMESTAMP,
    UPDATE_TIME TIMESTAMP,
    PRIMARY KEY (ID) NOT ENFORCED
)   WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'T_TRIP_ORDER_EXPORT_RECORD_NEW',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_TRIP_ORDER_EXPORT_RECORD1
SELECT
        ID,
        BATCH_NO,
        TO_TIMESTAMP(FROM_UNIXTIME(APPLY_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as APPLY_TIME,
        APPLY_PHONE,
        USER_ID,
        STATUS,
        TRIP_TYPE,
        TRIP_ORDER_NUM,
        sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==',LAST_SEND_EMAIL) AS LAST_SEND_EMAIL,
        TO_TIMESTAMP(FROM_UNIXTIME(LAST_SEND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as LAST_SEND_TIME,
        SEND_TIMES,
        TRIP_ORDER_AMT,
        TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
        TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as UPDATE_TIME
  FROM T_TRIP_ORDER_EXPORT_RECORD; 


CREATE TABLE T_TRIP_ORDER_EXPORT_EMAIL (
    ID STRING,
    BATCH_NO STRING,
    SEND_TIME BIGINT,
    EMAIL STRING,
    USER_ID STRING,
    APPLY_PHONE STRING,
    SEND_TYPE STRING,
    SEND_RESULT STRING,
    FAILED_MSG STRING,
    CREATE_TIME BIGINT,
    UPDATE_TIME BIGINT
)   WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_TRIP_ORDER_EXPORT_EMAIL',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_trip_order_export_email',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE T_TRIP_ORDER_EXPORT_EMAIL1 (
    ID STRING,
    BATCH_NO STRING,
    SEND_TIME TIMESTAMP,
    EMAIL STRING,
    USER_ID STRING,
    APPLY_PHONE STRING,
    SEND_TYPE STRING,
    SEND_RESULT STRING,
    FAILED_MSG STRING,
    CREATE_TIME TIMESTAMP,
    UPDATE_TIME TIMESTAMP,
    PRIMARY KEY (ID) NOT ENFORCED
)   WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'T_TRIP_ORDER_EXPORT_EMAIL_NEW',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_TRIP_ORDER_EXPORT_EMAIL1
SELECT
    ID,
    BATCH_NO,
    TO_TIMESTAMP(FROM_UNIXTIME(SEND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as SEND_TIME,
    sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', EMAIL) AS EMAIL,
    USER_ID,
    APPLY_PHONE,
    SEND_TYPE,
    SEND_RESULT,
    FAILED_MSG,
    TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as  CREATE_TIME ,
    TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as  UPDATE_TIME 
  FROM T_TRIP_ORDER_EXPORT_EMAIL;

CREATE TABLE T_TRIP_ORDER_EXP_CANCEL_RECORD(
    ID STRING,
    BATCH_NO STRING,
    APPLY_TIME BIGINT,
    APPLY_PHONE STRING,
    USER_ID STRING,
    TRIP_TYPE STRING,
    CANCEL_TIME BIGINT,
    OPT_ID STRING,
    LAST_SEND_TIME BIGINT,
    SEND_TIMES STRING,
    CANCEL_REASON STRING,
    CREATE_TIME BIGINT,
    LAST_SEND_EMAIL STRING
)  WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm4.TFT_TSM.T_TRIP_ORDER_EXP_CANCEL_RECORD',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm4.t_trip_order_exp_cancel_record',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE table T_TRIP_ORDER_EXP_CANCEL_RECORD1(
    ID STRING,
    BATCH_NO STRING,
    APPLY_TIME TIMESTAMP,
    APPLY_PHONE STRING,
    USER_ID STRING,
    TRIP_TYPE STRING,
    CANCEL_TIME TIMESTAMP,
    OPT_ID STRING,
    LAST_SEND_TIME TIMESTAMP,
    SEND_TIMES STRING,
    CANCEL_REASON STRING,
    CREATE_TIME TIMESTAMP,
    LAST_SEND_EMAIL STRING,
    PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'T_TRIP_ORDER_EXP_CANCEL_RECORN',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_TRIP_ORDER_EXP_CANCEL_RECORD1
SELECT
        ID,
        BATCH_NO,
        TO_TIMESTAMP(FROM_UNIXTIME(APPLY_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as APPLY_TIME,
        APPLY_PHONE,
        USER_ID,
        TRIP_TYPE,
        TO_TIMESTAMP(FROM_UNIXTIME(CANCEL_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CANCEL_TIME,
        OPT_ID,
        TO_TIMESTAMP(FROM_UNIXTIME(LAST_SEND_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as LAST_SEND_TIME,
        SEND_TIMES,
        CANCEL_REASON,
        TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as CREATE_TIME,
        sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', LAST_SEND_EMAIL) as   LAST_SEND_EMAIL
  FROM T_TRIP_ORDER_EXP_CANCEL_RECORD;



-- Only for table T_DELETE_CARD_DATA_SUB
curl -X POST  \
-H 'Content-Type: application/json' \
-H "Accept: application/json" \
-d '{
       "name": "oracle_tsm_sm41",
       "config": {
           "connector.class" : "io.debezium.connector.oracle.OracleConnector",
           "tasks.max" : "1",
           "database.server.name" : "oracle_tsm_sm41",
           "database.user" : "logminer",
           "database.password" : "Logminer#$321",
           "database.dbname" : "tftong",
           "database.port" : "1521",
           "database.hostname" : "10.60.5.2",
           "rac.nodes" : "10.60.5.1,10.60.5.2",
           "log.mining.transaction.retention.hours" : "2",
    	   "decimal.handling.mode":"string",
           "table.include.list":"tft_tsm.t_delete_card_data_sub",
           "message.key.columns":"tft_tsm.t_delete_card_data_sub:sub_order_no",
           "key.converter":"org.apache.kafka.connect.json.JsonConverter",
           "key.converter.schemas.enable":"false",
           "value.converter":"org.apache.kafka.connect.json.JsonConverter",
           "value.converter.schemas.enable":"false",
           "database.history.kafka.bootstrap.servers" : "datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093",
           "database.history.kafka.topic": "oracle_tsm_sm41_his",
           "snapshot.mode" : "initial",
           "tombstones.on.delete": "false",
           "database.history.skip.unparseable.ddl": "true",
           "log.mining.strategy": "online_catalog",
           "log.mining.continuous.mine": "true",
           "signal.data.collection":"TFTONG.LOGMINER.DEBEZIUM_SIGNAL",
           "incremental.snapshot.chunk.size":"50000"
       }
    }' \
http://10.50.253.6:8085/connectors

create temporary function tsm_aes_decrypt as 'com.tft.flink.udf.TsmAesDecryptUDF';
create temporary function sm4_encrypt as 'com.tft.flink.udf.SM4EncryptUDF';
set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts='3';
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';


CREATE TABLE T_DELETE_CARD_DATA_SUB(
    SUB_ORDER_NO STRING,
    USERID STRING,
    PAY_ORDER_NO STRING,
    PARENT_ORDER_NO STRING,
    PAY_BALANCE STRING,
    REFUND_BALANCE STRING,
    REFUND_CHANNEL STRING,
    ORDER_STATE STRING,
    PAYORDER_TIME BIGINT,
    CREATE_TIME BIGINT,
    UPDATE_TIME BIGINT,
    FAIL_REASON STRING,
    CHANNEL_ORDER_NO STRING,
    CREDIT_CARDNO STRING,
    CREDIT_BANK_NAME STRING,
    CREDIT_BANK_CODE STRING,
    REFUND_FINISH_TIME BIGINT
)  WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm_sm41.TFT_TSM.T_DELETE_CARD_DATA_SUB',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'oracle_tsm_sm41.t_delete_card_data_sub',
'scan.startup.mode' = 'earliest-offset', -- earliest-offset
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE table T_DELETE_CARD_DATA_SUB1(
    SUB_ORDER_NO STRING,
    USERID STRING,
    PAY_ORDER_NO STRING,
    PARENT_ORDER_NO STRING,
    PAY_BALANCE STRING,
    REFUND_BALANCE STRING,
    REFUND_CHANNEL STRING,
    ORDER_STATE STRING,
    PAYORDER_TIME TIMESTAMP,
    CREATE_TIME TIMESTAMP,
    UPDATE_TIME TIMESTAMP,
    FAIL_REASON STRING,
    CHANNEL_ORDER_NO STRING,
    CREDIT_CARDNO STRING,
    CREDIT_BANK_NAME STRING,
    CREDIT_BANK_CODE STRING,
    REFUND_FINISH_TIME TIMESTAMP,
    PRIMARY KEY (SUB_ORDER_NO) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.5.2:1521:tftong2',
'table-name' = 'T_DELETE_CARD_DATA_SUB_NEW',
'username' = 'tft_tsm',
'password' = '8p9o1LeAiZJ4c9GF',
'sink.buffer-flush.max-rows' = '20000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO T_DELETE_CARD_DATA_SUB1
SELECT
        SUB_ORDER_NO,
        USERID,
        PAY_ORDER_NO,
        PARENT_ORDER_NO,
        PAY_BALANCE,
        REFUND_BALANCE,
        REFUND_CHANNEL,
        ORDER_STATE,
        TO_TIMESTAMP(FROM_UNIXTIME(PAYORDER_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') PAYORDER_TIME,
        TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') CREATE_TIME,
        TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') UPDATE_TIME,
        FAIL_REASON,
        CHANNEL_ORDER_NO ,
        IF(CHAR_LENGTH(CREDIT_CARDNO) < 20, sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', CREDIT_CARDNO), CREDIT_CARDNO) as CREDIT_CARDNO ,
        CREDIT_BANK_NAME ,
        CREDIT_BANK_CODE ,
        TO_TIMESTAMP(FROM_UNIXTIME(REFUND_FINISH_TIME/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') REFUND_FINISH_TIME
  FROM T_DELETE_CARD_DATA_SUB;