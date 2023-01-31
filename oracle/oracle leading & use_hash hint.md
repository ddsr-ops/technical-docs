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

ʾ���У�leading���˳����use_hash���˳��һ�£� ��ñ���һ�¡�

������д���use_hash(use_nlҲһ����hint��ʱ��use_hash�����������ǿ��ԷŶ����˳���޹أ���
����һ��Ҫ���leading ��hint�����ܱ�֤�Ż�����ʹ��������join��ʽ�� leading������˳��ǳ��ؼ�Ŷ������˻����ȥ���ѿ�����cartesian join��