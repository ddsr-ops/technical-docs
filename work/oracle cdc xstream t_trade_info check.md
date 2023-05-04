select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230430' group by trade_no) old
left join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230430' group by trade_no) new
on old.trade_no = new.trade_no where new.trade_no is null;  

select data_dt,  count(*) from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230429' and data_dt < '20230504' group by data_dt order by data_dt;
select data_dt,  count(*) from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230429' and data_dt < '20230504' group by data_dt order by data_dt;

select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230424' and trade_no > '20230425000000000000' and trade_no <'20230504000000000000';
select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230424' and trade_no > '20230425000000000000' and trade_no <'20230504000000000000';
