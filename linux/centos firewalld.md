1.打开firewalld防火墙

systemctl start firewalld.service

(1) memcached 端口设置。允许主机21.20.3.33访问11211端口

firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="21.20.3.33" port protocol="tcp" port="11211" accept"

(2) redis端口设置。允许主机21.20.3.33访问6379端口

firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="21.20.3.33" port protocol="tcp" port="6379" accept"

***

在firewalld服务中配置一条富规则，使其拒绝192.168.10.0/24网段的所有用户访问本机的ssh服务（22端口）

firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.10.0/24" service name="ssh" reject"

firewall-cmd --reload

策略需reload后才生效

查看firewalld配置

firewall-cmd --list-all

***

在开启防火墙之后，我们有些服务就会访问不到，是因为服务的相关端口没有打开。
在此以打开80端口为例

firewall-cmd --add-port=80/tcp --permanent && firewall-cmd --relaod

命令含义：

--zone #作用域

--add-port=80/tcp #添加端口，格式为：端口/通讯协议

--permanent #永久生效，没有此参数重启后失效