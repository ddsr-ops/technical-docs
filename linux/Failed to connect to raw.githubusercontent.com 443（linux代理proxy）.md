完整报错：

```curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused```

443 端口连接被拒一般是因为墙的原因，如果你可以科学上网（Virtual Private Network）的话，在命令行键以下命令执行：

```
# 7890 和 789 需要换成你自己的端口
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7891

export https_proxy=http://192.168.15.1:7890 http_proxy=http://192.168.15.1:7890 all_proxy=socks5://192.168.15.1:7891
```

再次执行之前连接 http://raw.githubusercontent.com:443 被拒绝的命令应该就成功了。

注意，确保主机和虚拟间的网络是畅通， 如有疑问，请查询本地文档《vmware virtual machine can not ping host（虚拟机无法ping通主机）.md》

特别注意：如果使用的clashR for wins，需打开允许局域网。
