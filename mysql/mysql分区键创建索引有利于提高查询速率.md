```mysql> show create table test \G; 
*************************** 1. row ***************************
       Table: test
Create Table: CREATE TABLE `test` (
  `userid` bigint(20) DEFAULT NULL,
  KEY `idx_test_userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY HASH (userid)
PARTITIONS 10 */
1 row in set (0.00 sec)
```

Index over the partitioned column is helpful for improving performance.

# No key idx_test_userid exists

```
mysql> explain select * from test where userid = 123;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | test  | p3         | ALL  | NULL          | NULL | NULL    | NULL |    1 |   100.00 | Using where |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------------+
```

# Key idx_test_userid exists

```
mysql> explain select * from test where userid = 123;
+----+-------------+-------+------------+------+-----------------+-----------------+---------+-------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys   | key             | key_len | ref   | rows | filtered | Extra       |
+----+-------------+-------+------------+------+-----------------+-----------------+---------+-------+------+----------+-------------+
|  1 | SIMPLE      | test  | p3         | ref  | idx_test_userid | idx_test_userid | 9       | const |    1 |   100.00 | Using index |
+----+-------------+-------+------------+------+-----------------+-----------------+---------+-------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)
```