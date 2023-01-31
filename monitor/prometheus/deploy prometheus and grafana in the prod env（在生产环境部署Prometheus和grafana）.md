# Goal

To monitor flink job in the visual mode, we need to deploy prometheus, pushgateway and grafana service.

# Prometheus Installation

## Download packages

Refer to [links](https://prometheus.io/download/), version is amd64.
If failed to download the prometheus package, move to [website](https://github.com/prometheus/prometheus/releases/) to download it. 

## Install Prometheus & pushgateway

```shell
[root@namenode2 gch]# mkdir /opt/module/monitor
[root@namenode2 gch]# mkdir -p /opt/module/monitor/prometheus /opt/module/monitor/grafana
[root@namenode2 gch]# tar -zxf prometheus-2.32.1.linux-amd64.tar.gz -C /opt/module/monitor/prometheus
[root@namenode2 gch]# cd !$
cd /opt/module/monitor/prometheus
[root@namenode2 prometheus]# ls
prometheus-2.32.1.linux-amd64
[root@namenode2 prometheus]# cd prometheus-2.32.1.linux-amd64/
[root@namenode2 prometheus-2.32.1.linux-amd64]# ls
console_libraries  consoles  LICENSE  NOTICE  prometheus  prometheus.yml  promtool
[root@namenode2 gch]# mkdir /opt/module/monitor/prometheus/pushgateway
[root@namenode2 gch]# tar -zxf pushgateway-1.4.2.linux-amd64.tar.gz -C !$
tar -zxf pushgateway-1.4.2.linux-amd64.tar.gz -C /opt/module/monitor/prometheus/pushgateway

# Config prometheus
[root@namenode2 prometheus-2.32.1.linux-amd64]# pwd
/opt/module/monitor/prometheus/prometheus-2.32.1.linux-amd64
[root@namenode2 prometheus-2.32.1.linux-amd64]# ls
console_libraries  consoles  LICENSE  NOTICE  prometheus  prometheus.yml  promtool
[root@namenode2 prometheus-2.32.1.linux-amd64]# vim prometheus.yml
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9990"]
  - job_name: 'pushgateway'
    static_configs:
      - targets: ['localhost:9091']
        labels:
          instance: 'pushgateway'
          
# Config pushgateway
# There is no pushgateway config file, specify the pushgateway port via ./pushgateway --web.listen-address=":9091"  
```

## Start prometheus and pushgateway
```shell
# Start pushgateway
[root@namenode2 pushgateway-1.4.2]# pwd
/opt/module/monitor/prometheus/pushgateway-1.4.2
[root@namenode2 pushgateway-1.4.2]# nohup ./pushgateway >> out.log 2>&1 &

# Start prometheus
[root@namenode2 prometheus-2.32.1]# pwd
/opt/module/monitor/prometheus/prometheus-2.32.1
[root@namenode2 prometheus-2.32.1]# nohup ./prometheus --config.file=prometheus.yml --web.listen-address="0.0.0.0:9990" >> nohup.out 2>&1 &
```


# Grafana Installation

## Download packages

Refer to [links](https://grafana.com/grafana/download?pg=get&plcmt=selfmanaged-box1-cta1), 
we should get packages suitable for redhat system.

## Installation

```shell
[root@namenode2 gch]# yum install -y grafana-enterprise-8.3.3-1.x86_64.rpm

# The default prot of grafana is  3000.
# Keep the default port, and start it.
[root@namenode2 gch]# systemctl list-unit-files|grep grafana
grafana-server.service                        disabled
[root@namenode2 gch]# systemctl enable grafana-server --now
Created symlink from /etc/systemd/system/multi-user.target.wants/grafana-server.service to /usr/lib/systemd/system/grafana-server.service.
[root@namenode2 gch]# systemctl status grafana-server

```

confirm that essential services were started.
```shell
[root@namenode2 gch]# netstat -tnlp|egrep -i "9990|9091|3000"
tcp6       0      0 :::9091                 :::*                    LISTEN      243171/./pushgatewa 
tcp6       0      0 :::9990                 :::*                    LISTEN      248485/./prometheus 
tcp6       0      0 :::3000                 :::*                    LISTEN      234055/grafana-serv
```

# Flink
We need to add a prometheus reporter in flink-conf.yaml file.

##Configure flink
```text
metrics.reporter.promgateway.class: org.apache.flink.metrics.prometheus.PrometheusPushGatewayReporter
metrics.reporter.promgateway.host: namenode2
metrics.reporter.promgateway.port: 9091
metrics.reporter.promgateway.randomJobNameSuffix: true
metrics.reporter.promgateway.deleteOnShutdown: true
metrics.reporter.promgateway.interval: 10 SECONDS
```

##Launch a streaming job

Before launching a streaming job, we should start a socket program via nc command.
If nc command not exists, install it with `yum install -y nc`

```shell
nc -l 19992

flinkbin run-application -t yarn-application \
-Djobmanager.memory.process.size=2048m \
-Dtaskmanager.memory.process.size=4096m \
-Dclassloader.resolve-order="parent-first" \
SocketWindowWordCount.jar --port 11992 --hostname namenode1
```