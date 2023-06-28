```
[ERROR] Could not execute SQL statement. Reason:
java.lang.ClassCastException: java.lang.Boolean cannot be cast to java.lang.Integer
```

Flink 读取MySQL数据的时候，将tinyint(1)作为Boolean，而Flink SQLDDL中定义的依然是tinyint，这也是jdbc connector Data Type Mapping支持的。

解决办法  
jdbc 的url Option上，加上tinyInt1isBit=false&transformedBitIsBoolean=false，这样tinyint(1)就不会转为Boolean，而是转为Integer了。

完整示例

```sql
CREATE TEMPORARY TABLE task_record (
    `id` BIGINT,
    `task_id` BIGINT,
    `task_type` TINYINT,
    `status` TINYINT,
    `start_at` TIMESTAMP,
    `finished_at` TIMESTAMP,
    PRIMARY KEY (`id`) NOT ENFORCED
  )
WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:mysql://localhost:3306/rd_crm?tinyInt1isBit=false&transformedBitIsBoolean=false',
    'username' = 'root',
    'password' = '${secret_values.k8s_mysql_password}',
    'table-name' = 'task_record'
  );
```