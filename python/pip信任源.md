If you install python via yum, the version is the latest. 

~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com


If system is window, new  a `pip.ini` file in `%appdata%' directory.

1. open resource explorer, and type `%appdata%` in input selector, then enter the directory
2. new a `pip` directory  in `%appdata%` directory, then new a `pip.ini` file in the `pip` directory
3. add the following content to `pip.ini` file
> [global]
timeout = 6000
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn