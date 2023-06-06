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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_0',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_1(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_1',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_2(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_2',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_3(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_3',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_4(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_4',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_5(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_5',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_6(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_6',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_7(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_7',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_8(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_8',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_9(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_9',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_10(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_10',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_11(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_11',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_12(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_12',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_13(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_13',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_14(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
'table-name' = 'certification_result_14',
'username' = 'sync_user',
'password' = 'Sync_user12#'
);
CREATE TABLE certification_result_15(
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
'url' = 'jdbc:mysql://10.60.3.56:60001/certification',
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
tft_user_auth_res O join (
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
WHERE O.USER_NAME <> N.USER_NAME 
   OR O.USER_PHONE <> N.USER_PHONE
   OR O.ID_CARD <> N.ID_CARD
   OR O.BANK_CARD <> N.BANK_CARD;


