Before startup databases, checking database processes is to be done.
Because some databases are started when servers startup.

88.88.16.101 D
export ORACLE_SID=tft
sqlplus / as sysdba << !
startup;
!
export ORACLE_SID=csqsdb
sqlplus / as sysdba << !
startup;
!
export ORACLE_SID=fxq
sqlplus / as sysdba << !
startup;
!
export ORACLE_SID=lqgj
sqlplus / as sysdba << !
startup;
!
lsnrctl start
ps -ef|egrep -i "ora_|mysql"

88.88.16.168 D
/etc/init.d/mysql start
ps -ef|egrep -i "ora_|mysql"

88.88.16.93 D
systemctl start mysql
ps -ef|egrep -i "ora_|mysql"

88.88.16.58 D
/bin/sh /opt/service/upsql-2.0.3-centos7-x86_64/bin/mysqld_safe --defaults-file=/etc/myconf/upsql.cnf --basedir=/opt/service/upsql-2.0.3-centos7-x86_64 --ledir=/opt/service/upsql-2.0.3-centos7-x86_64/bin
ps -ef|egrep -i "ora_|mysql"

88.88.16.113 D
systemctl start mysql
ps -ef|egrep -i "ora_|mysql"

88.88.16.112 D
sqlplus / as sysdba << !
startup;
!
systemctl start mysql
ps -ef|egrep -i "ora_|mysql"
