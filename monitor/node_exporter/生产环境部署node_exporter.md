# ����

��ǰHadoop�����ݻ�����������Դ�й���CM���ģ�����CM�ṩ�ļ��ָ�꼰�����Ȳ�������ѡ��������������Դ��ؼ����ֶΣ�������Դ����״̬��¼��

# Ŀ��

���������ļ���ֶΣ��γ�ָ��ɼ���ָ����㡢ָ����ӻ��ȼ��ʵ��ͨ·�ıջ���

# ����滮

| ��� | ��; | ����IP |
| :----| :---- | :---- |
| node_exporter_1.3.1 | ����ָ����Ϣ�ռ� | 10.50.253.1-7 |
| prometheus-2.32.1 | �洢ָ����Ϣ | 10.50.253.7 |
| grafana-8.3.3 | ָ����ӻ� | 10.50.253.7  |

# ʵʩ����

## 1. node_exporter

node_exporter���Ϊ�ռ���������ָ����Ϣ�� Ӧ�������ܼ�ص�������

����������� [node_exporter github](https://github.com/prometheus/node_exporter/releases), ѡ��`node_exporter-1.3.1.linux-amd64.tar.gz
`

```shell
tar -zxf node_exporter-1.3.1.linux-amd64.tar.gz -C /opt/module
echo "nohup ./node_exporter --collector.systemd --collector.processes > nohup.out 2>&1 &" > start.sh
chmod u+x start.sh
./start.sh
```

ͨ��`nohup.out`��־��˿ںż�飬��ȷ�������������� `netstat -an|grep 9100`.

## 2. prometheus

prometheus���Ϊ�洢���ݣ�������������ԡ�

1. ֹͣ������prometheus����, `kill -9 pid`, `pid`��ͨ��`ps -ef|grep prometheus.yml`��ѯ
2. ����������Ϣ 
    * �½�node_usage_record_rule.yml��¼������Ϣ����������prometheus.yml�е�rule_files���֣������¼
    * ����prometheus.yml�������ܼ��������Ϣ�������¼prometheus.yml��node_exporter����
3. ����prometheus���̣�`nohup ./prometheus --config.file=prometheus.yml --web.listen-address=0.0.0.0:9990 --storage.tsdb.path /data/data01/prometheus/ >> nohup.out 2>&1 &`


## 3. grafana

��

## 4. ���ӻ�

ѡ�ú��ʵ�dashboard���Ƽ�ʹ��IDΪ16098��ͨ��ģ�壬 IDΪ8919��ģ����������ƻ�����

ע���������µİ汾��dashboard json�ļ��� ·���� dashboard����ҳ -- Revisions -- Download

Grafana�в������裺

1. Create -- Import -- Upload Json File -- Select prometheus datasource  Import

# �ܽ�
ѡ����ʵ�dashboard���°빦�������ǿ����ڼ��е�dashboard�����ϣ���������չ��


# ��¼

## node_usage_record_rule.yml
```
groups:   #��rule�ļ���Ҫ�����п�ͷ��׷�Ӿɵ�rule�ļ�����Ҫ��
    - name: node_usage_record_rules
      interval: 1m
      rules:
      - record: cpu:usage:rate1m
        expr: (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[1m])) by (instance,vendor,account,group,name)) * 100
      - record: mem:usage:rate1m
        expr: (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

��ʹ��`./promtool check rules /path/to/example.rules.yml`���������ļ��Ϲ���

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