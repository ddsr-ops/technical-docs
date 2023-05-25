For example,

```shell
port=`grep port application.yml`
pcount=`netstat -tnlp|grep $port|wc -l`
echo $pcount
```

Here, variable `pcount` always return 0. It is because variable `port` includes a '\r'.
Removing it can conquer the problem.


```shell
PROCESS_PORT=`grep port config/application.yml|awk '{print $NF}'|awk 'gsub(/^ *| *$/,"")'|sed  's/\r//'`
```

Note: using `bash -x some.sh xxx` could help you debug shell scripts.