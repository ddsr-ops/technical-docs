```sql
select
to_char(completion_time, 'yyyy-mm-dd hh24:mi') as day_min
,count(*) as "Count"
,round((sum(blocks * block_size)) /1024 /1024,2) as "MB"
from v$archived_log
where completion_time >= trunc(sysdate) - 2
group by to_char(completion_time, 'yyyy-mm-dd hh24:mi')
order by 1;
```