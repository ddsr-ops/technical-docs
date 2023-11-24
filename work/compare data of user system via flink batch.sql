[root@preRTDH-flink151 flink-1.16.1]# cd /root/workspace/gch/flink-1.16.1

bin/start-cluster.sh
bin/sql-client.sh embedded

-- 执行完毕后，别忘记关闭集群
bin/stop-cluster.sh

-- conf/flink-conf.yml
taskmanager.memory.process.size: 25000m
taskmanager.memory.managed.fraction: 0.2


set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
SET execution.runtime-mode = 'batch';
set 'parallelism.default' = '4';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

-- DROP TABLE certification_result_0;
CREATE TABLE certification_result_0(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_0',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_1(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_1',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_2(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_2',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_3(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_3',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_4(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_4',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_5(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_5',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_6(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_6',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_7(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_7',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_8(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_8',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_9(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_9',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_10(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_10',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_11(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_11',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_12(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_12',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_13(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_13',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_14(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_14',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_15(
 USER_ID BIGINT,
 IS_DELETE TINYINT,
 ID              DECIMAL(20,0),
 OLD_USER_ID     BIGINT,
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 CREATE_TIME     TIMESTAMP,
 CLIENT_CODE     STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'certification_result_15',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
 

-- DROP TABLE tft_user_auth_res;
CREATE TABLE tft_user_auth_res(
 ID              DECIMAL(20,0),
 USER_ID         DECIMAL(20,0),
 USER_NAME       STRING,
 USER_PHONE      STRING,
 ID_CARD         STRING,
 BANK_CARD       STRING,
 REG_CHL         STRING,
PRIMARY KEY (ID) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.166.83.1:60001/msx_online',
'table-name' = 'tft_user_auth_res',
'username' = 'ywuser',
'password' = 'ywuser#!123'
);


CREATE TABLE print_table (
 OLD_ID              DECIMAL(20,0),
 OLD_USER_ID         DECIMAL(20,0),
 OLD_USER_NAME       STRING,
 OLD_USER_PHONE      STRING,
 OLD_ID_CARD         STRING,
 OLD_BANK_CARD       STRING,
 OLD_REG_CHL         STRING,
 NEW_ID              DECIMAL(20,0),
 NEW_OLD_USER_ID     BIGINT,
 NEW_USER_NAME       STRING,
 NEW_USER_PHONE      STRING,
 NEW_ID_CARD         STRING,
 NEW_BANK_CARD       STRING,
 NEW_CREATE_TIME     TIMESTAMP,
 CLIENT_CODE         STRING
) WITH (
  'connector' = 'print'
);

INSERT INTO print_table
select O.*, N.* from
(select * from tft_user_auth_res where REG_CHL = 'A01') O join (
select * from certification_result_0 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_1 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_2 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_3 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_4 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_5 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_6 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_7 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_8 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_9 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31'  and CLIENT_CODE = 'TFT' union all
select * from certification_result_10 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT' union all
select * from certification_result_11 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT' union all
select * from certification_result_12 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT' union all
select * from certification_result_13 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT' union all
select * from certification_result_14 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT' union all
select * from certification_result_15 where CREATE_TIME >= '2023-03-01' and CREATE_TIME <= '2023-03-31' and CLIENT_CODE = 'TFT'
) N
ON O.USER_ID = N.OLD_USER_ID
WHERE IF(O.USER_NAME IS NULL OR CHAR_LENGTH(O.USER_NAME) = 0, 'TFTXXXXXXXXXX$*#', O.USER_NAME) <> IF(N.USER_NAME IS NULL OR CHAR_LENGTH(N.USER_NAME) = 0, 'TFTXXXXXXXXXX$*#', N.USER_NAME)
   OR IF(O.USER_PHONE IS NULL OR CHAR_LENGTH(O.USER_PHONE) = 0, 'TFTXXXXXXXXXX$*#', O.USER_PHONE) <> IF(N.USER_PHONE IS NULL OR CHAR_LENGTH(N.USER_PHONE) = 0, 'TFTXXXXXXXXXX$*#', N.USER_PHONE)
   OR IF(O.ID_CARD IS NULL OR CHAR_LENGTH(O.ID_CARD) = 0, 'TFTXXXXXXXXXX$*#', O.ID_CARD) <> IF(N.ID_CARD IS NULL OR CHAR_LENGTH(N.ID_CARD) = 0, 'TFTXXXXXXXXXX$*#', N.ID_CARD)
   OR IF(O.BANK_CARD IS NULL OR CHAR_LENGTH(O.BANK_CARD) = 0, 'TFTXXXXXXXXXX$*#', O.BANK_CARD) <> IF(N.BANK_CARD IS NULL OR CHAR_LENGTH(N.BANK_CARD) = 0, 'TFTXXXXXXXXXX$*#', N.BANK_CARD);


WHERE IFNULL(O.USER_NAME, 'TFTXXXXXXXXXX$*#') <> IFNULL(N.USER_NAME, 'TFTXXXXXXXXXX$*#')
   OR IFNULL(O.USER_PHONE, 'TFTXXXXXXXXXX$*#') <> IFNULL(N.USER_PHONE, 'TFTXXXXXXXXXX$*#')
   OR IFNULL(O.ID_CARD, 'TFTXXXXXXXXXX$*#') <> IFNULL(N.ID_CARD, 'TFTXXXXXXXXXX$*#')
   OR IFNULL(O.BANK_CARD, 'TFTXXXXXXXXXX$*#') <> IFNULL(N.BANK_CARD, 'TFTXXXXXXXXXX$*#');

=====================================================================================================

set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
SET execution.runtime-mode = 'batch';
set 'parallelism.default' = '4';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';

-- DROP TABLE user_0;
CREATE TABLE user_0(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_0',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_1(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_1',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_2(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_2',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_3(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_3',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_4(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_4',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_5(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_5',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_6(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_6',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_7(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_7',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_8(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_8',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_9(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_9',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_10(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_10',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_11(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_11',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_12(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_12',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_13(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_13',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_14(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_14',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE user_15(
user_id bigint,
old_user_id   bigint,
 phone  string,
client_code string,
status tinyint,
 certification_status tinyint,
 is_delete tinyint
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/user_core?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'user_15',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

create table t_user_extend(
user_id string, cellphone string, status string, channel_id string
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:oracle:thin:@10.60.6.4:1521:tftfxq2',
'table-name' = 'tft_uo.t_user_extend', 
'username' = 'logminer',
'password' = 'Logminer#$321'
);

-- CH20181212103044BEVX 市民云  TFSMY
-- CH20201121024115HPLH 重庆市民通  SMT

CREATE TABLE print_table (
 user_id string,
 cellphone string,
 status1 string,
 client_code1 string,
 old_user_id bigint,
 phone string,
 client_code2 string,
 status2 tinyint,
 certification_status tinyint, 
 is_delete tinyint
) WITH (
  'connector' = 'print'
);

insert into print_table
select * from
(select user_id, cellphone, status, if(channel_id = 'CH20181212103044BEVX', 'TFSMY', 'SMT') as client_code from t_user_extend where status in ('00','11','21') AND  channel_id in ('CH20181212103044BEVX', 'CH20201121024115HPLH')) a
left join (
select old_user_id, phone, client_code, status, certification_status, is_delete from user_0 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_1 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_2 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_3 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_4 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_5 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_6 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_7 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_8 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_9 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_10 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_11 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_12 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_13 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_14 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0 union all
select old_user_id, phone, client_code, status, certification_status, is_delete from user_15 where client_code in ( 'TFSMY', 'SMT') and status = 1 and certification_status = 1 and is_delete = 0) b
on a.user_id = cast(b.old_user_id as string) and a.client_code = b.client_code
where if(a.cellphone is null or char_length(a.cellphone) = 0, 
'tftxxxxxxxxxx$*#', a.cellphone) <> if(b.phone is null or char_length(b.phone) = 0, 'tftxxxxxxxxxx$*#', b.phone)
   or b.old_user_id is null;



CREATE TABLE user_base
(
    user_id      bigint,
    mobile_phone string,
    reg_chl      string,
    reg_date     timestamp
) WITH (
      'connector' = 'jdbc',
      'url' = 'jdbc:mysql://10.166.83.1:60001/msx_online?tinyInt1isBit=false&transformedBitIsBoolean=false',
      'table-name' = 'user_base',
      'username' = 'ywuser',
      'password' = 'ywuser#!123',
      'scan.partition.column' = 'user_id',
      'scan.partition.num' = '8',
      'scan.partition.lower-bound' = '1000000000059283',
      'scan.partition.upper-bound' = '9999999999999999'
      );


CREATE TABLE print_table (
 user_id bigint,
 mobile_phone string,
 reg_chl string,
 reg_date timestamp,
 user_id1 bigint,
 old_user_id bigint,
 phone string,
 client_code2 string,
 status2 tinyint,
 certification_status tinyint, 
 is_delete tinyint
) WITH (
  'connector' = 'print'
);
insert into print_table
select * from
(select user_id, mobile_phone, reg_chl, reg_date from user_base where reg_chl like '%\"A01\":\"10\"%') a 
join (
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_0 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_1 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_2 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_3 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_4 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_5 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_6 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_7 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_8 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_9 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_10 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_11 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_12 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_13 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_14 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone, client_code, status, certification_status, is_delete from user_15 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0) b
on a.user_id = b.old_user_id;



CREATE TABLE print_table (
 user_id bigint,
 mobile_phone string,
 reg_chl string,
 reg_date timestamp,
 new_user_id bigint,
 is_delete tinyint,
 id              decimal(20,0),
 old_user_id     bigint,
 user_name       string,
 user_phone      string,
 id_card         string,
 bank_card       string,
 create_time     timestamp,
 client_code     string
) WITH (
  'connector' = 'print'
);

-- create a csv table located at the local directory
CREATE TABLE csv_table (
 user_id bigint,
 mobile_phone string,
 reg_chl string,
 reg_date timestamp,
 new_user_id bigint,
 is_delete tinyint,
 id              decimal(20,0),
 old_user_id     bigint,
 user_name       string,
 user_phone      string,
 id_card         string,
 bank_card       string,
 create_time     timestamp,
 client_code     string
) WITH (
  'connector' = 'filesystem',           -- required: specify the connector
  'path' = 'file:///tmp/20230728',  -- required: path to a directory
  'format' = 'csv'
);
insert into csv_table
select * from
(select user_id, mobile_phone, reg_chl, reg_date from user_base where reg_chl like '%\"A01\":\"10\"%') a 
join (
select * from certification_result_0  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_1  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_2  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_3  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_4  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_5  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_6  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_7  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_8  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_9  where IS_DELETE = 0 AND  CLIENT_CODE = 'TFT' union all
select * from certification_result_10 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT' union all
select * from certification_result_11 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT' union all
select * from certification_result_12 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT' union all
select * from certification_result_13 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT' union all
select * from certification_result_14 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT' union all
select * from certification_result_15 where IS_DELETE = 0 AND CLIENT_CODE = 'TFT') b
on a.user_id = b.OLD_USER_ID;



# Check phone of records from two databases are not equal

-- create a csv table located at the local directory
CREATE TABLE csv_table (
 old_user_id     bigint,
 user_id         bigint,
 old_phone       string,
 new_phone       string
) WITH (
  'connector' = 'filesystem',           -- required: specify the connector
  'path' = 'file:///tmp/20230821',  -- required: path to a directory
  'format' = 'csv'
);
insert into csv_table
select a.old_user_id, user_id, old_phone, new_phone from
(select user_id as old_user_id, mobile_phone as old_phone from user_base where reg_chl like '%\"A01\":\"11\"%') a 
join (
select user_id, old_user_id, phone as new_phone from user_0 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_1 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_2 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_3 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_4 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_5 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_6 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_7 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_8 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_9 where client_code in (  'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_10 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_11 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_12 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_13 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_14 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0 union all
select user_id, old_user_id, phone as new_phone from user_15 where client_code in ( 'TFT') and certification_status = 1 and is_delete = 0) b
on a.old_user_id = b.old_user_id
where if(a.old_phone is null or char_length(a.old_phone) = 0, 
'tftxxxxxxxxxx$*#', a.old_phone) <> if(b.new_phone is null or char_length(b.new_phone) = 0, 'tftxxxxxxxxxx$*#', b.new_phone);


CREATE TABLE id_card_link_person_id_0(
  id bigint,
  id_card   string,
  person_id   bigint,
  create_time timestamp,
  update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_0',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_1(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_1',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_2(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_2',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_3(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_3',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_4(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_4',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_5(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_5',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_6(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_6',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

CREATE TABLE id_card_link_person_id_7(
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://10.60.3.56:60001/certification?tinyInt1isBit=false&transformedBitIsBoolean=false',
'table-name' = 'id_card_link_person_id_7',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);

-- create a csv table located at the local directory
CREATE TABLE csv_table (
id bigint,
id_card   string,
person_id   bigint,
create_time timestamp,
update_time timestamp
) WITH (
'connector' = 'filesystem',           -- required: specify the connector
'path' = 'file:///tmp/20231018',  -- required: path to a directory
'format' = 'csv'
);
insert into csv_table
select * from (
  select * from id_card_link_person_id_0 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_1 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_2 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_3 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_4 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_5 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_6 where char_length(id_card) > 44
  union all
  select * from id_card_link_person_id_7 where char_length(id_card) > 44
) t;


-- create a csv table located at the local directory
CREATE TABLE csv_table (
old_user_id     bigint,
old_user_id1     bigint,
user_id         bigint,
old_phone       string,
new_phone       string
) WITH (
'connector' = 'filesystem',           -- required: specify the connector
'path' = 'file:///tmp/20231123',  -- required: path to a directory
'format' = 'csv'
);
insert into csv_table
with a as (select user_id as old_user_id, mobile_phone as old_phone from user_base where reg_chl like '%"A01":"1%'),  -- "\" escape not needed from flink 1.16
     b as (
         select user_id, old_user_id, phone as new_phone from user_0 where client_code in (  'TFT') and is_delete = 0 union all -- all fields not null
         select user_id, old_user_id, phone as new_phone from user_1 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_2 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_3 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_4 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_5 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_6 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_7 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_8 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_9 where client_code in (  'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_10 where client_code in ( 'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_11 where client_code in ( 'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_12 where client_code in ( 'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_13 where client_code in ( 'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_14 where client_code in ( 'TFT') and is_delete = 0 union all
         select user_id, old_user_id, phone as new_phone from user_15 where client_code in ( 'TFT') and is_delete = 0)
select a.old_user_id, b.old_user_id, user_id, old_phone, new_phone
from a
         left join b
                   on a.old_user_id = b.old_user_id
where a.old_phone <> b.new_phone
   or b.new_phone is null
union
select a.old_user_id, b.old_user_id, user_id, old_phone, new_phone
from a
         left join b
                   on a.old_phone = b.new_phone
where a.old_user_id <> b.old_user_id
   or b.old_user_id is null;



cd /opt/flink-1.16.1
-- stop yarn application cluster
echo "stop"|bin/yarn-session.sh -id application_1687554986023_0026
   -- application id from cat /tmp/.yarn-properties-root
bin/yarn-session.sh -d -s 1 -tm 20000 -D taskmanager.memory.managed.fraction=0.2
   -- Using -D option can pass parameters configured in flink-conf.yaml, https://nightlies.apache.org/flink/flink-docs-release-1.16/docs/deployment/resource-providers/yarn/
bin/sql-client.sh -s yarn-session -l ~/workspace/gch/flink-1.16.1/lib -f sql/user-system/20231108.sql
   -- set commands in sessions created by sql-client.sh can not set  taskmanager.memory.managed.fraction, https://nightlies.apache.org/flink/flink-docs-release-1.16/docs/dev/table/sqlclient/#sql-client-configuration

-- Attention: taskmanager.memory.managed.fraction can not be specified in sql script used by sql-client.sh


CREATE TABLE print_table
(
    user_id              string,
    old_user_id          bigint
) WITH (
      'connector' = 'filesystem', -- required: specify the connector
      'path' = 'file:///tmp/20231108', -- required: path to a directory
      'format' = 'csv'
      );

insert into print_table
select a.user_id, b.old_user_id from
    (select user_id, cellphone, status, if(channel_id = 'CH20181212103044BEVX', 'TFSMY', 'SMT') as client_code from t_user_extend where status in ('00','11','21') AND  channel_id in ('CH20181212103044BEVX', 'CH20201121024115HPLH')) a
        left join (
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_0  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_1  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_2  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_3  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_4  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_5  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_6  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_7  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_8  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_9  where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_10 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_11 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_12 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_13 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_14 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0 union all
        select old_user_id, phone, client_code, status, certification_status, is_delete from user_15 where client_code in ( 'TFSMY', 'SMT')  and is_delete = 0) b
                  on a.user_id = cast(b.old_user_id as string) and a.client_code = b.client_code
where b.old_user_id is null;