# Commands

* pstree
* pstack

`pstree` intended to view the thread tree of processes, `pstack` command for viewing stack info of threads of processes.`pstack`

# Steps

```
[root@DEV09-112 ~]# ps -ef|grep mysql
root      21445      1  0 16:21 ?        00:00:00 /bin/sh /usr/local/mysql/bin/mysqld_safe --datadir=/data/mysqldata/3306/data --pid-file=/data/mysqldata/3306/data/DEV09-112.cp.cdtft.cn.pid
mysql     22561  21445 16 16:41 ?        00:00:00 /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/data/mysqdata/3306/data --plugin-dir=/usr/local/mysql/lib/plugin --user=mysql --log-error=/data/mysqldata/3306/log/mysql_error.log --pid-file=/data/mysqldata/3306/data/DEV09-112.cp.cdtft.cn.pid --socket=/data/mysqldata/3306/mysql.sock --port=3306
root      22592  22494  0 16:41 pts/1    00:00:00 grep --color=auto mysql
```

`22651` is the main process of MySQL server

view the thread tree.

```
[root@DEV09-112 ~]# pstree -p 22561
mysqld(22561)─┬─{mysqld}(22562)
              ├─{mysqld}(22563)
              ......
              ├─{mysqld}(22594)
              └─{mysqld}(22596)
```

Here, you can view the stack of all threads via `pstack 22561`, or diagnose someone thread by virtue of `pstack threadno`, such as `pstack  22587`