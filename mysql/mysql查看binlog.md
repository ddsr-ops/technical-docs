��鿴mysql��binlog�ļ����������binlog�ļ����޷�ֱ�ӵģ�mysqlbinlog��������������鿴binlog�ļ����ݵģ�ʹ�÷�ʽman mysqlbinlog�鿴����
����ʹ��mysqlbinlog��binlog�ļ�ת��������ɶ�������ʱȴ����

`mysqlbinlog: unknown variable 'default-character-set=utf8'`

ԭ����mysqlbinlog��������޷�ʶ��binlog�е������е�default-character-set=utf8���ָ�

�����������Խ���������

һ����MySQL������/etc/my.cnf �н� default-character-set=utf8  �޸�Ϊ character-set-server = utf8����������Ҫ����MySQL����������MySQL��������æ���������Ĵ��ۻ�Ƚϴ�

������ mysqlbinlog --no-defaults mysql-bin.00000XX ����򿪡�



��binlog�ļ����ӻ�������䣺
```
# ���ݿ�ʼ�ͽ���ʱ��鿴��־
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-datetime='2022-02-22 17:04:00' --stop-datetime='2022-02-22 17:05:00' mysql-bin.000416

# ���ݿ�ʼ�ͽ���λ�ò鿴��־
mysqlbinlog --no-defaults --base64-output=decode-rows -v --start-position=676 --stop-position=10765 mysql-bin.000417
```
