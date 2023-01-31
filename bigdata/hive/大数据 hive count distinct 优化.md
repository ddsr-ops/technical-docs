[参考链接](https://blog.csdn.net/wsdc0521/article/details/117885554)

在数仓开发中经常会对数据去重后统计，而对于大数据量来说，count(distinct )操作明显非常的消耗资源且性能很慢。

下面介绍我平时使用最多的一种优化方式，供大家参考。

* 原SQL
```sql
select 
  group_id,
  app_id,
  count(distinct case when dt>='${7d_before}' then user_id else null end) as 7d_uv, -- 7日内UV
  count(distinct case when dt>='${14d_before}' then user_id else null end) as 14d_uv --14日内UV
from tbl
where dt>='${14d_before}'
group by 
  group_id,
  app_id
;
```

* 优化后
```sql
--先去重，再汇总。

select  group_id
        ,app_id
        ,sum(case when 7d_cnt>0 then 1 else 0 end) AS 7d_uv, -- 7日内UV
        ,sum(case when 14d_cnt>0 then 1 else 0 end) AS 14d_uv --14日内UV
from    (
        select   
            group_id,
            app_id,
            user_id, --按user_id去重
            count(case when dt>='${7d_before}' then user_id else null end) as 7d_cnt, -- 7日内各用户的点击量, count不会计算为null的个数
            count(case when dt>='${14d_before}' then user_id else null end) as 14d_cnt --14日内各用户的点击量
        from tbl
        where dt>='${14d_before}'
        group by 
            group_id,
            app_id,
            user_id
        ) a
group by group_id,
         app_id
;
```