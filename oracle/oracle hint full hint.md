**Question**:  I want to understand how the parallel hint works inside a SQL statement and I also want to know the optimal degree for the parallel hint.  Are there rules for determining the optimal parallel hint degree?

**Answer**:  The parallel hint is one of the "good" hints, such as the cardinality and ordered hints.  There are several guidelines for using the parallel hint:

* The target table or index must be doing a full-scan operation,

* A starting point for the parallel degree us cpu_count-1 (the truly fastest degree is determined empirically via timing the query.  See optimizing the degree for a parallel hint

* If the table is aliased, the parallel hint must also be aliased.

The parallel hint accepts a table name an optional "degree" argument to tell Oracle how many factotum (slave) processes to use in the parallel hinted query:

*Note*:  For all OLTP databases, it is recommended to use parallel as a hint only and DO NOT turn-on parallelism at the table or system level:

```sql
alter table customer parallel degree 35; -- not recommended for OLTP
```

Setting parallel at the table level avoids the need to use hints, but it has the downside of causing the optimizer to start favoring full scan operations.

# Examples of parallel hints
The recommended approach for using Parallel query is to add a parallel hint to all SQL statements that perform a full-table scan and would benefit from parallel query.

```sql
select /*+ FULL(emp) PARALLEL(emp, 35) */
```

Here is an example of a "bad" parallel hint because the parallel hint is with an index hint.  
The following hint is invalid because first_rows access and parallel access are mutually exclusive. 
That is because parallel access always assumes a full-table scan and first_rows favors index access.

```sql
-- An invalid parallel hint
select /*+ first_rows_10 index (emp emp_idx) parallel(emp,8)*/
   emp_name
from
   emp
where
   emp_type = 'SALARIED';
```

This parallel hint is invalid because the table is aliased and the parallel hint does not use the alias:

```sql
-- An invalid parallel hint
select /*+ parallel(emp,8)*/
   emp_name
from
   emp e
where
   emp_type = 'SALARIED';
```

You can also have multiple parallel hints within a query.  The following example shows two parallel hints within a query, one for each table::

```sql
select /*+ PARALLEL(employees 4) PARALLEL(departments 4)
USE_HASH(employees) ORDERED */
   max(salary),
   avg(salary)
from
   employees,
   departments
where
   employees.department_id = departments.department_id
group by
   employees.department_id;
```

# Tuning with the parallel hint
When using parallel query, one should seldom turn on parallelism at the table level, alter table customer parallel 35, 
because the setting of parallelism for a table influences the optimizer.
 
This causes the optimizer to see that the full-table scan is inexpensive. Hence, most Oracle professionals specify parallel query on a query-by-query basis, 
combining the full hint with the parallel hint to ensure a fast parallel full-table scan:

```sql
-- A valid hint
select /*+ full parallel(emp,35)*/
emp_name
from
emp
order by
ename;
```

The number of processors dedicated to service a SQL request is ultimately determined by Oracle Query Manager, 
but the programmer can specify the upper limit on the number of simultaneous processes. When using the cost-based optimizer,
the parallel hint can be embedded into the SQL to specify the number of processes. For instance:

```sql
select /*+ FULL(employee_table) PARALLEL(employee_table, 35) */
employee_name
from
employee_table
where
emp_type = 'SALARIED';
```

If you are using an SMP or MPP database server with many CPUs, you can issue a parallel request and leave it up to each Oracle instance to use its default degree of parallelism.
For example:

```sql
select /*+ FULL(employee_table) PARALLEL(employee_table, DEFAULT, DEFAULT) */
employee_name
from
employee_table
where
emp_type = 'SALARIED';
```

这里说的OLAP数据库，并不是OLTP数据库
In most cases, it is better for the Oracle Remote DBA to determine the optimal degree of parallelism and then set that degree in the data dictionary with the following command:

```sql
Alter table employee_table parallel degree 35;
```

This way, the Remote DBA can always be sure of the degree of parallelism for any particular table.