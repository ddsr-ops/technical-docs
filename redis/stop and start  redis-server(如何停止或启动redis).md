�������apt-get����yum install��װ��redis������ֱ��ͨ�����������ֹͣ/����/����redis

/etc/init.d/redis-server stop
/etc/init.d/redis-server start
/etc/init.d/redis-server restart

�����ͨ��Դ�밲װ��redis�������ͨ��redis�Ŀͻ��˳���redis-cli��shutdown����������redis

1.redis�ر�
redis-cli -h 127.0.0.1 -p 6379 shutdown

2.redis����
redis-server

���������ʽ��û�гɹ�ֹͣredis�������ʹ���ռ����� kill -9