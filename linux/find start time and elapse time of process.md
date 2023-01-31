ps -eo lstart 启动时间

ps -eo etime 运行多长时间.

ps -eo pid,lstart,etime | grep 5176

etime 显示了自从该进程启动以来，经历过的时间，格式为 [[DD-]hh:]mm:ss。
etimes 显示了自该进程启动以来，经历过的时间，以秒的形式。



ps -eo pid,lstart,etime,cmd | grep 'php'  
```
 321 Mon Apr 22 08:10:01 2019    06:54:18 /usr/local/php7.3/bin/php -f /www/php7.3/html/wms/moudle/cron/service/cron/auto_task_cli.mdl.php act=suning_item_sync sd_id=1082 cmd_suffix=1
 485 Mon Apr 22 13:44:02 2019    01:20:17 /usr/local/php7.3/bin/php -f /www/php7.3/html/wms/moudle/cron/service/cron/auto_task_cli.mdl.php act=update_remarks sd_id=2160 cmd_suffix=1

```

```
ps -eo pid,lstart,etime,%mem,rss,vsz,cmd|grep doris

ps -eo pid,lstart,etime,%mem,rss,vsz,cmd|grep palo_be|grep -v grep|grep -v source
```