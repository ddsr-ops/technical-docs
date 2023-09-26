--如果通过phone 能发送消息，那么就不再需要qr_user_id

create table if not exists mdm.m_push_mess(
trip_no varchar(16) NULL COMMENT '关联行程单号',
fellow_no varchar(36) NULL COMMENT '关联带人行程单号',
--user_id  varchar(32) NULL COMMENT '八维通用户ID',
-- qr_user_id 用户名,
service_id varchar(16) NULL COMMENT '业务： 地铁 、公交、市域铁路',
create_time datetime NULL COMMENT '创建时间',
phone  varchar(64) comment '电话号码',
first_push_time datetime NULL COMMENT '第一次推送时间',
first_push_status boolean NULL COMMENT '第一次推送状态',
second_push_time datetime NULL  COMMENT '第二次推送时间',
second_push_status boolean NULL COMMENT '第二次推送状态',
third_push_time datetime NULL  COMMENT '第三次推送时间',
third_push_status boolean NULL COMMENT '第三次推送状态',
four_push_time datetime NULL  COMMENT '第四次推送时间',
four_push_status boolean NULL COMMENT '第四次推送状态',
five_push_time datetime NULL  COMMENT '第五次推送时间',
five_push_status boolean NULL COMMENT '第五次推送状态'
)
COMMENT '未支付订单表'
UNIQUE KEY(trip_no, fellow_no)
DISTRIBUTED BY HASH(trip_no) BUCKETS 1;


-- 此表的数据通过什么方式加载
create table if not exists mdm.m_push_mess_detail(
push_time datetime NULL COMMENT '推送时间',
trip_no varchar(16) NULL COMMENT '关联行程单号',
fellow_no varchar(36) NULL COMMENT '关联带人行程单号',
push_type tinyint comment '第几次推送'
push_status boolean NULL COMMENT '推送状态',
push_mess varchar(256) COMMENT '推送内容',
error_mess varchar(256) COMMENT '返回消息'

)
COMMENT '消息发送明细表'
duplicate KEY(push_time,trip_no, fellow_no,push_type)
PARTITION BY RANGE(push_time)(
)
DISTRIBUTED BY HASH(trip_no) BUCKETS 1
PROPERTIES (

    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.buckets" = "1",
); 


create table compare_data.able_time
(
id bigint  PRIMARY KEY AUTO_INCREMENT comment '自增id',
start_time time,
end_time time
)
COMMENT '配置黑名单时间';