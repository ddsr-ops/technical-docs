select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230527' group by trade_no) old
left join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230527' group by trade_no) new
on old.trade_no = new.trade_no where new.trade_no is null;  

select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230528' group by trade_no) old
right join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230528' group by trade_no) new
on old.trade_no = new.trade_no where old.trade_no is null;

select * from (select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt = '20230528' group by trade_no) old
join
(select trade_no, count(*) as cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt = '20230528' group by trade_no) new
on old.trade_no = new.trade_no where old.cnt <> new.cnt;

select old.data_dt, old.cnt, new.cnt from 
(select data_dt,  count(*) cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
  where data_dt >= '20230527' and data_dt < '20230529' group by data_dt ) old join 
(select data_dt,  count(*) cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
  where data_dt >= '20230527' and data_dt < '20230529' group by data_dt) new
on old.data_dt = new.data_dt order by 1; 

select old.data_dt, old.cnt, new.cnt from 
(select data_dt,  count(*) cnt from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
  where data_dt >= '20230527' and data_dt < '20230529' group by data_dt ) old join 
(select date_format(ts, 'yyyyMMdd') as ts_date,  count(*) cnt 
   from (select timestamp(get_json_object(debezium_source, '$.ts_ms')/1000 + 8*3600) as ts, 1 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230526' and data_dt < '20230529') t
  where ts >= '2023-05-27' 
    and ts <  '2023-05-29'
  group by date_format(ts, 'yyyyMMdd')) new
on old.data_dt = new.ts_date order by 1; 


select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230526' and trade_no > '20230531000000000000' and trade_no <'20230601000000000000';
select count(distinct trade_no) from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230526' and trade_no > '20230531000000000000' and trade_no <'20230601000000000000';

select * from 
(select distinct trade_no from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230526' and trade_no > '20230528000000000000' and trade_no <'20230529000000000000') m left join
(select distinct trade_no from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230526' and trade_no > '20230528000000000000' and trade_no <'20230529000000000000') l on m.trade_no = l.trade_no
where l.trade_no is null limit 10; 

select count(*) from 
(select distinct trade_no from hadoop_catalog.stg.t_tft_tsm_t_trade_info where data_dt >= '20230527' and trade_no > '20230530000000000000' and trade_no <'20230531000000000000') as info
left join 
(select distinct trade_no from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where data_dt >= '20230527' and trade_no > '20230530000000000000' and trade_no <'20230531000000000000') as info_new
on info.trade_no = info_new.trade_no
where info_new.trade_no is null ;

select count(*) from hadoop_catalog.stg.t_tft_tsm_t_trade_info where trade_no in ('20230530072902247568', '20230530072905247671', '20230530082445531777');
select count(*) from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new where trade_no in ('20230530072902247568', '20230530072905247671', '20230530082445531777');

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230527' and debezium_op = 'd' and create_time > '2023-05-01' limit 100;

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
 where data_dt >= '20230528' and debezium_op = 'd' and create_time > '2023-05-01' limit 100;

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230531' and trade_no in ('20230601182509119874') order by trade_no , kafka_offset;

select trade_no, trade_state, version, debezium_op, settle_trade_time, create_time, update_time, debezium_source
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
 where data_dt >= '20230531' and trade_no in ('20230601182509119874') order by trade_no , kafka_offset;

select * 
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;

select * 
 from hadoop_catalog.stg.t_tft_tsm_t_trade_info_new 
 where data_dt >= '20230505' and trade_no in ('20230505184503471182') order by trade_no , kafka_offset;

