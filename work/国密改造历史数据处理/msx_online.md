create temporary function sm4_encrypt as 'com.tft.flink.udf.SM4EncryptUDF';

set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

CREATE TABLE user_base(
USER_ID bigint,
MOBILE_PHONE string,
USER_STATUS string,
REG_DATE bigint, -- datetime
USER_NAME string,
SEX string,
BIRTHDAY bigint, -- date
ID_TYPE string,
ID_NO string,
TERM_TYPE string,
TERM_TOKEN string,
PUSH_TOKEN string,
PASSWORD string,
CITY_ID string,
NICKNAME string,
PROFESSION string,
LAST_TOKEN_TIME bigint, -- date
USER_PROPERTIES string,
USER_IMAGE_PATH string,
REMARK string,
REG_CHL string,
PREPAID_CARD_NO string,
PREPAID_CARD_STATUS string,
PREPAID_CARD_EXPIRY_DATE bigint -- datetime
) WITH (
'connector' = 'kafka',
'topic' = 'mysql_msx.msx_online.user_base',
'properties.bootstrap.servers' = 'datanode1:9093,datanode2:9093,datanode3:9093,datanode4:9093,datanode5:9093',
'properties.group.id' = 'mysql_msx_sm4.user_base',
'scan.startup.mode' = 'group-offsets',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE user_base1(
USER_ID bigint,
MOBILE_PHONE string,
USER_STATUS string,
REG_DATE string, -- datetime
USER_NAME string,
SEX string,
BIRTHDAY string, -- date
ID_TYPE string,
ID_NO string,
TERM_TYPE string,
TERM_TOKEN string,
PUSH_TOKEN string,
PASSWORD string,
CITY_ID string,
NICKNAME string,
PROFESSION string,
LAST_TOKEN_TIME string, -- date
USER_PROPERTIES string,
USER_IMAGE_PATH string,
REMARK string,
REG_CHL string,
PREPAID_CARD_NO string,
PREPAID_CARD_STATUS string,
PREPAID_CARD_EXPIRY_DATE string, -- datetime
PRIMARY KEY (USER_ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.1:60001/msx_online',
'table-name' = 'user_base_new',
'username' = 'ywuser',
'password' = 'ywuser#!123',
'sink.buffer-flush.max-rows' = '10000',
'sink.buffer-flush.interval' = '0'
);

INSERT INTO user_base1
SELECT
USER_ID,
MOBILE_PHONE,
USER_STATUS,
DATE_FORMAT(FROM_UNIXTIME(REG_DATE/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as REG_DATE , -- datetime
USER_NAME,
SEX,
DATE_FORMAT(FROM_UNIXTIME(BIRTHDAY*24*3600, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd') as BIRTHDAY, -- date
ID_TYPE ,
ID_NO ,
TERM_TYPE ,
TERM_TOKEN ,
PUSH_TOKEN ,
sm4_encrypt('XjPJXPxwrOiNr7ybRJpqFA==', PASSWORD) as PASSWORD ,
CITY_ID ,
NICKNAME ,
PROFESSION ,
DATE_FORMAT(FROM_UNIXTIME(LAST_TOKEN_TIME*24*3600, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd') as LAST_TOKEN_TIME, -- date
USER_PROPERTIES ,
USER_IMAGE_PATH ,
REMARK ,
REG_CHL ,
PREPAID_CARD_NO ,
PREPAID_CARD_STATUS ,
DATE_FORMAT(FROM_UNIXTIME(PREPAID_CARD_EXPIRY_DATE/1000, 'yyyy-MM-dd HH:mm:ss'), 'yyyy-MM-dd HH:mm:ss') as PREPAID_CARD_EXPIRY_DATE -- datetime
FROM user_base;