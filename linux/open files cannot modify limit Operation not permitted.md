[root@master1 ~]# su - fengjian


-bash: ulimit: open files: cannot modify limit: Operation not permitted
-bash: ulimit: file size: cannot modify limit: Operation not permitted

-bash: ulimit: pending signals: cannot modify limit: Operation not permitted

 

����취��

��������1. /etc/profile�����

����

���ƴ���
ulimit -n 1024000
ulimit -u unlimited
ulimit -s unlimited
ulimit -i 255983
ulimit -SH unlimited
ulimit -f unlimited
���ƴ���
 

����2.  /etc/security/limits.conf ���

���ƴ���
 vim /etc/security/limits.conf

* hard nofile 1024000
* soft nofile 1024000
* hard nproc unlimited
* soft nproc unlimited
* soft core 0
* hard core 0
* soft sigpending 255983
* hard sigpending 255983

 
���ƴ���
 

����3. /etc/pam.d/sudo �����

session    required     pam_limits.so