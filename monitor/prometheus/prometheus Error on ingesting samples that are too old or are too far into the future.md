prometheus日志中出现以下  
```text
Error on ingesting samples that are too old or are too far into the future
```
cancel job auto-starting  
取消prometheus自动启动
```shell
systemctl disable prometheus
start prometheus mannually, it worked correctly
/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml
```
