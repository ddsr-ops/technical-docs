安装maven

wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
yum -y install apache-maven

查找maven安装路径
1）查找包路径

rpm -qa|grep apache-maven

2）根据包路径查找安装目录

rpm -ql apache-maven-3.5.2-1.el7.noarch

在搜索结果中就有maven的安装目录。

配置文件路径
/etc/maven/settings.xml