```sql
SELECT *
FROM table1
LEFT JOIN table2 ON table1.id = table2.id

UNION ALL

SELECT *
FROM table1
RIGHT JOIN table2 ON table1.id = table2.id
WHERE table1.id IS NULL;
```

Note: If the union temporary table is joined as a subquery, guarantee the join key is non-null.


Use coalesce() to replace null values in the join key.
```sql
SELECT table1.id, other_columns
FROM table1
         LEFT JOIN table2 ON table1.id = table2.id

UNION ALL

SELECT coalesce(table1.id, table2.id) as id, other_columns
FROM table1
         RIGHT JOIN table2 ON table1.id = table2.id
WHERE table1.id IS NULL;

```