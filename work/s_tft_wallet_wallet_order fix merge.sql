create table if not exists hadoop_catalog.sdm.s_tft_wallet_wallet_order_new
(
    order_id string comment '',
    account_id string comment '电子账户id',
    order_no string comment '订单号',
    deal_seq_no string comment '银联受理流水号',
    tran_time timestamp comment '订单时间',
    status string comment '订单状态 00:交易失败 01:交易中 02:交易成功 03:撤销成功 04:退款成功 05:冲正成功 31:已撤销 41:已退款 51:已冲正',
    order_amt decimal(16, 2) comment '订单金额',
    coupon_amt decimal(16, 2) comment '优惠金额',
    tran_amount decimal(16, 2) comment '交易金额',
    fee_amount decimal(16, 2) comment '手续费',
    tran_code string comment '交易代码',
    order_type string comment '订单类型，根据此字段进行子表查询 101:充值 102:提现 103:红包转账 104:提现手续费 105:退货 106:撤销 201:付款码消费 202:付款码退货 203:付款码撤销 204:付款码冲正',
    tran_type string comment '交易类型 in:入账 out:出账',
    rsp_code string comment '应答码',
    rsp_desc string comment '应答码描述',
    pay_account_type string comment '付款账户类型 1:电子账户 2:绑定卡',
    pay_account string comment '付款账号',
    pay_account_name string comment '付款账号姓名',
    rec_account_type string comment '收款账户类型 1:电子账户 2:绑定卡',
    rec_account string comment '收款账号',
    rec_account_name string comment '收款账号姓名',
    voucher_num string comment '付款凭证号，由银联统一生成的交易索引，永久唯一，用于后续业务处理',
    create_time timestamp comment '创建时间',
    update_time timestamp comment '更新时间',
    is_delete string comment '删除标识',
    data_dt string comment '分区字段（伪字段，保证向后兼容）'
    )
    using iceberg
-- partitioned by (data_dt)
    comment '小天钱包电子账户订单信息'
    tblproperties
(
    'engine.hive.enabled'='true',
    'write.metadata.delete-after-commit.enabled'='true',
    'write.parquet.row-group-size-bytes'='536870912',
    'history.expire.max-snapshot-age-ms'='1000',
    'write.metadata.previous-versions-max'='5',
    'write.distribution-mode'='hash'
)
;


insert into s_tft_wallet_wallet_order_new select * from s_tft_wallet_wallet_order;
insert into s_tft_wallet_wallet_order select * from s_tft_wallet_wallet_order_new;







with temp as

         (select

              order_id,

              account_id,

              order_no,

              deal_seq_no,

              tran_time,

              status,

              round(order_amt / 100,2) order_amt,

              round(coupon_amt / 100,2) coupon_amt,

              round(tran_amount / 100,2) tran_amount,

              round(fee_amount / 100,2) fee_amount,

              tran_code,

              order_type,

              tran_type,

              rsp_code,

              rsp_desc,

              pay_account_type,

              encrypt(if(length(pay_account) < 24, pay_account, decrypt_new('wallet', pay_account))) as pay_account,

              encrypt(if(length(pay_account_name) < 24, pay_account_name, decrypt_new('wallet', pay_account_name))) as pay_account_name,

              rec_account_type,

              encrypt(if(length(rec_account) < 24, rec_account, decrypt_new('wallet', rec_account))) as rec_account,

              encrypt(if(length(rec_account_name) < 24, rec_account_name, decrypt_new('wallet', rec_account_name))) as rec_account_name,

              voucher_num,

              create_time,

              update_time,

              is_delete,

              date_format(create_time,'yyyyMMdd') data_dt ,

              debezium_op

          from

              (select

                   *,

                   row_number() over(partition by order_id order by debezium_time desc, kafka_offset desc) as rk

               from

                   stg.t_tft_wallet_wallet_order

               where

                       data_dt in ('20231125','20231126')) a

          where

                  rk = 1 order by data_dt)

    merge into

       hadoop_catalog.sdm.s_tft_wallet_wallet_order_new t

     using

       (select * from temp) s

on

    t.order_id = s.order_id

    when matched  then update

                           set

                           t.account_id = s.account_id,

                           t.order_no = s.order_no,

                           t.deal_seq_no = s.deal_seq_no,

                           t.tran_time = s.tran_time,

                           t.status = s.status,

                           t.order_amt = s.order_amt,

                           t.coupon_amt = s.coupon_amt,

                           t.tran_amount = s.tran_amount,

                           t.fee_amount = s.fee_amount,

                           t.tran_code = s.tran_code,

                           t.order_type = s.order_type,

                           t.tran_type = s.tran_type,

                           t.rsp_code = s.rsp_code,

                           t.rsp_desc = s.rsp_desc,

                           t.pay_account_type = s.pay_account_type,

                           t.pay_account = s.pay_account,

                           t.pay_account_name = s.pay_account_name,

                           t.rec_account_type = s.rec_account_type,

                           t.rec_account = s.rec_account,

                           t.rec_account_name = s.rec_account_name,

                           t.voucher_num = s.voucher_num,

                           t.create_time = s.create_time,

                           t.update_time = s.update_time,

                           t.is_delete = s.is_delete,

                           t.data_dt = s.data_dt

                           when not matched  then insert

                       (order_id,

                       account_id,

                       order_no,

                       deal_seq_no,

                       tran_time,

                       status,

                       order_amt,

                       coupon_amt,

                       tran_amount,

                       fee_amount,

                       tran_code,

                       order_type,

                       tran_type,

                       rsp_code,

                       rsp_desc,

                       pay_account_type,

                       pay_account,

                       pay_account_name,

                       rec_account_type,

                       rec_account,

                       rec_account_name,

                       voucher_num,

                       create_time,

                       update_time,

                       is_delete,

                       data_dt)

                       values

                           (s.order_id,

                           s.account_id,

                           s.order_no,

                           s.deal_seq_no,

                           s.tran_time,

                           s.status,

                           s.order_amt,

                           s.coupon_amt,

                           s.tran_amount,

                           s.fee_amount,

                           s.tran_code,

                           s.order_type,

                           s.tran_type,

                           s.rsp_code,

                           s.rsp_desc,

                           s.pay_account_type,

                           s.pay_account,

                           s.pay_account_name,

                           s.rec_account_type,

                           s.rec_account,

                           s.rec_account_name,

                           s.voucher_num,

                           s.create_time,

                           s.update_time,

                           s.is_delete,

                           s.data_dt)



-- Cannot rename Hadoop tables
--alter table hadoop_catalog.sdm.s_tft_wallet_wallet_order rename to hadoop_catalog.sdm.s_tft_wallet_wallet_order_bak20231127;
CREATE TABLE hadoop_catalog.sdm.s_tft_wallet_wallet_order_bak20231127
    USING iceberg
select * from hadoop_catalog.sdm.s_tft_wallet_wallet_order;

--alter table hadoop_catalog.sdm.s_tft_wallet_wallet_order_new rename to hadoop_catalog.sdm.s_tft_wallet_wallet_order;





create table if not exists hadoop_catalog.sdm.s_tft_wallet_wallet_order;
(
    order_id string comment '',
    account_id string comment '电子账户id',
    order_no string comment '订单号',
    deal_seq_no string comment '银联受理流水号',
    tran_time timestamp comment '订单时间',
    status string comment '订单状态 00:交易失败 01:交易中 02:交易成功 03:撤销成功 04:退款成功 05:冲正成功 31:已撤销 41:已退款 51:已冲正',
    order_amt decimal(16, 2) comment '订单金额',
    coupon_amt decimal(16, 2) comment '优惠金额',
    tran_amount decimal(16, 2) comment '交易金额',
    fee_amount decimal(16, 2) comment '手续费',
    tran_code string comment '交易代码',
    order_type string comment '订单类型，根据此字段进行子表查询 101:充值 102:提现 103:红包转账 104:提现手续费 105:退货 106:撤销 201:付款码消费 202:付款码退货 203:付款码撤销 204:付款码冲正',
    tran_type string comment '交易类型 in:入账 out:出账',
    rsp_code string comment '应答码',
    rsp_desc string comment '应答码描述',
    pay_account_type string comment '付款账户类型 1:电子账户 2:绑定卡',
    pay_account string comment '付款账号',
    pay_account_name string comment '付款账号姓名',
    rec_account_type string comment '收款账户类型 1:电子账户 2:绑定卡',
    rec_account string comment '收款账号',
    rec_account_name string comment '收款账号姓名',
    voucher_num string comment '付款凭证号，由银联统一生成的交易索引，永久唯一，用于后续业务处理',
    create_time timestamp comment '创建时间',
    update_time timestamp comment '更新时间',
    is_delete string comment '删除标识',
    data_dt string comment '分区字段（伪字段，保证向后兼容）'
)
using iceberg
-- partitioned by (data_dt)
comment '小天钱包电子账户订单信息'
tblproperties
(
'engine.hive.enabled'='true',
'write.metadata.delete-after-commit.enabled'='true',
'write.parquet.row-group-size-bytes'='536870912',
'history.expire.max-snapshot-age-ms'='1000',
'write.metadata.previous-versions-max'='5',
'write.distribution-mode'='hash'
)
;


insert into hadoop_catalog.sdm.s_tft_wallet_wallet_order select * from hadoop_catalog.sdm.s_tft_wallet_wallet_order_new;
