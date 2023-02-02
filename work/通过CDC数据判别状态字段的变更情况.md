# 背景

业务数据库中的状态字段，因为设计不合理问题，没有保留状态快照，致使旧状态值被新状态值覆盖。

# 目标

记录状态字段变更情况。

# 前提条件

目标表通过CDC链路接入数据仓库。

# 分析SQL

```sql
select distinct order_status
from (select card_no,
             concat_ws(", ", transform(sort_array(collect_list(struct(update_time, order_status)), True),
                                       x-> x.order_status)) as order_status
      from (select *
            from (select card_no,
                         update_time,
                         order_status,
                         row_number() over(partition by card_no, order_status order by update_time desc) as rk
                  from hadoop_catalog.stg.t_tft_tsm_t_user_app_history_info) i
            where rk = 1) ii
      group by card_no) t
```

注意点：
1. 数据虽然变更了，但状态字段并非一定发生变化，所以`i`,`ii`子查询为去重，
   这里可能存在问题，如果某个card_no的相同order_status值之间存在其他状态值， 如1, 2, 4, 1, 单取任何1都是错误的；
2. 在Spark SQL中，实现了分组排序后进行拼接。