```
一、错误现场还原：
下面我们通过三种方式来连接，然后观察提示的错误信息：
 1、直接使用“mysql”命令，不带主机名参数；
 
 2、使用带了主机名“localhost”参数的“mysql -h localhost”命令；
 
 3、使用带了主机名“127.0.0.1”参数的“mysql -h 127.0.0.1”命令。
 
1、[root@lam7 opt]# mysql
ERROR 2002 (HY000): Can’t connect to local MySQL server through socket ‘/var/lib/mysql/mysql.sock’ (2)

2、[root@lam7 opt]# mysql -h localhost
ERROR 2002 (HY000): Can’t connect to local MySQL server through socket ‘/var/lib/mysql/mysql.sock’ (2)

[root@lam7 opt]# mysql -h 127.0.0.1 （用此方法是可以进入到MariaDB ，可以进入之后忽略此问题）
 Welcome to the MariaDB monitor. Commands end with ; or \g.
 Your MariaDB connection id is 244
 Server version: 10.1.19-MariaDB Source distribution

Copyright ? 2000, 2013, Oracle, Monty Program Ab and others.

Type ‘help;’ or ‘\h’ for help. Type ‘\c’ to clear the current input statement.

3、[root@lam7 opt]# mysql -h 127.0.0.1 （PS：有些用户也会出现此问题）
ERROR 1045 (28000): Access denied for user ‘root’@‘localhost’ (using password: NO)

通过上面实验可以看出，前面两种方式都能产生标题中的错误，而第三种方式连接是不会产生标题中的错误的（第三种方式这里产生的是由于密码问题拒绝访问的错误信息）

二、错误产生原因解析：
这是由于我们连接数据库使用的主机名参数为“localhost”，或者未使用主机名参数、服务器默认使用“localhost”做为主机名。 使用主机名参数为“localhost”连接mysql服务端时，mysql客户端会认为是连接本机，所以会尝试以socket文件方式进行连接(socket文件连接方式，比“ip：端口”方式效率更高)，这时根据配置文件“/etc/mysql.cnf”的路径，未找到相应的socket文件，就会引发此错误。

三、修复故障前准备：
1、看mysql服务是否在运行：
由于“socket”文件是由mysql服务运行时创建的，如果提示“ERROR 2002 (HY000): Can’t connect to local MySQL server through socket ‘***’ (2)”，找不到“socket”文件，我们首先要确认的是mysql服务是否正在运行。

1：端口是否打开
[root@lam7 opt]# lsof -i:3306
 COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
 mysqld 57436 mysql 17u IPv6 160456 0t0 TCP *:mysql (LISTEN)

2：mysqld服务是否正在运行（小七这边用的是centos7，所以会提示使用“/bin/systemctl status mysqld.service”）
[root@lam7 opt]# service mysqld status
 Redirecting to /bin/systemctl status mysqld.service
 mysqld.service
 Loaded: not-found (Reason: No such file or directory)
 Active: inactive (dead)

3：如果mariaDB，同样方法查服务是否正在运行：
[root@lam7 opt]# service mariadb status
 Redirecting to /bin/systemctl status mariadb.service
 mariadb.service - MariaDB database server
 Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled)
 Active: inactive (dead)

4mysqld服务是否正在运行（此现状是mysql服务正常运行）
[root@lam7 opt]# service mariadb status
 Redirecting to /bin/systemctl status mariadb.service
 mariadb.service - MariaDB database server
 Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
 Active: active (running) since 二 2016-11-22 20:09:01 CST; 10min ago

2、确定“socket”文件正确位置：
确定mysql服务正常运行后，产生此错误的原因只剩下“socket”文件路径不正确了，我们可以使用“find”命令或者“lsof”命令来确定socket文件的正确路径：

[root@lam7 opt]# lsof -c mysqld|grep sock$
 lsof: WARNING: can’t stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
 Output information may be incomplete.
 mysqld 57436 mysql 18u unix 0xffff88000b55f440 0t0 160457 /opt/lampp/var/mysql/mysql.sock

[root@lam7 opt]# find / -name ‘*.sock’
 /storage/db/mysql/mysql.sock

四、故障解决方法：
解决方案一：
修改“/etc/my.cnf”配置文件，在/etc/php.ini文件中"[MySQL]“项下找到"mysql.default_socket”，并设置其值指向正确的mysql服务socket文件即可， 在配置文件中添加“[client]”选项和“[mysql]”选项，并使用这两个选项下的“socket”参数值，与“[mysqld]”选项下的“socket”参数值，指向的socket文件路径完全一致。如下：

[mysqld]
 datadir=/storage/db/mysql
 socket=/storage/db/mysql/mysql.sock
 …省略n行
 [client]
 default-character-set=utf8
 socket=/storage/db/mysql/mysql.sock
 [mysql]
 default-character-set=utf8
 socket=/storage/db/mysql/mysql.sock

修改完后，重启mysqld服务，即可解决此问题。

解决方案二：
使用“ln -s /storage/db/mysql/mysql.sock /var/lib/mysql/mysql.sock”命令，将正确的socket文件位置，软链接到提示错误的socket文件路径位置，即可解决此问题：

[root@lam7 opt]# ls /var/lib/mysql/mysql.sock
 ls: 无法访问/var/lib/mysql/mysql.sock: 没有那个文件或目录

[root@lam7 opt]# ln -s /storage/db/mysql/mysql.sock /var/lib/mysql/mysql.sock
 [root@lam7 opt]# ls /var/lib/mysql/mysql.sock
 /var/lib/mysql/mysql.sock

这边讲述了mysql提供的“mysql”、“mysqldump”、“mysqladmin”等命令提示“ERROR 2002 (HY000): Can’t connect to local MySQL server through socket ‘***’ (2)”的解决方法，如果需要解决“php”、“perl”、“python”等脚本语言提示此错误的问题
```