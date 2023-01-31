# Goal
Migrate oracle/mysql data using flink-sql.

Note: `insert into` would delete rows in the sink table when meeting the row which the operation is `d`. 

# Install a standalone flink cluster

Download the recent package from [url](https://flink.apache.org/downloads.html). Unpack the tar file, then modify the config file.

```shell
tar -zxf flink-1.15.1-bin-scala_2.12.tgz

cd conf

vim masters 
localhost:8181

vim workers 
localhost
localhost

vim flink-conf.yaml
rest.port: 8181
rest.bind-address: 0.0.0.0
```

Add the following essential jars to $FLINK_HOME/lib:

```
flink-sql-connector-kafka-1.15.0
flink-udf-1.0-SNAPSHOT.jar
flink-connector-jdbc-1.15.0.jar
ojdbc8-12.2.0.1.jar
mysql-connector-java-8.0.28.jar
```

Start the standalone cluster via issuing `bin/start-cluster.sh`


# Flink SQL

Launch a sql client, `bin/sql-client.sh embedded`

As for data type mapping between flink sql and oracle, refer to the last section references.

Note£ºthe length of new columns commonly are longer than original values.

```
set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
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
'topic' = 'devora_adhoc3.TFT_TSM.T_EINVOICE_INFO',
'properties.bootstrap.servers' = '88.88.16.189:9093',
'properties.group.id' = 'flink_sql',
'scan.startup.mode' = 'earliest-offset',
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
'url' = 'jdbc:oracle:thin:@88.88.16.112:1521:ora11g',
'table-name' = 't_einvoice_info1',
'username' = 'tft_tsm',
'password' = 'tft_tsm'
);


create temporary function encrypt as 'com.tft.flink.udf.NationalAlgorithmUdf';

insert into t_einvoice_info1 select 
ORDER_NO, 
EINVOICE_TYPE, 
EINVOICE_HEADER, 
EINVOICE_TAX_NUMBER, 
EINVOICE_AMOUNT, 
REFUND_AMOUNT, 
EINVOICE_CONTENT, 
EMAIL_NUMBER, 
REMARK, 
ADDRESS_AND_PHONE_NO, 
encrypt(BANK_NO) AS BANK_NO, 
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
'topic' = 'devora_adhoc3.TFT_TSM.T_ACCOUNT_REFUNDS_INFO',
'properties.bootstrap.servers' = '88.88.16.189:9093',
'properties.group.id' = 'flink_sql',
'scan.startup.mode' = 'earliest-offset',
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
'url' = 'jdbc:oracle:thin:@88.88.16.112:1521:ora11g',
'table-name' = 't_account_refunds_info1',
'username' = 'tft_tsm',
'password' = 'tft_tsm'
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
encrypt(REFUND_USERNAME) as REFUND_USERNAME, 
encrypt(BANK_CARDNO) AS BANK_CARDNO, 
BANK_CARDTYPE, 
encrypt(IDCARD) AS IDCARD, 
TO_TIMESTAMP(FROM_UNIXTIME(CREATETIME/1000, 'YYYY-MM-DD HH:MM:SS'), 'YYYY-MM-DD HH:MM:SS') AS CREATETIME, 
TO_TIMESTAMP(FROM_UNIXTIME(CREATETIME/1000, 'YYYY-MM-DD HH:MM:SS'), 'YYYY-MM-DD HH:MM:SS') AS UPDATETIME, 
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
'topic' = 'devora_adhoc3.TFT_TSM.T_BINDING_CREDIT_CARD',
'properties.bootstrap.servers' = '88.88.16.189:9093',
'properties.group.id' = 'flink_sql',
'scan.startup.mode' = 'earliest-offset',
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
'url' = 'jdbc:oracle:thin:@88.88.16.112:1521:ora11g',
'table-name' = 't_binding_credit_card1',
'username' = 'tft_tsm',
'password' = 'tft_tsm'
);

INSERT INTO t_binding_credit_card1
SELECT
encrypt(CREDIT_CARD_NO) AS CREDIT_CARD_NO, 
USERID, 
CREDIT_CARD_PHONENO, 
TOKEN, 
TRID, 
TOKENLEVEL, 
TOKENBEGIN, 
TOKENEND, 
TOKENTYPE, 
TO_TIMESTAMP(FROM_UNIXTIME(BINDING_TIME/1000, 'YYYY-MM-DD HH:MM:SS'), 'YYYY-MM-DD HH:MM:SS') AS BINDING_TIME, 
TO_TIMESTAMP(FROM_UNIXTIME(UPDATE_TIME/1000, 'YYYY-MM-DD HH:MM:SS'), 'YYYY-MM-DD HH:MM:SS') AS UPDATE_TIME, 
ORDERID, 
STATUS, 
encrypt(IDCARD) AS IDCARD, 
encrypt(BANKCARD_REALNAME) AS BANKCARD_REALNAME, 
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
'topic' = 'devora_adhoc3.TFT_TSM.T_CREDIT_REMOVE_RECORD',
'properties.bootstrap.servers' = '88.88.16.189:9093',
'properties.group.id' = 'flink_sql',
'scan.startup.mode' = 'earliest-offset',
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
'url' = 'jdbc:oracle:thin:@88.88.16.112:1521:ora11g',
'table-name' = 't_credit_remove_record1',
'username' = 'tft_tsm',
'password' = 'tft_tsm'
);

INSERT INTO T_CREDIT_REMOVE_RECORD1
SELECT
    encrypt(CARD_NO) as CARD_NO,
    TO_TIMESTAMP(FROM_UNIXTIME(CREATE_TIME/1000, 'YYYY-MM-DD HH:MM:SS'), 'YYYY-MM-DD HH:MM:SS') AS CREATE_TIME, 
    ID,
    ORDERID,
    REMARK,
    STATUS,
    USERID
  FROM T_CREDIT_REMOVE_RECORD;



CREATE TABLE tbl_fcl_user_code(
id bigint, 
user_id string, 
user_pinNum string, 
saltValue string, 
pinStatus string,
failCount string,
first_fail_tm string, 
rec_crt_ts string, 
rec_upd_ts string
) WITH (
'connector' = 'kafka',
'topic' = 'mysql_0_adhoc1.tftactdb.tbl_fcl_user_code',
'properties.bootstrap.servers' = '88.88.16.189:9093',
'properties.group.id' = 'tbl_fcl_user_code',
'scan.startup.mode' = 'earliest-offset',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

CREATE TABLE tbl_fcl_user_code1(
id bigint, 
user_id string, 
user_pinNum string, 
saltValue string, 
pinStatus string,
failCount string,
first_fail_tm string, 
rec_crt_ts string, 
rec_upd_ts string,
sm4Pinnum string,
PRIMARY KEY (user_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:mysql://88.88.16.113:3306/tftactdb',
'table-name' = 'tbl_fcl_user_code1',
'username' = 'root',
'password' = 'root'
);

INSERT INTO tbl_fcl_user_code1
SELECT
id, 
user_id, 
user_pinNum, 
saltValue, 
pinStatus,
failCount,
first_fail_tm, 
replace(replace(rec_crt_ts, 'T', ' '), '+08:00', '') as rec_crt_ts, 
replace(replace(rec_upd_ts, 'T', ' '), '+08:00', '') as rec_upd_ts,
encrypt(user_pinNum) as sm4Pinnum
FROM tbl_fcl_user_code;

```


# References
https://blog.csdn.net/appleyuchi/article/details/113426020
https://nightlies.apache.org/flink/flink-docs-release-1.15/docs/connectors/table/jdbc/#data-type-mapping
https://nightlies.apache.org/flink/flink-docs-release-1.13/docs/dev/table/functions/systemfunctions/

# More works to do 

1. Check whether all indexes are built on the new table

2. Analyze tables or gather table statistics

3. Build a SQL to verify whether the data is correct

# Check SQL

Assistant sql:

```
# Oracle
select case
         when nullable = 'Y' then
          'nvl(old.' || lower(column_name) || ',0) = ' || 'nvl(new.' ||
          lower(column_name) || ',0) and'
         when nullable = 'N' then
          'old.' || lower(column_name) || ' = ' || 'new.' ||
          lower(column_name) || ' and'
         else
          ''
       end as "AND", 
			 case
         when nullable = 'Y' then
          'nvl(old.' || lower(column_name) || ',0) != ' || 'nvl(new.' ||
          lower(column_name) || ',0) or'
         when nullable = 'N' then
          'old.' || lower(column_name) || ' != ' || 'new.' ||
          lower(column_name) || ' or'
         else
          ''
       end as "OR",  'D.'||lower(column_name)||' = '|| 'S.'||lower(column_name)||',' as "=",  'D.'||lower(column_name)||',' as "D",  'S.'||lower(column_name)||',' as "S" ,
       column_name||' '||decode(data_type, 'DATE', 'BIGINT', 'STRING')||',' as source_data_type, column_name||' '||decode(data_type, 'DATE', 'TIMESTAMP', 'STRING')||',' as sink_data_type,
       column_name||','
  from dba_tab_cols
 where table_name = upper('T_CREDIT_REMOVE_RECORD') order by column_name;
 
 
# MySQL
select case
         when is_nullable = 'YES' then
          concat_ws('',
                    'ifnull(old.',
                    lower(column_name),
                    ',0) = ',
                    'ifnull(new.',
                    lower(column_name),
                    ',0) and')
         when is_nullable = 'NO' then
          concat_ws('',
                    'old.',
                    lower(column_name),
                    ' = ',
                    'new.',
                    lower(column_name),
                    ' and')
         else
          ''
       end as "AND",
       case
         when is_nullable = 'YES' then
          concat_ws('',
                    'ifnull(old.',
                    lower(column_name),
                    ',0) != ',
                    'ifnull(new.',
                    lower(column_name),
                    ',0) or')
         when is_nullable = 'NO' then
          concat_ws('',
                    'old.',
                    lower(column_name),
                    ' != ',
                    'new.',
                    lower(column_name),
                    ' or')
         else
          ''
       end as "OR"
  from information_schema.columns
 where table_name = upper('tbl_fcl_user_code');


```

```sql
with new as
 (select *
    from tft_tsm.t_account_refunds_info1 t
   WHERE t.updatetime >=
         to_date('2001-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.updatetime <
         to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
old as
 (select *
    from tft_tsm.t_account_refunds_info t
   WHERE t.updatetime >=
         to_date('2001-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.updatetime <
         to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where old.userid = new.userid
           and old.refund_trandno = new.refund_trandno
           and old.refund_amount = new.refund_amount
           and old.actual_refund_amount = new.actual_refund_amount
           and old.deduct_amount = new.deduct_amount
           and old.refund_poundage = new.refund_poundage
           and old.refund_bankinfo = new.refund_bankinfo
           and old.refund_status = new.refund_status
           and nvl(old.refund_status_msg, 0) = nvl(new.refund_status_msg, 0)
           and old.refund_username = new.refund_username
           and old.bank_cardno = new.bank_cardno
           and old.bank_cardtype = new.bank_cardtype
           and old.idcard = new.idcard
           and old.createtime = new.createtime
           and old.updatetime = new.updatetime
           and nvl(old.poundage_type, 0) = nvl(new.poundage_type, 0)
           and nvl(old.poundage_refund_amount, 0) =
               nvl(new.poundage_refund_amount, 0)
           and nvl(old.audit_status, 0) = nvl(new.audit_status, 0)) identity_count,
       (select count(*)
          from new, old
         where old.refund_trandno = new.refund_trandno
           and (old.userid != new.userid or
               old.refund_amount != new.refund_amount or
               old.actual_refund_amount != new.actual_refund_amount or
               old.deduct_amount != new.deduct_amount or
               old.refund_poundage != new.refund_poundage or
               old.refund_bankinfo != new.refund_bankinfo or
               old.refund_status != new.refund_status or
               nvl(old.refund_status_msg, 0) !=
               nvl(new.refund_status_msg, 0) or
               old.refund_username != new.refund_username or
               old.bank_cardno != new.bank_cardno or
               old.bank_cardtype != new.bank_cardtype or
               old.idcard != new.idcard or old.createtime != new.createtime or
               old.updatetime != new.updatetime or
               nvl(old.poundage_type, 0) != nvl(new.poundage_type, 0) or
               nvl(old.poundage_refund_amount, 0) !=
               nvl(new.poundage_refund_amount, 0) or
               nvl(old.audit_status, 0) != nvl(new.audit_status, 0))) difference_count
  from dual;

with new as
 (select *
    from tft_tsm.t_einvoice_info1 t
   WHERE t.update_time >= to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
old as
 (select *
    from tft_tsm.t_einvoice_info t
   WHERE t.update_time >= to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where nvl(old.channel_code, 0) = nvl(new.channel_code, 0)
           and nvl(old.fail_msg, 0) = nvl(new.fail_msg, 0)
           and nvl(old.operator_type, 0) = nvl(new.operator_type, 0)
           and nvl(old.order_channel, 0) = nvl(new.order_channel, 0)
           and old.order_no = new.order_no
           and old.einvoice_type = new.einvoice_type
           and old.einvoice_header = new.einvoice_header
           and nvl(old.einvoice_tax_number, 0) =
               nvl(new.einvoice_tax_number, 0)
           and nvl(old.einvoice_amount, 0) = nvl(new.einvoice_amount, 0)
           and nvl(old.refund_amount, 0) = nvl(new.refund_amount, 0)
           and nvl(old.einvoice_content, 0) = nvl(new.einvoice_content, 0)
           and nvl(old.email_number, 0) = nvl(new.email_number, 0)
           and nvl(old.remark, 0) = nvl(new.remark, 0)
           and nvl(old.address_and_phone_no, 0) =
               nvl(new.address_and_phone_no, 0)
           and nvl(old.bank_no, 0) = nvl(new.bank_no, 0)
           and old.order_status = new.order_status
           and old.create_time = new.create_time
           and old.update_time = new.update_time
           and old.user_id = new.user_id
           and nvl(old.einvoice_no, 0) = nvl(new.einvoice_no, 0)
           and nvl(old.order_type, 0) = nvl(new.order_type, 0)
           and nvl(old.up_einvoice_no, 0) = nvl(new.up_einvoice_no, 0)
           and nvl(old.fp_hm, 0) = nvl(new.fp_hm, 0)
           and nvl(old.jym, 0) = nvl(new.jym, 0)
           and nvl(old.kprq, 0) = nvl(new.kprq, 0)
           and nvl(old.pdf_url, 0) = nvl(new.pdf_url, 0)
           and nvl(old.sp_url, 0) = nvl(new.sp_url, 0)
           and nvl(old.einvoice_order_type, 0) =
               nvl(new.einvoice_order_type, 0)) identity_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and (nvl(old.channel_code, 0) != nvl(new.channel_code, 0) or
               nvl(old.fail_msg, 0) != nvl(new.fail_msg, 0) or
               nvl(old.operator_type, 0) != nvl(new.operator_type, 0) or
               nvl(old.order_channel, 0) != nvl(new.order_channel, 0) or
               old.einvoice_type != new.einvoice_type or
               old.einvoice_header != new.einvoice_header or
               nvl(old.einvoice_tax_number, 0) !=
               nvl(new.einvoice_tax_number, 0) or
               nvl(old.einvoice_amount, 0) != nvl(new.einvoice_amount, 0) or
               nvl(old.refund_amount, 0) != nvl(new.refund_amount, 0) or
               nvl(old.einvoice_content, 0) != nvl(new.einvoice_content, 0) or
               nvl(old.email_number, 0) != nvl(new.email_number, 0) or
               nvl(old.remark, 0) != nvl(new.remark, 0) or
               nvl(old.address_and_phone_no, 0) !=
               nvl(new.address_and_phone_no, 0) or
               nvl(old.bank_no, 0) != nvl(new.bank_no, 0) or
               old.order_status != new.order_status or
               old.create_time != new.create_time or
               old.update_time != new.update_time or
               old.user_id != new.user_id or
               nvl(old.einvoice_no, 0) != nvl(new.einvoice_no, 0) or
               nvl(old.order_type, 0) != nvl(new.order_type, 0) or
               nvl(old.up_einvoice_no, 0) != nvl(new.up_einvoice_no, 0) or
               nvl(old.fp_hm, 0) != nvl(new.fp_hm, 0) or
               nvl(old.jym, 0) != nvl(new.jym, 0) or
               nvl(old.kprq, 0) != nvl(new.kprq, 0) or
               nvl(old.pdf_url, 0) != nvl(new.pdf_url, 0) or
               nvl(old.sp_url, 0) != nvl(new.sp_url, 0) or
               nvl(old.einvoice_order_type, 0) !=
               nvl(new.einvoice_order_type, 0))) difference_count
  from dual;


with new as
 (select *
    from tft_tsm.t_binding_credit_card1 t
   WHERE t.update_time >=
         to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time <
         to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
old as
 (select *
    from tft_tsm.t_binding_credit_card t
   WHERE t.update_time >=
         to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time <
         to_date('2030-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'))
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where old.credit_card_no = new.credit_card_no
           and old.userid = new.userid
           and old.credit_card_phoneno = new.credit_card_phoneno
           and nvl(old.token, 0) = nvl(new.token, 0)
           and nvl(old.trid, 0) = nvl(new.trid, 0)
           and nvl(old.tokenlevel, 0) = nvl(new.tokenlevel, 0)
           and nvl(old.tokenbegin, 0) = nvl(new.tokenbegin, 0)
           and nvl(old.tokenend, 0) = nvl(new.tokenend, 0)
           and nvl(old.tokentype, 0) = nvl(new.tokentype, 0)
           and nvl(old.binding_time, trunc(sysdate)) = nvl(new.binding_time, trunc(sysdate))
           and nvl(old.update_time, trunc(sysdate)) = nvl(new.update_time, trunc(sysdate))
           and old.orderid = new.orderid
           and old.status = new.status
           and old.idcard = new.idcard
           and old.bankcard_realname = new.bankcard_realname
           and nvl(old.credit_card_type, 0) = nvl(new.credit_card_type, 0)
           and nvl(old.credit_card_bankname, 0) =
               nvl(new.credit_card_bankname, 0)
           and nvl(old.single_limit_amount, 0) =
               nvl(new.single_limit_amount, 0)
           and nvl(old.everyday_limit_amount, 0) =
               nvl(new.everyday_limit_amount, 0)
           and nvl(old.bank_logo, 0) = nvl(new.bank_logo, 0)
           and nvl(old.credit_card_bgdlogo, 0) =
               nvl(new.credit_card_bgdlogo, 0)
        
        ) identity_count,
       (select count(*)
          from new, old
         where old.credit_card_no = new.credit_card_no
           and old.userid = new.userid
           and (old.credit_card_phoneno != new.credit_card_phoneno or
               nvl(old.token, 0) != nvl(new.token, 0) or
               nvl(old.trid, 0) != nvl(new.trid, 0) or
               nvl(old.tokenlevel, 0) != nvl(new.tokenlevel, 0) or
               nvl(old.tokenbegin, 0) != nvl(new.tokenbegin, 0) or
               nvl(old.tokenend, 0) != nvl(new.tokenend, 0) or
               nvl(old.tokentype, 0) != nvl(new.tokentype, 0) or
               nvl(old.binding_time, trunc(sysdate)) != nvl(new.binding_time, trunc(sysdate)) or
               nvl(old.update_time, trunc(sysdate)) != nvl(new.update_time, trunc(sysdate)) or
               old.orderid != new.orderid or old.status != new.status or
               old.idcard != new.idcard or
               old.bankcard_realname != new.bankcard_realname or
               nvl(old.credit_card_type, 0) != nvl(new.credit_card_type, 0) or
               nvl(old.credit_card_bankname, 0) !=
               nvl(new.credit_card_bankname, 0) or
               nvl(old.single_limit_amount, 0) !=
               nvl(new.single_limit_amount, 0) or
               nvl(old.everyday_limit_amount, 0) !=
               nvl(new.everyday_limit_amount, 0) or
               nvl(old.bank_logo, 0) != nvl(new.bank_logo, 0) or
               nvl(old.credit_card_bgdlogo, 0) !=
               nvl(new.credit_card_bgdlogo, 0))) difference_count
  from dual;

select (select count(*)
          from tftactdb.tbl_fcl_user_code1
         where rec_upd_ts > '2000-01-01 00:00:00'
           and rec_upd_ts < '2030-01-01 00:00:00') as new_total,
       (select count(*)
          from tftactdb.tbl_fcl_user_code
         where rec_upd_ts > '2000-01-01 00:00:00'
           and rec_upd_ts < '2030-01-01 00:00:00') as old_total,
       (select count(*)
          from (select *
                  from tftactdb.tbl_fcl_user_code1
                 where rec_upd_ts > '2000-01-01 00:00:00'
                   and rec_upd_ts < '2030-01-01 00:00:00') new,
               (select *
                  from tftactdb.tbl_fcl_user_code
                 where rec_upd_ts > '2000-01-01 00:00:00'
                   and rec_upd_ts < '2030-01-01 00:00:00') old
         where old.id = new.id
           and old.user_id = new.user_id
           and old.user_pinnum = new.user_pinnum
           and old.saltvalue = new.saltvalue
           and old.pinstatus = new.pinstatus
           and old.failcount = new.failcount
           and old.first_fail_tm = new.first_fail_tm
           and old.rec_crt_ts = new.rec_crt_ts
           and old.rec_upd_ts = new.rec_upd_ts
           and old.id = new.id
           and old.user_id = new.user_id
           and old.user_pinnum = new.user_pinnum
           and old.saltvalue = new.saltvalue
           and old.pinstatus = new.pinstatus
           and old.failcount = new.failcount
           and old.first_fail_tm = new.first_fail_tm
           and old.rec_crt_ts = new.rec_crt_ts
           and old.rec_upd_ts = new.rec_upd_ts) as identity_count,
       (select count(*)
          from (select *
                  from tftactdb.tbl_fcl_user_code1
                 where rec_upd_ts > '2000-01-01 00:00:00'
                   and rec_upd_ts < '2030-01-01 00:00:00') new,
               (select *
                  from tftactdb.tbl_fcl_user_code
                 where rec_upd_ts > '2000-01-01 00:00:00'
                   and rec_upd_ts < '2030-01-01 00:00:00') old
         where old.id = new.id
           and (old.user_pinnum != new.user_pinnum or
               old.saltvalue != new.saltvalue or
               old.pinstatus != new.pinstatus or
               old.failcount != new.failcount or
               old.first_fail_tm != new.first_fail_tm or
               old.rec_crt_ts != new.rec_crt_ts or
               old.rec_upd_ts != new.rec_upd_ts or old.id != new.id or
               old.user_id != new.user_id or
               old.user_pinnum != new.user_pinnum or
               old.saltvalue != new.saltvalue or
               old.pinstatus != new.pinstatus or
               old.failcount != new.failcount or
               old.first_fail_tm != new.first_fail_tm or
               old.rec_crt_ts != new.rec_crt_ts or
               old.rec_upd_ts != new.rec_upd_ts)) as diff_count;

```