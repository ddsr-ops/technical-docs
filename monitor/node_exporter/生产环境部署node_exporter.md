# 背景

当前Hadoop大数据环境各主机资源托管于CM中心，但是CM提供的监控指标及其粒度不够，故选用主流的主机资源监控技术手段，进行资源健康状态记录。

# 目标

借助主流的监控手段，形成指标采集、指标计算、指标可视化等监控实现通路的闭环。

# 部署规划

| 组件 | 用途 | 部署IP |
| :----| :---- | :---- |
| node_exporter_1.3.1 | 主机指标信息收集 | 10.50.253.1-7 |
| prometheus-2.32.1 | 存储指标信息 | 10.50.253.7 |
| grafana-8.3.3 | 指标可视化 | 10.50.253.7  |

# 实施步骤

## 1. node_exporter

node_exporter组件为收集主机各项指标信息， 应部署于受监控的主机。

下载组件包， [node_exporter github](https://github.com/prometheus/node_exporter/releases), 选择`node_exporter-1.3.1.linux-amd64.tar.gz
`

```shell
tar -zxf node_exporter-1.3.1.linux-amd64.tar.gz -C /opt/module
echo "nohup ./node_exporter --collector.systemd --collector.processes > nohup.out 2>&1 &" > start.sh
chmod u+x start.sh
./start.sh
```

通过`nohup.out`日志或端口号检查，可确认其运行正常， `netstat -an|grep 9100`.

## 2. prometheus

prometheus组件为存储数据，部署组件步骤略。

1. 停止已运行prometheus进程, `kill -9 pid`, `pid`可通过`ps -ef|grep prometheus.yml`查询
2. 更新配置信息 
    * 新建node_usage_record_rule.yml记录部分信息，并配置在prometheus.yml中的rule_files部分，详见附录
    * 更新prometheus.yml，增加受监控主机信息，详见附录prometheus.yml的node_exporter部分
3. 启动prometheus进程，`nohup ./prometheus --config.file=prometheus.yml --web.listen-address=0.0.0.0:9990 --storage.tsdb.path /data/data01/prometheus/ >> nohup.out 2>&1 &`


## 3. grafana

略

## 4. 可视化

选用合适的dashboard。推荐使用ID为16098的通用模板， ID为8919的模板更适用于云环境。

注意下载最新的版本的dashboard json文件， 路径： dashboard详情页 -- Revisions -- Download

Grafana中操作步骤：

1. Create -- Import -- Upload Json File -- Select prometheus datasource  Import

# 总结
选择合适的dashboard，事半功倍，我们可以在既有的dashboard基础上，做二次扩展。


# 附录

## node_usage_record_rule.yml
```
groups:   #新rule文件需要加这行开头，追加旧的rule文件则不需要。
    - name: node_usage_record_rules
      interval: 1m
      rules:
      - record: cpu:usage:rate1m
        expr: (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[1m])) by (instance,vendor,account,group,name)) * 100
      - record: mem:usage:rate1m
        expr: (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

可使用`./promtool check rules /path/to/example.rules.yml`，检查规则文件合规性

## prometheus.yml

```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
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
  - node_usage_record_rule.yml

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9990"]
  - job_name: 'pushgateway'
    honor_labels: true
    static_configs:
      - targets: ['10.50.253.9:9091']
        labels:
          instance: 'pushgateway'
  - job_name: 'elasticsearch'  
    static_configs:
    - targets: ['localhost:9114']
  - job_name: 'debezium'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.50.253.6:7071','10.50.253.7:7071','10.50.253.1:7071','10.50.253.2:7071','10.50.253.3:7071','10.50.253.4:7071','10.50.253.5:7071']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.50.253.6:9100','10.50.253.7:9100','10.50.253.1:9100','10.50.253.2:9100','10.50.253.3:9100','10.50.253.4:9100','10.50.253.5:9100']
```