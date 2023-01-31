# nethogs

yum install -y nethogs 

按进程实时统计网络带宽利用率(推荐)

命令用法：

1、设置5秒钟刷新一次，通过-d来指定刷新频率：nethogs -d 5

2、监视eth0网络带宽 :nethogs eth0

3、同时监视eth0和eth1接口 : nethogs eth0 eth1

nethogs -d 3 ens192

交互命令：
以下是NetHogs的一些交互命令(键盘快捷键)
* m : 修改单位
* r : 按流量排序
* s : 按发送流量排序
* q : 退出命令提示符

# iftop

yum install -y iftop

命令用法：

-i设定监测的网卡，如：# iftop -i eth1

-B 以bytes为单位显示流量(默认是bits)，如：# iftop -B

-n使host信息，默认直接都显示IP，如：# iftop -n

-N使端口信息，默认直接都显示端口号，如: # iftop -N

iftop -n -N -B -i ens192

交互命令：

按n切换显示本机的IP或主机名;

按s切换是否显示本机的host信息;

按d切换是否显示远端目标主机的host信息;

按t切换显示格式为2行/1行/只显示发送流量/只显示接收流量;

按N切换显示端口号或端口服务名称;

按S切换是否显示本机的端口信息;

按D切换是否显示远端目标主机的端口信息;

按p切换是否显示端口信息