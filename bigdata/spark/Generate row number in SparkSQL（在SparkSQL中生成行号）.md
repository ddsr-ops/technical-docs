```sql
spark-sql> SELECT a, b, row_number() OVER (ORDER BY a) FROM VALUES ('A1', 2), ('A1', 1), ('A2', 3), ('A1', 1) tab(a, b);
A1	2	1
A1	1	2
A1	1	3
A2	3	4
```