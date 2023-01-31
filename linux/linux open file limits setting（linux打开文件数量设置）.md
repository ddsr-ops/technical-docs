linux系统对文件打开的数量有最大的限制，它通常设置为1024

首先通过命令`ulimit -a`或`ulimit -n`查看当前进程可以打开的最大文件数

通过命令`cat /proc/sys/fs/file-max`查看当前系统支持的最大文件数

通过命令`ulimit -n 65535`修改当前进程的可打开的最大文件数，如果退出当前shell再次进入则失效

永久修改进程级别的可打开文件最大数：
```shell
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf
```

永久修改系统级别的可打开文件最大数：
```shell
vi /etc/sysctl.conf
fs.file-max=35942900
```