On a system with a large InnoDB buffer pool and innodb_adaptive_hash_index enabled, TRUNCATE TABLE operations may cause a temporary drop in system performance due to an LRU scan that occurs when removing an InnoDB table's adaptive hash index entries. The problem was addressed for DROP TABLE in MySQL 5.5.23 (Bug #13704145, Bug #64284) but remains a known issue for TRUNCATE TABLE (Bug #68184).



In MySQL 5.7 and earlier, on a system with a large buffer pool and innodb_adaptive_hash_index enabled, a TRUNCATE TABLE operation could cause a temporary drop in system performance due to an LRU scan that occurred when removing the table's adaptive hash index entries (Bug #68184). The remapping of TRUNCATE TABLE to DROP TABLE and CREATE TABLE in MySQL 8.0 avoids the problematic LRU scan.




[Referring](https://dev.mysql.com/doc/refman/5.7/en/truncate-table.html)

Replace truncate statement with drop clause, refer to [website](https://zhuanlan.zhihu.com/p/370094861).

You prefer to visit the [reference](https://www.bookstack.cn/read/aliyun-rds-core/1e59798e13d09b05.md).
