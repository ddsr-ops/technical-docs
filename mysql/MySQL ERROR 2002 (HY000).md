```
һ�������ֳ���ԭ��
��������ͨ�����ַ�ʽ�����ӣ�Ȼ��۲���ʾ�Ĵ�����Ϣ��
 1��ֱ��ʹ�á�mysql���������������������
 
 2��ʹ�ô�����������localhost�������ġ�mysql -h localhost�����
 
 3��ʹ�ô�����������127.0.0.1�������ġ�mysql -h 127.0.0.1�����
 
1��[root@lam7 opt]# mysql
ERROR 2002 (HY000): Can��t connect to local MySQL server through socket ��/var/lib/mysql/mysql.sock�� (2)

2��[root@lam7 opt]# mysql -h localhost
ERROR 2002 (HY000): Can��t connect to local MySQL server through socket ��/var/lib/mysql/mysql.sock�� (2)

[root@lam7 opt]# mysql -h 127.0.0.1 ���ô˷����ǿ��Խ��뵽MariaDB �����Խ���֮����Դ����⣩
 Welcome to the MariaDB monitor. Commands end with ; or \g.
 Your MariaDB connection id is 244
 Server version: 10.1.19-MariaDB Source distribution

Copyright ? 2000, 2013, Oracle, Monty Program Ab and others.

Type ��help;�� or ��\h�� for help. Type ��\c�� to clear the current input statement.

3��[root@lam7 opt]# mysql -h 127.0.0.1 ��PS����Щ�û�Ҳ����ִ����⣩
ERROR 1045 (28000): Access denied for user ��root��@��localhost�� (using password: NO)

ͨ������ʵ����Կ�����ǰ�����ַ�ʽ���ܲ��������еĴ��󣬶������ַ�ʽ�����ǲ�����������еĴ���ģ������ַ�ʽ�����������������������ܾ����ʵĴ�����Ϣ��

�����������ԭ�������
�������������������ݿ�ʹ�õ�����������Ϊ��localhost��������δʹ��������������������Ĭ��ʹ�á�localhost����Ϊ�������� ʹ������������Ϊ��localhost������mysql�����ʱ��mysql�ͻ��˻���Ϊ�����ӱ��������Ի᳢����socket�ļ���ʽ��������(socket�ļ����ӷ�ʽ���ȡ�ip���˿ڡ���ʽЧ�ʸ���)����ʱ���������ļ���/etc/mysql.cnf����·����δ�ҵ���Ӧ��socket�ļ����ͻ������˴���

�����޸�����ǰ׼����
1����mysql�����Ƿ������У�
���ڡ�socket���ļ�����mysql��������ʱ�����ģ������ʾ��ERROR 2002 (HY000): Can��t connect to local MySQL server through socket ��***�� (2)�����Ҳ�����socket���ļ�����������Ҫȷ�ϵ���mysql�����Ƿ��������С�

1���˿��Ƿ��
[root@lam7 opt]# lsof -i:3306
 COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
 mysqld 57436 mysql 17u IPv6 160456 0t0 TCP *:mysql (LISTEN)

2��mysqld�����Ƿ��������У�С������õ���centos7�����Ի���ʾʹ�á�/bin/systemctl status mysqld.service����
[root@lam7 opt]# service mysqld status
 Redirecting to /bin/systemctl status mysqld.service
 mysqld.service
 Loaded: not-found (Reason: No such file or directory)
 Active: inactive (dead)

3�����mariaDB��ͬ������������Ƿ��������У�
[root@lam7 opt]# service mariadb status
 Redirecting to /bin/systemctl status mariadb.service
 mariadb.service - MariaDB database server
 Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled)
 Active: inactive (dead)

4mysqld�����Ƿ��������У�����״��mysql�����������У�
[root@lam7 opt]# service mariadb status
 Redirecting to /bin/systemctl status mariadb.service
 mariadb.service - MariaDB database server
 Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
 Active: active (running) since �� 2016-11-22 20:09:01 CST; 10min ago

2��ȷ����socket���ļ���ȷλ�ã�
ȷ��mysql�����������к󣬲����˴����ԭ��ֻʣ�¡�socket���ļ�·������ȷ�ˣ����ǿ���ʹ�á�find��������ߡ�lsof��������ȷ��socket�ļ�����ȷ·����

[root@lam7 opt]# lsof -c mysqld|grep sock$
 lsof: WARNING: can��t stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
 Output information may be incomplete.
 mysqld 57436 mysql 18u unix 0xffff88000b55f440 0t0 160457 /opt/lampp/var/mysql/mysql.sock

[root@lam7 opt]# find / -name ��*.sock��
 /storage/db/mysql/mysql.sock

�ġ����Ͻ��������
�������һ��
�޸ġ�/etc/my.cnf�������ļ�����/etc/php.ini�ļ���"[MySQL]�������ҵ�"mysql.default_socket������������ֵָ����ȷ��mysql����socket�ļ����ɣ� �������ļ�����ӡ�[client]��ѡ��͡�[mysql]��ѡ���ʹ��������ѡ���µġ�socket������ֵ���롰[mysqld]��ѡ���µġ�socket������ֵ��ָ���socket�ļ�·����ȫһ�¡����£�

[mysqld]
 datadir=/storage/db/mysql
 socket=/storage/db/mysql/mysql.sock
 ��ʡ��n��
 [client]
 default-character-set=utf8
 socket=/storage/db/mysql/mysql.sock
 [mysql]
 default-character-set=utf8
 socket=/storage/db/mysql/mysql.sock

�޸��������mysqld���񣬼��ɽ�������⡣

�����������
ʹ�á�ln -s /storage/db/mysql/mysql.sock /var/lib/mysql/mysql.sock���������ȷ��socket�ļ�λ�ã������ӵ���ʾ�����socket�ļ�·��λ�ã����ɽ�������⣺

[root@lam7 opt]# ls /var/lib/mysql/mysql.sock
 ls: �޷�����/var/lib/mysql/mysql.sock: û���Ǹ��ļ���Ŀ¼

[root@lam7 opt]# ln -s /storage/db/mysql/mysql.sock /var/lib/mysql/mysql.sock
 [root@lam7 opt]# ls /var/lib/mysql/mysql.sock
 /var/lib/mysql/mysql.sock

��߽�����mysql�ṩ�ġ�mysql������mysqldump������mysqladmin����������ʾ��ERROR 2002 (HY000): Can��t connect to local MySQL server through socket ��***�� (2)���Ľ�������������Ҫ�����php������perl������python���Ƚű�������ʾ�˴��������
```