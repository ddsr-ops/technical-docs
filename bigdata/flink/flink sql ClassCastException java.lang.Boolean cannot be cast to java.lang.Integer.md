```
[ERROR] Could not execute SQL statement. Reason:
java.lang.ClassCastException: java.lang.Boolean cannot be cast to java.lang.Integer
```

Flink ��ȡMySQL���ݵ�ʱ�򣬽�tinyint(1)��ΪBoolean����Flink SQLDDL�ж������Ȼ��tinyint����Ҳ��jdbc connector Data Type Mapping֧�ֵġ�

����취  
jdbc ��url Option�ϣ�����tinyInt1isBit=false&transformedBitIsBoolean=false������tinyint(1)�Ͳ���תΪBoolean������תΪInteger�ˡ�

����ʾ��

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