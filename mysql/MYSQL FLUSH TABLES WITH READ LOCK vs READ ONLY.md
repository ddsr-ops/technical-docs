# Difference between flush tables with read lock and read only

## Flush tables with read lock 

�ر����б��Ҹ��������ݿ���ı����ȫ�ֶ���������һ�ַǳ�����ر���ʱ��֤�����ļ�һ���Է�����ʹ��UNLOCK TABLES�����ͷ�����

FLUSH TABLES WITH READ LOCK��ȡ����ȫ�ֶ������Ǳ������������LOCK TABLES��ȡ������һ��������UNLOCK TABLES����ʽ�ύ��

���κα�LOCK TABLES�����סʱ��UNLOCK TABLES����ʽ�ύ����FLUSH TABLES WITH READ LOCK����ִ��UNLOCK TABLES������ʽ�ύ,��Ϊ���߲����ȡ������
������Ŀ�ʼ(BEGIN;)����LOCK TABLES�������������ͷţ����㻹ûִ��UNLOCK TABLES.��ʼ���񲻻��ͷ�FLUSH TABLES WITH READ LOCK������ȫ�ֶ���

��5.1.19֮ǰ��FLUSH TABLES WITH READ LOCK�ͷֲ�ʽ����ʱ�����ݵ�

FLUSH TABLES WITH READ LOCK����Ӱ������ѯ��־�ͺ�ͨ�ò�ѯ��־���д��

**�ò��������������Ự�ĸ��²��������Ƿ���flush�����ĻỰһ����unlock tables��������˳���ǰ�Ự��ȫ�ֶ������ͷţ��������²���������ִ��DML**

����ʹ��flush����ȥ�п⶯����������ģ�flush tables with read lock��Ҫ��;�Ƿ�innodb��������ݿⱸ�ݣ�[�ο�����](https://www.percona.com/doc/percona-xtrabackup/LATEST/xtrabackup_bin/flush-tables-with-read-lock.html)

<u>Flush tables with read lock�ᱻ������slave�ڵ㣬flush local tables with read lock���Ḵ�Ƶ�slave�ڵ�</u>

## read_only 
`set global read_only = 1`, ����ȫ�ֱ�������������Ự��������ݣ���ֱ�ӱ�����**��������**���ӿ�����read_only, ����Ӱ��sql thread���У�ͬʱ����superȨ�޵��û���Ȼ���Ը������ݡ�


## Difference
���Ͽɿ�����������Ҫ����
* ������ ǰ�����������Ự��DMLִ�У����߲������������Ự���������ݣ� ��ֱ�ӱ���
* ������ ǰ��ʹ��unlock tables�����������˳�����flush����ĻỰ���������� �����������ĻỰ����ִ�У� �����˳���������ĻỰ�޷������� ֻ��ʹ��`set global read_only = 0`����

���⣬�����������û�г�ͻ��ϵ������ͬһ���Ự���Ⱥ�ִ�С�


������������ñ��ɶ�������Ĳ��ɶ���������ʹ��lock����ɽ��`lock tables tab_a write, tab_b write, ...`, �����������Ự��ȡ�����ı�ʹ��`unlock tables`���˳���ǰ�Ự�ɽ�����
�����ı���д��һ�д����

ʹ�ó�����
�����ǽ�������ֿ�ʱ����Ӧ����ȫֹͣ��ʹ��`set global read_only = 1`������ֻ���� ��ɲ��󣬹ر�ֻ����ʹ��`lock tables ....`���������ȥ�ı���ֹӦ�������д����vip��������Ӧ�á�
�۲�Ӧ����־���鿴�Ƿ���������д�����ȥ�ı�����ʱ�޸�Ӧ�����á��������ʹ��unlock tables�ͷ����� 

