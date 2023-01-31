reference  
https://www.modb.pro/db/46313  
https://blog.csdn.net/xiadingling/article/details/80339834

The LEADING hint instructs the optimizer to use the specified set of tables as the prefix in the execution plan. This hint is more versatile than the ORDERED hint. For example:

```sql
SELECT /*+ LEADING(e j) */ *
    FROM employees e, departments d, job_history j
    WHERE e.department_id = d.department_id
      AND e.hire_date = j.start_date;
```

The LEADING hint is ignored if the tables specified cannot be joined first in the order specified because of dependencies in the join graph.
If you specify two or more conflicting LEADING hints, then all of them are ignored. If you specify the ORDERED hint, it overrides all LEADING hints.


Example 

```sql
select /*+ leading(v t w u) use_hash(u v t w)  */
    count(*)
from tv v,
     tu u,
     tw w,
     tt t
where t.id = v.id
  and t.object_name = upper(v.object_name)
  and w.id = u.id
  and v.created between t.created and t.last_ddl_time
  and v.created between u.created and u.last_ddl_time
  and t.object_id = w.object_id
  and w.created = v.created;
```

示例中，leading后的顺序与use_hash后的顺序不一致， 最好保持一致。

我们在写多表use_hash(use_nl也一样）hint的时候，use_hash的括号里面是可以放多个表（顺序无关），
但是一定要结合leading 的hint，才能保证优化器不使用其他的join方式。 leading里面表的顺序非常关键哦，搞错了会带你去见笛卡尔（cartesian join）