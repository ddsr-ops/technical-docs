linuxϵͳ���ļ��򿪵��������������ƣ���ͨ������Ϊ1024

����ͨ������`ulimit -a`��`ulimit -n`�鿴��ǰ���̿��Դ򿪵�����ļ���

ͨ������`cat /proc/sys/fs/file-max`�鿴��ǰϵͳ֧�ֵ�����ļ���

ͨ������`ulimit -n 65535`�޸ĵ�ǰ���̵Ŀɴ򿪵�����ļ���������˳���ǰshell�ٴν�����ʧЧ

�����޸Ľ��̼���Ŀɴ��ļ��������
```shell
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf
```

�����޸�ϵͳ����Ŀɴ��ļ��������
```shell
vi /etc/sysctl.conf
fs.file-max=35942900
```