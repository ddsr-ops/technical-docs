Error response from daemon: driver failed programming external connectivity on endpoint quirky_allen

### 原因

原因:
docker服务启动时定义的自定义链DOCKER由于 centos7 firewall 被清掉

firewall的底层是使用iptables进行数据过滤，建立在iptables之上，这可能会与 Docker 产生冲突。

当 firewalld 启动或者重启的时候，将会从 iptables 中移除 DOCKER 的规则，从而影响了 Docker 的正常工作。

当你使用的是 Systemd 的时候， firewalld 会在 Docker 之前启动，但是如果你在 Docker 启动之后再启动 或者重启 firewalld ，你就需要重启 Docker 进程了。

重启docker服务及可重新生成自定义链DOCKER

### 解决
重启docker服务后再启动容器

systemctl restart docker

docker start foo