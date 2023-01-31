It`s not recommended to use flink keywords as column name or table name. 
If you must do so, flink keywords should be enclosed with backquote.

```sql
CREATE TABLE t(
    `result` STRING
)
```