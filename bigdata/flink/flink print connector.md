Commonly, print connector is used to debug in production env, which output
was locate at log files of task manager.


set 'parallelism.default' = '6';
set execution.checkpointing.interval='6s';
set restart-strategy.fixed-delay.attempts=3;
set restart-strategy.fixed-delay.delay='10s';
set execution.checkpointing.externalized-checkpoint-retention='RETAIN_ON_CANCELLATION';


drop table t_trade_info ; 
CREATE TABLE t_trade_info(
    ORIGIN_PROPERTIES MAP<STRING, STRING> METADATA FROM 'value.source.properties' VIRTUAL,
    TRADE_NO STRING,
    ORDER_NO STRING,
    THIRD_TRADE_NO STRING,
    THIRD_REFUND_NO STRING,
    ACT_UP_TRADE_NO STRING,
    ACT_DOWN_TRADE_NO STRING,
    ACT_UP_REFUND_NO STRING,
    ACT_DOWN_REFUND_NO STRING,
    OUT_TRADE_NO STRING,
    OUT_REFUND_NO STRING,
    USER_ID STRING,
    PAY_TYPE STRING,
    TRADE_STATE STRING,
    TRADE_SCENE STRING,
    TRADE_EXTEND STRING,
    NOTIFY_URL STRING,
    TRADE_AMOUNT STRING,
    REFUND_AMOUNT STRING,
    TRADE_TIME BIGINT,
    REFUND_TIME STRING,
    SETTLE_DATE STRING,
    SETTLE_TRADE_TIME STRING,
    SETTLE_REFUND_TIME STRING,
    TAGS STRING,
    FAILED_CODE STRING,
    FAILED_MESSAGE STRING,
    STATUS STRING,
    CREATE_TIME BIGINT,
    UPDATE_TIME BIGINT,
    VERSION STRING
) WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm.TFT_TSM.T_TRADE_INFO',
'properties.bootstrap.servers' = '10.50.253.201:9093',
'properties.group.id' = 'gch.tsm.t_trade_info',
'scan.startup.mode' = 'specific-offsets',
'scan.startup.specific-offsets' = 'partition:0,offset:857000000;partition:1,offset:857000000;partition:2,offset:857000000',
'format' = 'debezium-json',
'debezium-json.schema-include' = 'false'
);

select TRADE_NO, TRADE_STATE, TRADE_TIME, STATUS,  VERSION, ORIGIN_PROPERTIES['txId'], ORIGIN_PROPERTIES['commit_scn'] from t_trade_info
where TRADE_NO = '20230407174904545068';

Note: the result may be not right. If you want to debug this, recommend engaging flink print connector. 













create table t_trade_info (
 before string, 
 after string, 
 source string,
 op string, 
 ts_ms bigint,
 transaction string
)  WITH (
'connector' = 'kafka',
'topic' = 'oracle_tsm.TFT_TSM.T_TRADE_INFO',
'properties.bootstrap.servers' = '10.50.253.201:9093',
'properties.group.id' = 'gch.tsm.t_trade_info',
'scan.startup.mode' = 'specific-offsets',
'scan.startup.specific-offsets' = 'partition:0,offset:872874620;partition:1,offset:872874620;partition:2,offset:872874620',
 'format' = 'json',
 'json.fail-on-missing-field' = 'false',
 'json.ignore-parse-errors' = 'true'
);

Here, specify scan.startup.specific-offsets as some offsets to reduce data to scan.


select JSON_VALUE(after, '$.TRADE_NO') from t_trade_info limit 5; 

select some rows to demonstrate the table is right.

CREATE TABLE print_t_trade_info WITH ('connector' = 'print')
LIKE t_trade_info (EXCLUDING ALL); 



insert into print_t_trade_info select * from t_trade_info where JSON_VALUE(after, '$.TRADE_NO') = '20230411183147746284'
 or JSON_VALUE(before, '$.TRADE_NO') = '20230411183147746284'; 

Submit a job . 





