-- Check 
with new as
 (select *
    from DC_TRIP_ORDER_NEW t
   WHERE t.update_time >= to_date('&1', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('&2', 'yyyy-mm-dd hh24:mi:ss')),
old as
 (select *
    from DC_TRIP_ORDER t
   WHERE t.update_time >= to_date('&1', 'yyyy-mm-dd hh24:mi:ss')
     AND t.update_time < to_date('&2', 'yyyy-mm-dd hh24:mi:ss'))
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and old.user_id = new.user_id
           and old.service_id = new.service_id
           and old.operator_id = new.operator_id
           and old.trip_no = new.trip_no
           and nvl(old.batch_no, '0') = nvl(new.batch_no, '0')
           and nvl(old.card_no, '0') = nvl(new.card_no, '0')
           and old.base_amount = new.base_amount
           and old.discount_amount = new.discount_amount
           and old.fine_amount = new.fine_amount
           and old.card_reduced_amount = new.card_reduced_amount
           and old.card_amount = new.card_amount
           and old.coupon_reduced_amount = new.coupon_reduced_amount
           and old.coupon_amount = new.coupon_amount
           and old.order_amount = new.order_amount
           and old.pay_state = new.pay_state
           and old.create_time = new.create_time
           and old.update_time = new.update_time
           and nvl(old.coupon_id, '0') = nvl(new.coupon_id, '0')
           and nvl(old.coupon_temp_id, '0') = nvl(new.coupon_temp_id, '0')
           and nvl(old.pay_time, sysdate) = nvl(new.pay_time, sysdate)
           and old.card_use_status = new.card_use_status
           and old.coupon_use_status = new.coupon_use_status
           and old.card_refund_flag = new.card_refund_flag
           and old.coupon_refund_flag = new.coupon_refund_flag
           and nvl(old.channel_code, '0') = nvl(new.channel_code, '0')
           and nvl(old.pay_type, '0') = nvl(new.pay_type, '0')) identity_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and (old.user_id != new.user_id or
               old.service_id != new.service_id or
               old.operator_id != new.operator_id or
               old.trip_no != new.trip_no or
               nvl(old.batch_no, '0') != nvl(new.batch_no, '0') or
               nvl(old.card_no, '0') != nvl(new.card_no, '0') or
               old.base_amount != new.base_amount or
               old.discount_amount != new.discount_amount or
               old.fine_amount != new.fine_amount or
               old.card_reduced_amount != new.card_reduced_amount or
               old.card_amount != new.card_amount or
               old.coupon_reduced_amount != new.coupon_reduced_amount or
               old.coupon_amount != new.coupon_amount or
               old.order_amount != new.order_amount or
               old.pay_state != new.pay_state or
               old.create_time != new.create_time or
               old.update_time != new.update_time or
               nvl(old.coupon_id, '0') != nvl(new.coupon_id, '0') or
               nvl(old.coupon_temp_id, '0') != nvl(new.coupon_temp_id, '0') or
               nvl(old.pay_time, sysdate) != nvl(new.pay_time, sysdate) or
               old.card_use_status != new.card_use_status or
               old.coupon_use_status != new.coupon_use_status or
               old.card_refund_flag != new.card_refund_flag or
               old.coupon_refund_flag != new.coupon_refund_flag or
               nvl(old.channel_code, '0') != nvl(new.channel_code, '0') or
               nvl(old.pay_type, '0') != nvl(new.pay_type, '0'))) difference_count
  from dual;

/*============================================================================================================================================================================*/

with t as
 (select order_no
    from dc_trip_order
   where create_time < to_date('2022-03-27', 'yyyy-mm-dd')
     and update_time >
         to_date('2022-03-30 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
     and update_time <
         to_date('2022-03-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
new as
 (select *
    from DC_TRIP_ORDER_NEW t
   WHERE order_no in (select order_no from t)),
old as
 (select *
    from DC_TRIP_ORDER t
   WHERE order_no in (select order_no from t))         
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and old.user_id = new.user_id
           and old.service_id = new.service_id
           and old.operator_id = new.operator_id
           and old.trip_no = new.trip_no
           and nvl(old.batch_no, '0') = nvl(new.batch_no, '0')
           and nvl(old.card_no, '0') = nvl(new.card_no, '0')
           and old.base_amount = new.base_amount
           and old.discount_amount = new.discount_amount
           and old.fine_amount = new.fine_amount
           and old.card_reduced_amount = new.card_reduced_amount
           and old.card_amount = new.card_amount
           and old.coupon_reduced_amount = new.coupon_reduced_amount
           and old.coupon_amount = new.coupon_amount
           and old.order_amount = new.order_amount
           and old.pay_state = new.pay_state
           and old.create_time = new.create_time
           and old.update_time = new.update_time
           and nvl(old.coupon_id, '0') = nvl(new.coupon_id, '0')
           and nvl(old.coupon_temp_id, '0') = nvl(new.coupon_temp_id, '0')
           and nvl(old.pay_time, sysdate) = nvl(new.pay_time, sysdate)
           and old.card_use_status = new.card_use_status
           and old.coupon_use_status = new.coupon_use_status
           and old.card_refund_flag = new.card_refund_flag
           and old.coupon_refund_flag = new.coupon_refund_flag
           and nvl(old.channel_code, '0') = nvl(new.channel_code, '0')
           and nvl(old.pay_type, '0') = nvl(new.pay_type, '0')) identity_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and (old.user_id != new.user_id or
               old.service_id != new.service_id or
               old.operator_id != new.operator_id or
               old.trip_no != new.trip_no or
               nvl(old.batch_no, '0') != nvl(new.batch_no, '0') or
               nvl(old.card_no, '0') != nvl(new.card_no, '0') or
               old.base_amount != new.base_amount or
               old.discount_amount != new.discount_amount or
               old.fine_amount != new.fine_amount or
               old.card_reduced_amount != new.card_reduced_amount or
               old.card_amount != new.card_amount or
               old.coupon_reduced_amount != new.coupon_reduced_amount or
               old.coupon_amount != new.coupon_amount or
               old.order_amount != new.order_amount or
               old.pay_state != new.pay_state or
               old.create_time != new.create_time or
               old.update_time != new.update_time or
               nvl(old.coupon_id, '0') != nvl(new.coupon_id, '0') or
               nvl(old.coupon_temp_id, '0') != nvl(new.coupon_temp_id, '0') or
               nvl(old.pay_time, sysdate) != nvl(new.pay_time, sysdate) or
               old.card_use_status != new.card_use_status or
               old.coupon_use_status != new.coupon_use_status or
               old.card_refund_flag != new.card_refund_flag or
               old.coupon_refund_flag != new.coupon_refund_flag or
               nvl(old.channel_code, '0') != nvl(new.channel_code, '0') or
               nvl(old.pay_type, '0') != nvl(new.pay_type, '0'))) difference_count
  from dual;
  
/*============================================================================================================================================================================*/

select *
  from dc_trip_order_new o 
 where update_time >= to_date('2022-03-29', 'yyyy-mm-dd')
   and update_time < to_date('2022-03-29', 'yyyy-mm-dd') + 1
   and exists
 (select 8
          from (select order_no
                  from dc_trip_order_new
                 where update_time >= to_date('2022-03-29', 'yyyy-mm-dd')
                   and update_time < to_date('2022-03-29', 'yyyy-mm-dd') + 1
                minus
                select order_no
                  from dc_trip_order
                 where update_time >= to_date('2022-03-29', 'yyyy-mm-dd')
                   and update_time < to_date('2022-03-29', 'yyyy-mm-dd') + 1) i
         where i.order_no = o.order_no)


with old as
 (select /*+ parallel(8)*/
   trunc(update_time) as dt, count(*) as cnt
    from dc_trip_order
   where update_time < to_date('2022-03-29', 'yyyy-mm-dd')
   group by trunc(update_time)),
new as
 (select /*+ parallel(8)*/
   trunc(update_time) as dt, count(*) as cnt
    from dc_trip_order_new
   where update_time < to_date('2022-03-29', 'yyyy-mm-dd')
   group by trunc(update_time))
select old.dt,
       old.cnt,
       new.dt,
       new.cnt,
       case when nvl(old.cnt, 0)=nvl(new.cnt, 0) then  '=' else  '!=' end as eq
  from old
  full join new
    on old.dt = new.dt
 order by 1


/*============================================================================================================================================================================*/

with oid as
 (select order_no
    from dc_trip_order_new
   where create_time >= to_date('20220331', 'yyyymmdd')
     and create_time < to_date('20220331', 'yyyymmdd') + 1),
new as
 (select /*+ parallel(4)*/*
    from DC_TRIP_ORDER_NEW t
   WHERE t.order_no in (select order_no from oid)),
old as
 (select /*+ parallel(4)*/*
    from DC_TRIP_ORDER t
   WHERE t.order_no in (select order_no from oid))
select (select count(*) from new) new_total_count,
       (select count(*) from old) old_total_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and old.user_id = new.user_id
           and old.service_id = new.service_id
           and old.operator_id = new.operator_id
           and old.trip_no = new.trip_no
           and nvl(old.batch_no, '0') = nvl(new.batch_no, '0')
           and nvl(old.card_no, '0') = nvl(new.card_no, '0')
           and old.base_amount = new.base_amount
           and old.discount_amount = new.discount_amount
           and old.fine_amount = new.fine_amount
           and old.card_reduced_amount = new.card_reduced_amount
           and old.card_amount = new.card_amount
           and old.coupon_reduced_amount = new.coupon_reduced_amount
           and old.coupon_amount = new.coupon_amount
           and old.order_amount = new.order_amount
           and old.pay_state = new.pay_state
           and old.create_time = new.create_time
           and old.update_time = new.update_time
           and nvl(old.coupon_id, '0') = nvl(new.coupon_id, '0')
           and nvl(old.coupon_temp_id, '0') = nvl(new.coupon_temp_id, '0')
           and nvl(old.pay_time, sysdate) = nvl(new.pay_time, sysdate)
           and old.card_use_status = new.card_use_status
           and old.coupon_use_status = new.coupon_use_status
           and old.card_refund_flag = new.card_refund_flag
           and old.coupon_refund_flag = new.coupon_refund_flag
           and nvl(old.channel_code, '0') = nvl(new.channel_code, '0')
           and nvl(old.pay_type, '0') = nvl(new.pay_type, '0')) identity_count,
       (select count(*)
          from new, old
         where old.order_no = new.order_no
           and (old.user_id != new.user_id or
               old.service_id != new.service_id or
               old.operator_id != new.operator_id or
               old.trip_no != new.trip_no or
               nvl(old.batch_no, '0') != nvl(new.batch_no, '0') or
               nvl(old.card_no, '0') != nvl(new.card_no, '0') or
               old.base_amount != new.base_amount or
               old.discount_amount != new.discount_amount or
               old.fine_amount != new.fine_amount or
               old.card_reduced_amount != new.card_reduced_amount or
               old.card_amount != new.card_amount or
               old.coupon_reduced_amount != new.coupon_reduced_amount or
               old.coupon_amount != new.coupon_amount or
               old.order_amount != new.order_amount or
               old.pay_state != new.pay_state or
               old.create_time != new.create_time or
               old.update_time != new.update_time or
               nvl(old.coupon_id, '0') != nvl(new.coupon_id, '0') or
               nvl(old.coupon_temp_id, '0') != nvl(new.coupon_temp_id, '0') or
               nvl(old.pay_time, sysdate) != nvl(new.pay_time, sysdate) or
               old.card_use_status != new.card_use_status or
               old.coupon_use_status != new.coupon_use_status or
               old.card_refund_flag != new.card_refund_flag or
               old.coupon_refund_flag != new.coupon_refund_flag or
               nvl(old.channel_code, '0') != nvl(new.channel_code, '0') or
               nvl(old.pay_type, '0') != nvl(new.pay_type, '0'))) difference_count
  from dual;
  
--analyze table dc_trip_order_new compute statistics;
--select max(update_time) from dc_trip_order_new;
--select (n1 - n2)*24*3600, n1, n2 from (select (select max(update_time) from dc_trip_order ) as n1, (select max(update_time) from dc_trip_order_new) as n2 from dual) t
select (n1 - n2) * 24 * 3600 as second_diff,
       n1,
       n2,
       cnt1 - cnt2 as cnt_diff,
       cnt1,
       cnt2
  from (select (select max(update_time) from dc_trip_order) as n1,
               (select max(update_time) from dc_trip_order_new) as n2,
               (select count(*)
                  from dc_trip_order
                 where update_time >= sysdate - 10 / (24 * 60)) as cnt1,
               (select count(*)
                  from dc_trip_order_new
                 where update_time >= sysdate - 10 / (24 * 60)) as cnt2
          from dual) t

/*============================================================================================================================================================================*/

with old as
 (select /*+ full parallel(t,4)*/
   order_no, order_amount, pay_state
    from dc_trip_order t
   where update_time < to_date('20220406', 'yyyymmdd')),
new as
 (select /*+ full parallel(t,4)*/
   order_no, order_amount, pay_state
    from dc_trip_order_new t
   where update_time < to_date('20220406', 'yyyymmdd'))
select 
 --(select count(*) from new) new_total_count,
 --(select count(*) from old) old_total_count,
 (select /*+parallel(4) */count(*)
    from new, old
   where old.order_no = new.order_no
     and old.order_amount = new.order_amount
     and old.pay_state = new.pay_state) identity_count,
 (select /*+parallel(4) */count(*)
    from new, old
   where old.order_no = new.order_no
     and (old.order_amount != new.order_amount or
         old.pay_state != new.pay_state)) difference_count
  from dual;
