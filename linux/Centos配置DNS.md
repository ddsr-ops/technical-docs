# Centos配置DNS

部分系统（例如7.2）网卡名称比较长。  
为演示方便添加，实际文件未显示。
```text
[root@promote ~]# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core) 
[root@promote ~]# cd /etc/sysconfig/network-scripts/
[root@promote network-scripts]# cat ifcfg-ens33 
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
#启动类型，分为dhcp和static，固定IP地址设置为static
BOOTPROTO="dhcp"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="7c21f428-ed27-407c-accc-2f9bd6b98085"
DEVICE="ens33"
#是否开机启动，不开机启动会导致无法远程连接
ONBOOT="yes"
```

注意修改的内容如下：  
```text
#IP地址
IPADDR="192.168.216.137"
#默认网关
GATEWAY="192.168.216.1"
#DNS服务器，至少一个
DNS1="192.168.216.1"
#DNS服务器，可以配置多个
DNS2="114.114.114.114"
```

**NOTE: 当虚拟机的DNS1无法解析目标主机时，则配置额外的DNS服务器可解决问题，如DNS2**

重启网络服务。需要注意IP地址编号可能会导致远程连接工具退出，一般修改连接IP地址重新连接即可。

```text
[root@promote ~]# systemctl restart network
查看DNS服务器方法如下。

[root@promote ~]# cat /etc/resolv.conf 

Generated by NetworkManager

search localdomain cache-dns.local
nameserver 192.168.216.1
nameserver 114.114.114.114
```
