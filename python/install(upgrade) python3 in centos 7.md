```1. �鿴��ǰpython�汾
[root@iZwz99sau950q2nhb3pn0aZ ~]# python
Python 2.7.5 (default, Aug  7 2019, 00:51:29) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> 
���Կ���ִ��python��Ĭ����2.7

2. ��װ������
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
����pythonԴ��ʱ����ҪһЩ��������һ�ΰ�װ���

3. ��װwget
yum install wget
�������Ϊ������pythonԴ���õ�

4. ����Դ���
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
�������ص����µ�python3.8������밲װ�����汾��ȥpython��������ҳ�����ض�Ӧ�İ汾���ɡ�
��������������ӱȽ�����������Ѹ�����ص�����֮����scp���������ġ�

5. ��ѹ��װ
# ��ѹѹ����
tar -zxvf Python-3.8.1.tgz  

# �����ļ���
cd Python-3.8.1

# ���ð�װλ��
./configure prefix=/usr/local/python3

# ��װ
make && make install
������û��ʾ�����ʹ�����ȷ��װ�ˣ���/usr/local/Ŀ¼�¾ͻ���python3Ŀ¼

[root@iZwz99sau950q2nhb3pn0aZ local]# cd /usr/local/
[root@iZwz99sau950q2nhb3pn0aZ local]# ls
aegis  bin  etc  games  include  lib  lib64  libexec  python3  sbin  share  src
6. ���������
#���python3�������� 
ln -s /usr/local/python3/bin/python3.8 /usr/bin/python3 

#��� pip3 �������� 
ln -s /usr/local/python3/bin/pip3.8 /usr/bin/pip3
���ˣ�����������һ��python3

[root@iZwz99sau950q2nhb3pn0aZ local]# python3
Python 3.8.1 (default, Feb  4 2020, 11:28:31) 
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
������û�����ӵ�python�ϣ�����ΪyumҪ�õ�python2����ִ�У�������������python�Ļ����ǻ����python2.7������python3�Ż����python3.8

���ִ����Ҫ���ӵ�python�Ļ����͵��޸�һ��yum�����ã�


vi /usr/bin/yum 
�� #! /usr/bin/python �޸�Ϊ #! /usr/bin/python2 

vi /usr/libexec/urlgrabber-ext-down 
�� #! /usr/bin/python �޸�Ϊ #! /usr/bin/python2
```