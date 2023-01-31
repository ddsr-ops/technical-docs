Cases:
明细流 + 明细流
明细流 + 维度流(DIM table locates in the elasticsearch)

时间语义
业务时间 update time 5 min, if the time zone is not right. 
deprecated === 系统时间 sys time 5 min --> no meaning -->  can not prune data according to business logic. 

time semantic ?　
when running schedules ?
fail to join as some data delayed, then how to fix it.
  If the task depends on the flag file, the task would start when the flag files all exists.
  However, no flag file exists, the join task not launch, and any data will not be produced.
  If replace join with unique key, insert rows into the unique key table, do not care about whether rows join successfully. I worry more abort joining efficiency. 

a kafka table --> doris table      |  
b kafka table --> doris table    |
c kafka table --> doris table     |
......

streaming data may be delayed, but is to come. 

time semantic in every table is different . 
If join tables directly, the result is right. 


select * from a join b join c where a.time and b.time and c.time ...

incremental/view/micro batch

for incremental, this way is deprecated.
for view, the way is flexible, but the efficiency is not well controlled. Developer must pay attention to view sql efficiency. 
for the batch way, may lose data. In case, data may be delayed . In the batch, delayed data failed to join. Another way should be taken to supplement loss data.


Q:
1. The main table delayed(But the flag file can cover it, all table waiting for the delayed table), 
   or some rows delayed in the batch of the main table(When the data arrived as soon, but the other columns from other tables lost.). 
2. Some rows delayed in the batch of other tables, the data is loss permanently.

A:
   View 

table A unique key

| id | ts |
| :-----:| :----: |
| 1 | 15:38 |
| 2 | 15:38 |

table B (CDC) duplicate key(as for unique key model, performance is concerned. )

| id | ts |
| :-----:| :----: |
| 1 | 15:40 |
| 2 | 15:37 |
| 2 | 15:41 |
| 3 | 15:40 |


```mysql
explain
select id, update_time
from (
        (select b.id, b.update_time, row_number() over (partition by b.id order by b.update_time desc) rn
         from test_cdc_inc_prod b
                 join test_cdc_main_prod a
                      on b.id = a.id
         where b.update_time >= '2021-01-11 00:00:00'
           and b.update_time < '2021-01-12 00:00:00'
        )) j
where j.rn = 1
union all
select id, update_time
from (
        (select b.id, b.update_time, row_number() over (partition by b.id order by b.update_time desc) rn
         from test_cdc_inc_prod b
                 left join test_cdc_main_prod a
                           on b.id = a.id
         where a.id is null
           and b.update_time >= '2021-01-11 00:00:00'
           and b.update_time < '2021-01-12 00:00:00'
        )) i
where i.rn = 1;
```

main topic --\
               duplication model --> row_number where ts > a and ts < b
fix topic  --/

-- 13.02 7kw join 5w
-- 11.   50w
-- 16  500w

```mysql
-- test_cdc_inc_prod duplication model √
-- test_cdc_main_prod unique key model 10 days
-- test_cdc_prod unique key model 10 days
# insert into test_cdc_prod
# select *
# from test_cdc_main_prod
# where update_time >= '2021-07-01 00:00:00'
#   and update_time < '2021-07-02 00:00:00';

-- normal 
insert into stg_cdc_table_2
select columns
from (
         select columns, row_number() over (partition by b.id order by b.update_time desc) rn
         from stg_cdc_table_1
         where update_time >= '2021-07-01 12:05:00'
           and update_time <  '2021-07-01 12:10:00') t
where t.rn = 1;


insert into test_cdc_main_prod(id, update_time)
select id, update_time
from (
         (select b.id, b.update_time, row_number() over (partition by b.id order by b.update_time desc) rn
          from test_cdc_inc_prod b
                   join test_cdc_main_prod a
                        on b.id = a.id
          where b.update_time >= '2021-06-26 00:00:00'
             and b.update_time < '2021-06-27 00:00:00'
             and b.update_time > a.update_time
         )) j
where j.rn = 1
union all
select id, update_time
from (
         (select b.id, b.update_time, row_number() over (partition by b.id order by b.update_time desc) rn
          from test_cdc_inc_prod b
                   left join test_cdc_main_prod a
                             on b.id = a.id
          where a.id is null
             and b.update_time >= '2021-06-26 00:00:00'
             and b.update_time <  '2021-06-27 00:00:00'
         )) i
where i.rn = 1;

```


colocate join --  8kw and 200w 6.3s

```sql
insert into stg_cdc_table_2
select columns
from (
         (select b.columns, row_number() over (partition by b.id order by b.update_time desc) rn
          from stg_cdc_table_fix b
                   join stg_cdc_table_2 a
                        on b.id = a.id
          where b.update_time >= '2021-06-26 01:12:00'
            and b.update_time < '2021-06-27 13:15:00'
            and b.update_time > a.update_time
         )) j
where j.rn = 1
union all
select columns
from (
         (select b.columns, row_number() over (partition by b.id order by b.update_time desc) rn
          from stg_cdc_table_fix b
                   left join stg_cdc_table_2 a
                             on b.id = a.id
          where a.id is null
            and b.update_time >= '2021-06-26 01:12:00'
            and b.update_time < '2021-06-27 13:15:00'
         )) i
where i.rn = 1;
```

```sql
insert into stg_cdc_table_2
select columns
from (
         (select b.columns, row_number() over (partition by b.id order by b.update_time desc) rn
          from stg_cdc_table_fix b
                   join stg_cdc_table_2 a
                        on b.id = a.id
          where b.update_time >= '2021-06-26 01:12:00'
            and b.update_time < '2021-06-27 13:15:00'
            and (b.update_time > a.update_time or a.update_time is null)
         )) j
where j.rn = 1
```