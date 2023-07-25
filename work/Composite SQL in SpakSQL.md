select concat('INSERT INTO `bwt_ttsp_tdtp`.`b_user_credit`(`id`, `op_id`, `service_id`, `user_id`, `credit_day`, `amount`) values(', '\'',
100000000000000000 + rn, '\',', '\'', '2303257630671872', '\',', '\'', 'METRO','\',', '\'', user_id, '\',','\'','2023-07-23', '\',',sum_amount, ');')
from ( 
select user_id, sum(amount) as sum_amount, row_number() over(order by user_id) as rn from (select
         user_id, amount,
         row_number() over(partition by id order by debezium_time desc, kafka_offset desc) as rk
       from
         hadoop_catalog.stg.t_bwt_ttsp_tdtp_b_order
       where
         data_dt >= '20230720'
       and
         business_date > '2023-7-22 16:00:00'
       and
         business_date < '2023-7-24 17:50:00'
       and
         debezium_op <> 'd') t where rk = 1 group by user_id) x limit 5;