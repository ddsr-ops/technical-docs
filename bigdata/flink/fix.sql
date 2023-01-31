MERGE INTO dc_trip_order_new D
USING (SELECT /*+ leading(old new) use_hash(old new)  */
       old.order_no,
       old.user_id,
       old.service_id,
       old.operator_id,
       old.trip_no,
       old.batch_no,
       old.card_no,
       old.base_amount,
       old.discount_amount,
       old.fine_amount,
       old.card_reduced_amount,
       old.card_amount,
       old.coupon_reduced_amount,
       old.coupon_amount,
       old.order_amount,
       old.pay_state,
       old.create_time,
       old.update_time,
       old.coupon_id,
       old.coupon_temp_id,
       old.pay_time,
       old.card_use_status,
       old.coupon_use_status,
       old.card_refund_flag,
       old.coupon_refund_flag,
       old.channel_code,
       old.pay_type
  FROM (select *
          from dc_trip_order
         where update_time >= to_date('20220329', 'yyyymmdd')
           and update_time < to_date('20220402', 'yyyymmdd')) old,
       (select *
          from dc_trip_order_new
         where update_time >= to_date('20220329', 'yyyymmdd')
           and update_time < to_date('20220402', 'yyyymmdd')) new
 where old.order_no = new.order_no(+)
   and (new.order_no is null or
       (old.user_id != new.user_id or old.service_id != new.service_id or
       old.operator_id != new.operator_id or old.trip_no != new.trip_no or
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
       nvl(old.pay_type, '0') != nvl(new.pay_type, '0')))) S
ON (D.order_no = S.order_no)
WHEN MATCHED THEN
  UPDATE
     SET D.user_id               = S.user_id,
         D.service_id            = S.service_id,
         D.operator_id           = S.operator_id,
         D.trip_no               = S.trip_no,
         D.batch_no              = S.batch_no,
         D.card_no               = S.card_no,
         D.base_amount           = S.base_amount,
         D.discount_amount       = S.discount_amount,
         D.fine_amount           = S.fine_amount,
         D.card_reduced_amount   = S.card_reduced_amount,
         D.card_amount           = S.card_amount,
         D.coupon_reduced_amount = S.coupon_reduced_amount,
         D.coupon_amount         = S.coupon_amount,
         D.order_amount          = S.order_amount,
         D.pay_state             = S.pay_state,
         D.create_time           = S.create_time,
         D.update_time           = S.update_time,
         D.coupon_id             = S.coupon_id,
         D.coupon_temp_id        = S.coupon_temp_id,
         D.pay_time              = S.pay_time,
         D.card_use_status       = S.card_use_status,
         D.coupon_use_status     = S.coupon_use_status,
         D.card_refund_flag      = S.card_refund_flag,
         D.coupon_refund_flag    = S.coupon_refund_flag,
         D.channel_code          = S.channel_code,
         D.pay_type              = S.pay_type
WHEN NOT MATCHED THEN
  INSERT
    (D.order_no,
     D.user_id,
     D.service_id,
     D.operator_id,
     D.trip_no,
     D.batch_no,
     D.card_no,
     D.base_amount,
     D.discount_amount,
     D.fine_amount,
     D.card_reduced_amount,
     D.card_amount,
     D.coupon_reduced_amount,
     D.coupon_amount,
     D.order_amount,
     D.pay_state,
     D.create_time,
     D.update_time,
     D.coupon_id,
     D.coupon_temp_id,
     D.pay_time,
     D.card_use_status,
     D.coupon_use_status,
     D.card_refund_flag,
     D.coupon_refund_flag,
     D.channel_code,
     D.pay_type)
  VALUES
    (S.order_no,
     S.user_id,
     S.service_id,
     S.operator_id,
     S.trip_no,
     S.batch_no,
     S.card_no,
     S.base_amount,
     S.discount_amount,
     S.fine_amount,
     S.card_reduced_amount,
     S.card_amount,
     S.coupon_reduced_amount,
     S.coupon_amount,
     S.order_amount,
     S.pay_state,
     S.create_time,
     S.update_time,
     S.coupon_id,
     S.coupon_temp_id,
     S.pay_time,
     S.card_use_status,
     S.coupon_use_status,
     S.card_refund_flag,
     S.coupon_refund_flag,
     S.channel_code,
     S.pay_type);
     
/*==================================================================================================================================================================================================*/
     
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
--select max(update_time) from dc_trip_order_new; 
