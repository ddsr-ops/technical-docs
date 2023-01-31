```text
[mysqld]
server-id = 1
log_slave_updates = on
auto_increment_increment=2
auto_increment_offset=1
gtid_mode=on
enforce_gtid_consistency = on
master_info_repository=table
relay_log_info_repository=table
lower_case_table_names=1
relay_log=/var/log/mysql/mysql-relay-bin.log
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
log_bin=/var/lib/mysql/binlog/mysql-bin.log
log_bin_index=/var/lib/mysql/binlog/mysql-bin.index
expire_logs_days=5
binlog_format = row
binlog_row_image = minimal
max_allowed_packet=1024M
max_connections=5000
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
net_read_timeout=86400
net_write_timeout=86400
binlog_row_image=FULL

[mysqld_safe]
log-error=/var/log/mysql/mysql.log
pid-file=/var/run/mysql/mysql.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

[mysql]
socket=/var/lib/mysql/mysql.sock

[client]
default-character-set=utf8
socket=/var/lib/mysql/mysql.sock
```

docker run -p 3306:3306 --privileged=true -v /root/docker/my.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf -v /etc/localtime:/etc/localtime -e MYSQL_ROOT_PASSWORD=love8013 -d mysql:5.7