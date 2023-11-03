Dummy update can not produce log entry event in MySQL, but Oracle can.


What's the dummy update. Imagine there is a table with a column col1 in MySQL, the value of col1 is `x`.
The `update a set col1 = 'x'` statement is regarded as a dummy update, because this statement would have no any modification. However, the `update a set col1 = 'x1'` statement will be run in MySQL internal with the related log produced, `x1` is not equivalent to `x`. To deliver some specific rows to kafka topic, update someone column unrelated to business to another value, then revert it, which makes two dml log events. In the example above, the two dml statements are `update a set col1 = 'x1'`, `update a set col1 = 'x'`.

If the same case occur in Oracle, this update statement will be run in Oracle internal, producing redo log event simultaneously. Therefore, if you want to deliver some specific rows to kafka topic, issue the dummy update statements on the specific rows, then the relevant dml logs events will be captured by Debezium.

```text
mysql> select * from tftactdb.tbl_fcl_ck_acct_balance where acct_no = '0119081500365000001';
+----+---------------------+------------------+-----------+-------------+------------------+----------+----------------+-----------------+-----------+--------------------+--------------+---------------------+---------------------+
| id | acct_no             | acct_name        | acct_cata | acct_status | user_id          | sbjt_cd  | current_direct | current_balance | freeze_at | status_change_date | freeze_level | rec_crt_ts          | rec_upd_ts          |
+----+---------------------+------------------+-----------+-------------+------------------+----------+----------------+-----------------+-----------+--------------------+--------------+---------------------+---------------------+
|  5 | 0119081500365000001 | 9277787031808000 | 01        | 0           | 9277787031808000 | 22410001 | 2              |         1598556 |         0 |                    |              | 2019-10-25 10:29:57 | 2023-11-03 11:23:51 |
+----+---------------------+------------------+-----------+-------------+------------------+----------+----------------+-----------------+-----------+--------------------+--------------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql> update tftactdb.tbl_fcl_ck_acct_balance set current_direct = 2 where acct_no = '0119081500365000001';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0
```