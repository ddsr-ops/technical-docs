failed to obtain node locks, tried [[/var/lib/elasticsearch]] with lock id [0];

������Ϣ��

failed to obtain node locks, tried [[/var/lib/elasticsearch]] with lock id [0]; maybe these locations are not writable or multiple nodes were started without increasing [node.max_local_storage_nodes]
Elasticsearch version 6.8.2

# �������һ��
����ES���̺ţ�ɱ������Ȼ��������

ps -ef | grep elastic
kill -9 ���̺�

�˴���ѯ���������������̣� ��ɱ��

# �����������
�������ES�Ĺ���ԱȨ�ޣ�chown -R �û���:���� �ļ�Ŀ¼ 

chown -R elastic /var/lib/elasticsearch/

# �����������
��������Ϊ��װ��ES�Ĳ�����޸��������ļ� elasticsearch.yml

����Щע�ͻ�ɾ����������

http.cors.allow-origin: 'http://localhost:1358'
http.cors.enabled: true
http.cors.allow-headers: X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
http.cors.allow-credentials: true