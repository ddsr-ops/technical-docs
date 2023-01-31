首先要做的就是使用 flush logs 命令，flush logs 可以 MySQL rotate(翻转) 到下一个 binlog 进行写入。 
这样，我们就可以达到将 flush logs 之前的 binlog 都备份起来的目的。

例如：
```mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000015 |       241 |
| mysql-bin.000016 |       241 |
| mysql-bin.000017 |       217 |
| mysql-bin.000018 |       824 |
| mysql-bin.000019 |      1081 |
| mysql-bin.000020 |       241 |
| mysql-bin.000021 |       217 |
| mysql-bin.000022 |       241 |
| mysql-bin.000023 |       194 |
+------------------+-----------+
9 rows in set (0.00 sec)

mysql> flush logs;
Query OK, 0 rows affected (0.01 sec)

mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000015 |       241 |
| mysql-bin.000016 |       241 |
| mysql-bin.000017 |       217 |
| mysql-bin.000018 |       824 |
| mysql-bin.000019 |      1081 |
| mysql-bin.000020 |       241 |
| mysql-bin.000021 |       217 |
| mysql-bin.000022 |       241 |
| mysql-bin.000023 |       241 |
| mysql-bin.000024 |      1104 |
+------------------+-----------+
```
原本 MySQL 正在将 binlog 写入 mysql-bin.000023，flush logs 会让 MySQL 关闭 mysql-bin.000023，
然后打开 mysql-bin.000024 作为当前二进制日志写入。 这样我们就可以安全的备份 mysql-bin.000015 到 mysql-bin.000023 这几个日志文件了。

日志备份阶段，可以使用 rsync、scp 等工具将其备份，当然也可以先使用 tar 将其打包后再备走。

备份完成后，在确认备份集有效的情况下，可以将日志清掉

```mysql> purge master logs to 'mysql-bin.000024';```