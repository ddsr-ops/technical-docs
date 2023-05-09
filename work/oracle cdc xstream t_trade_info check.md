select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230507' group by trade_no) old
left join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230507' group by trade_no) new
on old.trade_no = new.trade_no where new.trade_no is null;  

select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230507' group by trade_no) old
right join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230507' group by trade_no) new
on old.trade_no = new.trade_no where old.trade_no is null;

select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230507' group by trade_no) old
join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230507' group by trade_no) new
on old.trade_no = new.trade_no where old.cnt <> new.cnt;

select old.data_dt, old.cnt, new.cnt from 
(select data_dt,  count(*) cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
  where data_dt >= '20230505' and data_dt < '20230508' group by data_dt ) old join 
(select data_dt,  count(*) cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
  where data_dt >= '20230505' and data_dt < '20230508' group by data_dt) new
on old.data_dt = new.data_dt order by 1; 

select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230424' and trade_no > '20230425000000000000' and trade_no <'20230504000000000000';
select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230424' and trade_no > '20230425000000000000' and trade_no <'20230504000000000000';

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230505' and debezium_op = 'd' and create_time > '2023-04-01' limit 100;

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;

select * 
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;

select * 
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;