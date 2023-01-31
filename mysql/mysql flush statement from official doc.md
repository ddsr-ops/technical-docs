�﷨��
```text
FLUSH [NO_WRITE_TO_BINLOG | LOCAL] {
    flush_option [, flush_option] ...
  | tables_option
}

flush_option: {
    BINARY LOGS
  | DES_KEY_FILE
  | ENGINE LOGS
  | ERROR LOGS
  | GENERAL LOGS
  | HOSTS
  | LOGS
  | PRIVILEGES
  | OPTIMIZER_COSTS
  | QUERY CACHE
  | RELAY LOGS [FOR CHANNEL channel]
  | SLOW LOGS
  | STATUS
  | USER_RESOURCES
}

tables_option: {
    TABLES
  | TABLES tbl_name [, tbl_name] ...
  | TABLES WITH READ LOCK
  | TABLES tbl_name [, tbl_name] ... WITH READ LOCK
  | TABLES tbl_name [, tbl_name] ... FOR EXPORT
}
```

flush���ᴥ����ʽ�ύ

����flush��������mysqladmin����ִ�У�����flush-hosts,flush-logs,flush-privileges,flush-status,�Լ�flush-tables�ȵȡ�

### LOCAL
LOCAL�����Ӹ��ƻ�����flash���Ĭ�ϻ�ͬ����Slave�ڵ㣬flush logs��flush binary logs,flush tables(or table_list) read lock,�Լ�flush tables table_list for export���⣬��Ϊ��Щ���ͬ����slave�ڵ������⡣
��Local(��NO_WRITE_TO_BINLOG)��ʾ��д��Binlog��������ͬ����slave�ڵ㡣

�����������SIGNUPָ��ᴥ��ĳЩflush������

reset���������flush��

###FLUSH BINARY LOGS

�رղ������´�����д��binlog����binlog����������£�����������binlog�ļ�����һ��

###FLUSH DES KEY FILE

��--des-key-fileѡ��ָ�����ļ������¼���DES��

ע�⣺
DES_ENCRYPT()��DES_DECRYPT()������5.7.6�����ˣ����ڽ����İ汾���Ƴ���--des-key-fileѡ���des_key_fileϵͳ����Ҳ���Ƴ�

###FLUSH ENGINE LOGS

�رղ����´������Ѱ�װ�Ĵ洢����ġ���ˢ�¡�����־�������innodb����־ˢ�����

###FLUSH ERROR LOGS

�رղ����´򿪷���������д�Ĵ�����־

###FLUSH GENERAL LOGS

�رղ����´򿪷���������д��ͨ����־

###FLUSH HOST

���host�����Լ�Performance Schme�е�host_cache��
����������IP��ַ�ı����� host ��host_name�� is blocked����ʱ��ҪFlush host ���档
��ĳ��host IP����ʱ������more than max_connect_errors errors������������ӻ�һֱ��Ϊ��̨�����������Ⲣ����ֹ�������ӣ���flush host�����ø�IP��ַ�ٴγ������ӡ�

###FLUSH LOGS

�رղ����´򿪷�����д��������־�ļ������binlog������������һ��binlog�ļ���
���relay logging�����ˣ�������һ��relay log�ļ���

��������ѯ��־��ͨ�ò�ѯ��־û��Ӱ��

###FLUSH OPTIMIZER COST
���¶�ȡ�ɱ�ģ�ͱ�ʹ���Ż���ʹ�õ�ǰ���µĳɱ�����ͳ�ơ�ֻ��Flush���������ĻỰ��Ӱ��

###FLUSH PRIVILEGES

���¶�ȡMYSQLϵͳ���ݿ��е���Ȩ��صı�

GRANT��CREATE USER��CREATE SERVER��INSTALL PLUGIN�������ڷ������л�����Ϣ��
����Щ���治������REVOKE��DROP USER��DROP SERVER�Լ�UNINSTALL PLUGIN����ִ�ж���ʧ��
FLUSH PRIVILEGES�������ͷ���Щ����

###FLUSH QUERY CACHE

�����ѯ�������Ƭ�Ը��õ������ڴ档FLUSH QUERY CACHE��������κβ�ѯ���棬
����FLUSH TABLES��RESET QUERY CACHE��������������棩��

ע�⣺
��ѯ������5.7.20����������Mysql8.0���Ƴ���

###FLUSH RELAY LOGS[FOR CHANNEL channel]

�رղ����´򿪷���������д��relay log �ļ������relay log������������һ��relay log�ļ���

FOR CHANNEL *channel*�Ӿ�����ָ���ض����ƣ�replication��ͨ����
���Բ�ָ��ͨ��������������Ĭ��ͨ����Ҳ����ָ�����ͨ��������������ָ��������ͨ��

###FLUSH SLOW LOGS

�رղ������´򿪷���������д������ѯ��־��

###FLUSH STATUS

ע�⣺
show_compatibility_56ϵͳ������ֵ��Ӱ�����ѡ��Ĳ���������ο�ϵͳ�����ֲ�

���ѡ���ѵ�ǰ�̵߳ĻỰ״̬����ֵ����λȫ��ֵ��ͬʱ�ѻỰֵ��Ϊ0.ĳЩȫ�ֱ���Ҳ�ᱻ����Ϊ0.
Ҳ���key caches�ļ���������Ϊ0���Ұ�max_used_connections״̬��������Ϊ��ǰ�򿪵���������.
��Щ��Ϣ�ڶԲ�ѯ����debuggingʱ��ʹ�õ���

###FLUSH USER RESOURCES

������per-hour�û���Դ����Ϊ0.��������дﵽ��Դ��per-hour���ӣ���ѯ�����µȣ����޵Ŀͻ������ָ̻����

***
FLASH TABLES �﷨

FLUSH TABLES=FLUSH TABLE��flush���ͬʱ���ж��ֻ�ȡ����ģʽ������ÿ��ֻ��ʹ��һ��ѡ�

ע�⣺
��������

FLUSH TABLES

�ر����д򿪵ı�ǿ�������еı�رգ�Ȼ����ղ�ѯ����;�������仺�档FLUSH TABLESҲ�Ὣ���в�ѯ�����еĲ�ѯ������������RESET QUERY CACHEһ����

LOCK TABLE ... READ��ͬʱ����FLUSH TABLES����Ҫ��flush��ͬʱ����ʹ��FLUSH TABLES tbl_name ... with READ LOCK.

###FLUSH TABLES tbl_name [,tbl_name] ...

ֻflushָ����һ�Ż���ű�����֮�䶺�Ÿ����������������ڣ�Ҳ���ᱨ��

###FLUSH TABLES WITH READ LOCK

�ر����б��Ҹ��������ݿ���ı����ȫ�ֶ���������һ�ַǳ�����ر���ʱ��֤�����ļ�һ���Է�����ʹ��UNLOCK TABLES�����ͷ�����

FLUSH TABLES WITH READ LOCK��ȡ����ȫ�ֶ������Ǳ������������LOCK TABLES��ȡ������һ��������UNLOCK TABLES����ʽ�ύ��

���κα�LOCK TABLES�����סʱ��UNLOCK TABLES����ʽ�ύ����FLUSH TABLES WITH READ LOCK����ִ��UNLOCK TABLES������ʽ�ύ,��Ϊ���߲����ȡ������
������Ŀ�ʼ(BEGIN;)����LOCK TABLES�������������ͷţ����㻹ûִ��UNLOCK TABLES.��ʼ���񲻻��ͷ�FLUSH TABLES WITH READ LOCK������ȫ�ֶ���
��5.1.19֮ǰ��FLUSH TABLES WITH READ LOCK�ͷֲ�ʽ����ʱ�����ݵ�

FLUSH TABLES WITH READ LOCK����Ӱ������ѯ��־�ͺ�ͨ�ò�ѯ��־���д��

FLUSH TABLES tbl_name [, tbl_name] ... WITH READ LOCK

FlushĳЩ����ȡ�����������ǻ�ȡ���Ԫ���ݶ�ռ�������Ի�ȴ����ϵ�������ɡ�Ȼ������Flush��Ļ��棬���´򿪱���ȡ������Ȼ��Ԫ���ݶ�ռ������Ϊ����������ȡ�����Լ�����Ԫ������֮�������Ự���Զ�ȡ�����޷��޸ı�

������������ȡ�˱�������˱���ӵ�ж�ÿ�ű��LOCK TABLESȨ�ޣ����⣬Flush����ҪRELOADȨ�ޡ�

�������ֵֻ��Ӧ���ڴ��ڵĻ�������ʱ�����������ʱ���ᱻ���ԡ��������ͼ���ᱨ��ER_WRONG_OBJECT��

ʹ��UNLOCK TABLES�����ͷ�����LOCK TABLES�ͷ������һ�ȡ������������START TRANSACTION���ͷ�������ʼ�µ�����

���һ�ű�Flushed�ı�һ��HANDLER�򿪣����handler����ʽ�ر�flushed���Ҷ�ʧλ��

###FLUSH TABLES tbl_name [, tbl_name] ... FOR EXPORT

����FLUSH TABLES����������innnodb��ȷ�����ϵı仯ˢ�µ����̣�ʹ��������ļ������ڷ��������е�����¿�����

���Ĺ���ԭ��

��ȡ��Ĺ���Ԫ��������ֻҪ�����Ự���޸���Щ����߳����������ͻᱻ������һ����ȡ���������Ը��±�����Ҳ�ᱻ������ֻ����ֻ����������ִ�С�
����Ǳ�Ĵ洢�����Ƿ�֧�ֵ���������в�֧�ֵģ������ER_ILLEGAL_HA�����������ִ��ʧ�ܡ�
����֪ͨ�洢����Ϊÿ�ű����õ�����׼�����洢�������ȷ�����е�������д����̡�
���ѻỰ��������ģʽ����ʹ��FOR EXPORT������ʱǰ���õ�Ԫ�����������ͷ�
FLUSH TABLES ... FOR EXPORT�����Ҫӵ�жԱ��selectȨ�ޡ���Ϊ���������ȡ���������Ҳ����ӵ��LOCK TABLESȨ�ޣ�����flush��������ҪreloadȨ�ޡ�

���ֻ��Ӧ���ڷ���ʱ�����������ʱ���ᱻ���ԡ����������ͼ�������ER WRONG OBJECT������������������ER NO SUCH TABLE����

innodb֧��ӵ���Լ���.ibd�ļ��ı��FOR EXPORT������ʹ��innodb_file_per_table��������ʱ�����ı���innodb�ᱣ֤��FOR EXPORT��䷢��֪ͨʱ�����еı仯��ˢ�µ����̡���FOR EXPORT�����Чʱ�������Ʊ������ļ��Ϳ��Կ����ˣ���Ϊ��ʱ�ڷ���������ʱ.ibd�ļ��ϵ�������һ����״̬��FOR EXPORT����Ӧ����innodbϵͳ��ռ��ļ����߾���FULLTEXT������innodb��

FLUSH TABLES ... FOR EXPORT֧��innodb������

��FOR EXPORT�´�֪ͨ��Innodb�Ὣ�ڴ��л��ռ��ļ�������Ĵ��̻����е�ĳ�����͵�����д����̡���ÿ�ű�innodb��������һ��table_name.cfg�ļ��������ݿ�Ŀ¼����.cfg�ļ���������Ϣ���Ժ��ٴε����ռ��ļ�����Ҫ��Ԫ���ݣ����Ե���ԭ������������ķ�������

��FOR EXPORT�����ɣ�Innodb������е���ҳˢ�µ���������ļ������б�������¼��ˢ��֮ǰ���Ⱥϲ�����ʱ������ס���Ǿ�̬�ģ���������һ��״̬��Ȼ��Ϳ��Կ���.bd��ռ��ļ��Լ���Ӧ��.cfg�ļ�����ȡ��Щ���һ���Կ��ա�

��ɱ�ĵ���֮��ʹ��UNLOCK TABLES�����ͷ�������ʹ��LOCK TABLESҲ�����ͷ����������һ��������ʹ��start transaction���ͷ�������ʼ�µ�����

���Ự�ڵ������κ��������ʹ��ʱ��ִ��FLUSH TABLES ... FOR EXPORT�ᱨ��

FLUSH TABLES ... WITH READ LOCK
FLUSH TABLES ... FOR EXPORT
LOCK TABLES ... READ
LOCK TABLES ... WRITE
���Ự��FLUSH TABLES ... FOR EXPORT��Чʱ��ʹ��������Щ���Ҳ�ᱨ��


FLUSH TABLES WITH READ LOCK
FLUSH TABLES ... WITH READ LOCK
FLUSH TABLES ... FOR EXPORT
