 centos 6 ：使用chkconfig命令即可。

我们以apache服务为例：

chkconfig --add apache 添加nginx服务

chkconfig --del apache 删除nginx服务

chkconfig apache on 开机自启nginx服务

chkconfig apache off 关闭开机自启

chkconfig --list | grep apache 查看

*一般来说，使用off关闭服务即可*

***
centos 7 ：使用systemctl中的enable、disable 即可。
示例：

systemctl enable apache.service 开机自启apache服务

systemctl enable apache.service -now 开机自启apache服务，并启动服务

systemctl disable apache.service 关闭开机自启
