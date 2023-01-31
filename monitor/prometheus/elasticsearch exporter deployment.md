# Deploy elasticsearch exporter for prometheus and configure grafana dashboard

## Deploy elasticsearch exporter

Download the package named elasticsearch_exporter-1.3.0.linux-amd64.tar.gz from the [website](https://github.com/prometheus-community/elasticsearch_exporter/releases).

Then, unzip the tar file, and start the exporter. 

```shell
[root@namenode2 elasticsearch_exporter-1.3.0]# pwd
/opt/module/monitor/prometheus/elasticsearch_exporter-1.3.0
[root@namenode2 elasticsearch_exporter-1.3.0]# ls
CHANGELOG.md  dashboard.json  deployment.yml  elasticsearch_exporter  elasticsearch.rules  LICENSE  nohup.out  README.md

nohup ./elasticsearch_exporter --es.all --es.indices --es.indices_settings --es.indices_mappings --es.cluster_settings --es.shards --es.snapshots --es.uri="http://datanode2:9200" >> nohup.out 2>&1 &
```

Show help options by using `./elasticsearch_exporter -h`. The default web listen port is 9114, ensure the port is not occupied by other processes.

## Start(Restart) prometheus service

Add elasticsearch job in prometheus yml file. 

```text
[root@namenode2 prometheus-2.32.1]# more prometheus.yml
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
      - targets: ['localhost:9091']
        labels:
          instance: 'pushgateway'
  - job_name: 'elasticsearch'  
    static_configs:
    - targets: ['localhost:9114']
```

If the prometheus service is running, stop it firstly by using `kill -9 pid`.
Launch prometheus by using `nohup ./prometheus --config.file=prometheus.yml 
--web.listen-address="0.0.0.0:9990" >> nohup.out 2>&1 &`.

## Import dashboard in grafana

Download dashboard json file from [url](https://grafana.com/grafana/dashboards/6483). 
Configure the dashboard with the json file, **CREATE -- IMPORT -- UPLOAD JSON FILE**