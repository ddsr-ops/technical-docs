# Installation

1. Download source code from python website.

2. Make and install.
    ```shell
    # --prefix是Python的安装目录
    ./configure --prefix=/usr/local/python38
    make && make install
    ```
   
3. 创建软链接：还记得开始，Linux已经安装了python2.7.5，
   这里我们不能将它删除，如果删除，系统可能会出现问题。我们只需要按照与Python2.7.5相同的方式为Python3.8.6创建一个软链接即可，我们把软链接放到/usr/local/bin目录下，如图：
   ```shell
   ln -s /usr/local/python38 /usr/local/bin/python3
   ls -l /usr/local/bin/
   ```

4. 根据需要，配置环境变量，使python3命令直接可见。一般，通过/etc/profile或~/.bash_profile配置即可。


# Uninstallation

1. If you install python via yum, you can uninstall python by using `rpm -qa|grep python3|xargs rpm -ev --allmatches --nodeps`

2. Delete other remaining files, `whereis python3 |xargs rm -frv` 

[Reference](https://zhuanlan.zhihu.com/p/357866208)