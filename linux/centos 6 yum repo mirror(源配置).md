# 1、背景 
2020年12月2日起，centos官方停止了对centos6的所有更新并且下架了包括官方所有的centos6源，目前阿里、163、清华等centos6源已无法使用。

如果非要用centos6的话就只能使用vault源，国内的vault源的话:

https://mirrors.tuna.tsinghua.edu.cn/centos-vault/、http://mirrors.aliyun.com/centos-vault/


# 2、解决方法：
## 2.1 备份文件
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

## 2.2 更改CentOS-Base.repo文件
vim /etc/yum.repos.d/CentOS-Base.repo 

更改内容如下
```[base]
name=CentOS-$releasever
enabled=1
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos-vault/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos-vault/centos/RPM-GPG-KEY-CentOS-6
 
[updates]
name=CentOS-$releasever
enabled=1
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos-vault/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos-vault/centos/RPM-GPG-KEY-CentOS-6
 
[extras]
name=CentOS-$releasever
enabled=1
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos-vault/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos-vault/centos/RPM-GPG-KEY-CentOS-6
 
[centosplus]
name=CentOS-6.10 - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos-vault/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos-vault/centos/RPM-GPG-KEY-CentOS-6
 
[contrib]
name=CentOS-6.10 - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos-vault/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos-vault/centos/RPM-GPG-KEY-CentOS-6
```

Note: `$releasever` and `$basearch` variables are system internal variables, for details refer to https://blog.csdn.net/taiyang1987912/article/details/46890997


  ## 2.3 更改epel.repo文件

  vim /etc/yum.repos.d/epel.repo 
 更改内容如下
```
[epel]
name=Extra Packages for Enterprise Linux 6 - $basearch
baseurl=http://mirrors.aliyun.com/epel-archive/6/$basearch
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
 
[epel-debuginfo]
name=Extra Packages for Enterprise Linux 6 - $basearch - Debug
baseurl=http://mirrors.aliyun.com/epel-archive/6/$basearch/debug
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=0
 
[epel-source]
name=Extra Packages for Enterprise Linux 6 - $basearch - Source
baseurl=http://mirrors.aliyun.com/epel-archive/6/SRPMS
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=0
```
  ## 2.4 yum更新
yum update sudo