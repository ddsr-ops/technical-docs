��װmaven

wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
yum -y install apache-maven

����maven��װ·��
1�����Ұ�·��

rpm -qa|grep apache-maven

2�����ݰ�·�����Ұ�װĿ¼

rpm -ql apache-maven-3.5.2-1.el7.noarch

����������о���maven�İ�װĿ¼��

�����ļ�·��
/etc/maven/settings.xml