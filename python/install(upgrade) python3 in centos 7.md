```1. 查看当前python版本
[root@iZwz99sau950q2nhb3pn0aZ ~]# python
Python 2.7.5 (default, Aug  7 2019, 00:51:29) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> 
可以看到执行python，默认是2.7

2. 安装依赖包
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
编译python源码时，需要一些依赖包，一次安装完毕

3. 安装wget
yum install wget
这个包是为了下载python源码用的

4. 下载源码包
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
我是下载的最新的python3.8，如果想安装其他版本，去python官网下载页面下载对应的版本即可。
但是这个下载链接比较慢，我是用迅雷下载到本地之后，再scp到服务器的。

5. 解压安装
# 解压压缩包
tar -zxvf Python-3.8.1.tgz  

# 进入文件夹
cd Python-3.8.1

# 配置安装位置
./configure prefix=/usr/local/python3

# 安装
make && make install
如果最后没提示出错，就代表正确安装了，在/usr/local/目录下就会有python3目录

[root@iZwz99sau950q2nhb3pn0aZ local]# cd /usr/local/
[root@iZwz99sau950q2nhb3pn0aZ local]# ls
aegis  bin  etc  games  include  lib  lib64  libexec  python3  sbin  share  src
6. 添加软连接
#添加python3的软链接 
ln -s /usr/local/python3/bin/python3.8 /usr/bin/python3 

#添加 pip3 的软链接 
ln -s /usr/local/python3/bin/pip3.8 /usr/bin/pip3
好了，我们来测试一下python3

[root@iZwz99sau950q2nhb3pn0aZ local]# python3
Python 3.8.1 (default, Feb  4 2020, 11:28:31) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
这里我没有链接到python上，是因为yum要用到python2才能执行，所以现在输入python的话还是会进入python2.7，输入python3才会进入python3.8

如果执意想要链接到python的话，就得修改一下yum的配置：


vi /usr/bin/yum 
把 #! /usr/bin/python 修改为 #! /usr/bin/python2 

vi /usr/libexec/urlgrabber-ext-down 
把 #! /usr/bin/python 修改为 #! /usr/bin/python2
```