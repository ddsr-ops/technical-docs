When updating in JOIN SQL, how it works.
Especially after joining, the number of rows become more. 

```text
mysql> create table t1 (id int, c1 varchar(20));
Query OK, 0 rows affected (0.01 sec)

mysql> create table t2 (id int, c1 varchar(20));
Query OK, 0 rows affected (0.01 sec)

mysql> insert into t1 values(1, 'a'), (2, 'b'), (2, 'b1');
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> insert into t2 values(1, 'a1'), (2, 'b_2'), (2, 'b_21'), (3, 'c_2');
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> update t1, t2 set t1.c1 = t2.c1 where t1.id = t2.id; 
Query OK, 3 rows affected (0.00 sec)
Rows matched: 3  Changed: 3  Warnings: 0

mysql> select * from t1; 
+------+------+
| id   | c1   |
+------+------+
|    1 | a1   |
|    2 | b_2  |
|    2 | b_2  |
+------+------+

```

Here, find t1.c1 war of id = 2 were updated into 'b_2'. 

[Reference](https://segmentfault.com/a/1190000021712790)