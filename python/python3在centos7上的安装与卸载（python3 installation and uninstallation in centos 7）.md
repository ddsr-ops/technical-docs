# Installation

1. Download source code from python website.

2. Make and install.
    ```shell
    # --prefix��Python�İ�װĿ¼
    ./configure --prefix=/usr/local/python38
    make && make install
    ```
   
3. ���������ӣ����ǵÿ�ʼ��Linux�Ѿ���װ��python2.7.5��
   �������ǲ��ܽ���ɾ�������ɾ����ϵͳ���ܻ�������⡣����ֻ��Ҫ������Python2.7.5��ͬ�ķ�ʽΪPython3.8.6����һ�������Ӽ��ɣ����ǰ������ӷŵ�/usr/local/binĿ¼�£���ͼ��
   ```shell
   ln -s /usr/local/python38 /usr/local/bin/python3
   ls -l /usr/local/bin/
   ```

4. ������Ҫ�����û���������ʹpython3����ֱ�ӿɼ���һ�㣬ͨ��/etc/profile��~/.bash_profile���ü��ɡ�


# Uninstallation

1. If you install python via yum, you can uninstall python by using `rpm -qa|grep python3|xargs rpm -ev --allmatches --nodeps`

2. Delete other remaining files, `whereis python3 |xargs rm -frv` 

[Reference](https://zhuanlan.zhihu.com/p/357866208)