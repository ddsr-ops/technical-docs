在row模式下，truncate table在日志中为一条语句；delete为一行行的多条语句。

```
mysql> show variables like 'binlog_format';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| binlog_format | ROW   |
+---------------+-------+
1 row in set (0.00 sec)


mysql> select * from t1;
+----+------+
| id | name |
+----+------+
|  1 | NULL |
|  2 | chen |
|  3 | li   |
+----+------+
3 rows in set (0.00 sec)


mysql> select * from t2;
+------+--------+
| id   | course |
+------+--------+
|    1 | NULL   |
|    2 | chen   |
|    3 | math   |
+------+--------+
3 rows in set (0.00 sec)


mysql> truncate table t1;


mysql> delete from t2;
```

```text
# at 2162
#160303 11:02:51 server id 4  end_log_pos 2248 CRC32 0x3544cc1f     Query    thread_id=2755623    exec_time=0    error_code=0
SET TIMESTAMP=1456974171/*!*/;
truncate table t1
/*!*/;
# at 2248
#160303 11:05:40 server id 4  end_log_pos 2322 CRC32 0xf5126972     Query    thread_id=2756326    exec_time=0    error_code=0
SET TIMESTAMP=1456974340/*!*/;
BEGIN
/*!*/;
# at 2322
#160303 11:05:40 server id 4  end_log_pos 2372 CRC32 0xba9c0edd     Table_map: `testdb`.`t2` mapped to number 12204
# at 2372
#160303 11:05:40 server id 4  end_log_pos 2432 CRC32 0xd1433d85     Delete_rows: table id 12204 flags: STMT_END_F

BINLOG '
BKrXVhMEAAAAMgAAAEQJAAAAAKwvAAAAAAEABnRlc3RkYgACdDIAAgMPAhQAA90OnLo=
BKrXViAEAAAAPAAAAIAJAAAAAKwvAAAAAAEAAgAC//4BAAAA/AIAAAAEY2hlbvwDAAAABG1hdGiF
PUPR
'/*!*/;
### DELETE FROM `testdb`.`t2`
### WHERE
###   @1=1 /* INT meta=0 nullable=1 is_null=0 */
###   @2=NULL /* INT meta=20 nullable=1 is_null=1 */
### DELETE FROM `testdb`.`t2`
### WHERE
###   @1=2 /* INT meta=0 nullable=1 is_null=0 */
###   @2='chen' /* VARSTRING(20) meta=20 nullable=1 is_null=0 */
### DELETE FROM `testdb`.`t2`
### WHERE
###   @1=3 /* INT meta=0 nullable=1 is_null=0 */
###   @2='math' /* VARSTRING(20) meta=20 nullable=1 is_null=0 */
# at 2432
#160303 11:05:40 server id 4  end_log_pos 2463 CRC32 0x225aa989     Xid = 8390829
COMMIT/*!*/;
DELIMITER ;
# End of log file
ROLLBACK /* added by mysqlbinlog */;
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

```