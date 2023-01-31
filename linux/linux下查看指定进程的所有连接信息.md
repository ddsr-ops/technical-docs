lsof -p 4721 -nP | grep TCP

4721为进程号

lsof 的 -nP 参数用于将 ip 地址和端口号显示为正常的数值类型，否则可能会用别名表示。