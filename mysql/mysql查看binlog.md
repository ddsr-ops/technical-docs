想查看mysql的binlog文件，但是裸的binlog文件是无法直视的，mysqlbinlog这个工具是用来查看binlog文件内容的（使用方式man mysqlbinlog查看），
但是使用mysqlbinlog将binlog文件转换成人类可读的内容时却报错：

`mysqlbinlog: unknown variable 'default-character-set=utf8'`

原因是mysqlbinlog这个工具无法识别binlog中的配置中的default-character-set=utf8这个指令。

两个方法可以解决这个问题

一是在MySQL的配置/etc/my.cnf 中将 default-character-set=utf8  修改为 character-set-server = utf8，但是这需要重启MySQL服务，如果你的MySQL服务正在忙，那这样的代价会比较大。

二是用 mysqlbinlog --no-defaults mysql-bin.00000XX 命令打开。



将binlog文件可视化读出语句：
```
# 根据开始和结束时间查看日志
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-datetime='2022-02-22 17:04:00' --stop-datetime='2022-02-22 17:05:00' mysql-bin.000416

# 根据开始和结束位置查看日志
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-position=676 --stop-position=10765 mysql-bin.000417
```
