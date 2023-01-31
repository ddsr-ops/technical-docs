```sql
select *
from (select * from servicerecord s order by dbms_random.value)
where rownum <= 10;



-- In the inner query, the first time to sort randomly.
-- In the outer clause, sort randomly and only get 10000 records.

select *
from (
         select *
         from (select *
               from (select t.*,
                            row_number() over (partition by zddmz, jyrqz order by dbms_random.value) as rk
                     from tftm1.jltkxfzzzz t
                     where jyrqz >= ''
                       and jyrqz < ''
                       and jysjz >= ''
                       and jysjz < '')
               where rk <= 1)
         order by dbms_random.value)
where rownum <= 10000;
```