[root@master1 ~]# su - fengjian


-bash: ulimit: open files: cannot modify limit: Operation not permitted
-bash: ulimit: file size: cannot modify limit: Operation not permitted

-bash: ulimit: pending signals: cannot modify limit: Operation not permitted

 

解决办法：

　　　　1. /etc/profile中添加

　　

复制代码
ulimit -n 1024000
ulimit -u unlimited
ulimit -s unlimited
ulimit -i 255983
ulimit -SH unlimited
ulimit -f unlimited
复制代码
 

　　2.  /etc/security/limits.conf 添加

复制代码
 vim /etc/security/limits.conf

* hard nofile 1024000
* soft nofile 1024000
* hard nproc unlimited
* soft nproc unlimited
* soft core 0
* hard core 0
* soft sigpending 255983
* hard sigpending 255983

 
复制代码
 

　　3. /etc/pam.d/sudo 中添加

session    required     pam_limits.so