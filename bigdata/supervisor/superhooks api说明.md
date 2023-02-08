```
superhooks  -u http://10.50.253.7:18888/webhook/supervisor -e STARTING,RUNNING,BACKOFF,STOPPING,FATAL,EXITED,STOPPED,UNKNOWN \
-d "phone^18011449543,158XXXXXXXX^^exclude_group^superhooks,xxxx^^exclude_process^kafkaserver,xxxx"
```

Options
* -u URL, --url=http://10.50.253.7:18888/webhook/supervisor, Post the payload to the url with http POST

* -d DATA, --data=a^b^^c^d post body data as key value pair items are separated by ^^ and key and values are separated by ^

* -H HEADERS, --headers=p^q^^r^s request headers with as key value pair items are separated by ^^ and key and values are separated by ^

* -e EVENTS, --event=EVENTS The Supervisor Process State event(s) to listen for. It can be any, one of, or all of STARTING, RUNNING, BACKOFF, STOPPING, EXITED, STOPPED, UNKNOWN.

其他说明：

* phone为**必填参数**，短信送达的手机号码，多个手机号码以英文字符的逗号作为分隔符
  
* exclude_group, exclude_process为选填参数，多个group或process以英文字符的逗号作为分隔符
  如果事件的group或process在exclude_group，exclude_process中，则不发送短信。

推送短信说明：

推送短信内容样例，`【天府通】大数据应用服务[kafkaserver.203],运行情况[PROCESS_STATE_RUNNING],请知晓`

* kafkaserver表示process name

* 203取自操作系统ip最后一段数字，例如88.79.10.62为实际ip，则取62

* 运行情况表示当前process处于什么状态