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