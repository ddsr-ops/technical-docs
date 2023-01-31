> ***NOTE*** prometheus & grafana 通过大报文进行交互数据，如果被防火墙拦截，记得添加白名单，解除限制  
> ***多组件部署，不建议通过多docker安装，可能会涉及到docker间的通信问题，除非你是docker大拿***  
> 建议参考[参考链接](https://www.jianshu.com/p/35e23e78b60d) 进行部署prometheus/grafana/node_exporter/mysql_exporter
> 至于dashboard在grafana官网查找

# prometheus install
1. 下载  
[下载Prometheus](https://github.com/prometheus/prometheus/releases/)
   

2. 安装配置  
```shell
tar zxf prometheus-2.28.1.linux-amd64.tar.gz
cd prometheus-2.28.1.linux-amd64/
vim prometheus.yml
```

```yaml
# my global config
global:
  scrape_interval:     5s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 5s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']

  # Centos monitor
  - job_name: 'mysqlserver'
    static_configs:
    - targets: ['88.88.16.113:9100']
  # mysql monitor
  - job_name: 'mysql'
    static_configs:
    - targets: ['88.88.16.113:9104']
```

3. 启动prometheus
```shell
./prometheus --config.file=prometheus.yml
```

4. 查看服务  
http://88.88.16.189:9090/
   
# grafana install  
> 直接使用docker进行安装  
* 编辑docker yaml文件
```shell
vim grafana.yaml 

version: "3"
services:
  grafana:
    container_name: grafana
    image: grafana/grafana:7.1.0
    ports:
      - "3000:3000"
    volumes:
      - /etc/localtime:/etc/localtime
    restart: unless-stopped
```

* 启动容器
```shell
docker-compose -f grafana.yaml up -d
```

# 部署exporter  
> Note: 在被采集的服务器上进行部署

## 部署mysql exporter  
* 下载[mysql exporter](https://github.com/prometheus/mysqld_exporter)  
  
* 安装配置  
```shell
tar zxf mysqld_exporter-0.13.0.linux-amd64.tar.gz
cd mysqld_exporter-0.13.0.linux-amd64
vim my.cnf

[client]
host=88.88.16.113
port=3306
user=root
password=root
```

* 启动mysql exporter服务  
```shell
./mysqld_exporter --config.my-cnf=my.cnf
```

* 访问http://127.0.0.1:9104，证明部署成功  

## 部署node_exporter  
node_exporter用于监控服务器

* 下载[node exporter](https://github.com/prometheus/node_exporter/releases)  

* 安装启动，无需配置
```shell
tar -zxf node_exporter-1.2.0.linux-amd64.tar.gz -C prometheus-exporter
cd prometheus-exporter/node_exporter-1.2.0.linux-amd64/
./node_exporter
```

* 访问 http://127.0.0.1:9100 验证是否正确启动  

> 上述exporter启动完毕后，可在prometheus的web界面（status -- targets）进行查看

# 配置grafana
1. 配置数据源  
选择Configuration的Data Sources，点击Add data source，选择Prometheus，在URL一栏填写Prometheus的访问地址，然后保存即可，我这里的prometheus url为http://88.88.10.10:9090/

2. 添加Dashboard  
create -- import -- from grafana.com
   
Note: 登录grafana账号密码为admin/admin