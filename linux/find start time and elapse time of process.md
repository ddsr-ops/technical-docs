ps -eo lstart ����ʱ��

ps -eo etime ���ж೤ʱ��.

ps -eo pid,lstart,etime | grep 5176

etime ��ʾ���ԴӸý���������������������ʱ�䣬��ʽΪ [[DD-]hh:]mm:ss��
etimes ��ʾ���Ըý���������������������ʱ�䣬�������ʽ��



ps -eo pid,lstart,etime,cmd | grep 'php'  
```
 321 Mon Apr 22 08:10:01 2019    06:54:18 /usr/local/php7.3/bin/php -f /www/php7.3/html/wms/moudle/cron/service/cron/auto_task_cli.mdl.php act=suning_item_sync sd_id=1082 cmd_suffix=1
 485 Mon Apr 22 13:44:02 2019    01:20:17 /usr/local/php7.3/bin/php -f /www/php7.3/html/wms/moudle/cron/service/cron/auto_task_cli.mdl.php act=update_remarks sd_id=2160 cmd_suffix=1

```

```
ps -eo pid,lstart,etime,%mem,rss,vsz,cmd|grep doris

ps -eo pid,lstart,etime,%mem,rss,vsz,cmd|grep palo_be|grep -v grep|grep -v source
```