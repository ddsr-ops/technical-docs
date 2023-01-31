ModuleNotFoundError: No module named '_bz2'

该错误是缺失_bz2.cpython-38-x86_64-linux-gnu.so这个os文件，处理步骤如下：

1）下载该文件: https://pan.baidu.com/s/1iPuEBYnUABWf94QM9fQZgQ 提取码: nw2g

2）将下载后的文件放到python3.8文件夹里/usr/local/python/lib/python3.8/lib-dynload/目录下；

在lib-dynload目录下使用"chmod +x _bz2.cpython-38-x86_64-linux-gnu.so"增加该文件的可执行权限

3）再次运行程序可能还会报错：ImportError: libbz2.so.1.0: cannot open shared object file: No such file or directory

1.首先需要使用sudo yum install -y bzip2* 确保系统已经安装了相关的库；

2.此时会发现在/usr/lib64目录下会发现其实有libbz2.so.1.0.6这样一个文件，我们只需要在该目录下使用命令

"sudo ln -s libbz2.so.1.0.6 libbz2.so.1.0"创建一个该文件的软连接。

这样就OK了
