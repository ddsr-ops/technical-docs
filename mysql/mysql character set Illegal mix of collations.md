���ݿ��в�ѯ����:Illegal mix of collations (latin1_swedish_ci,IMPLICIT) and (utf8_general_ci,COERCIBLE) for operation '=';

1.����mysql��my.ini,��client��server���ַ�����Ϊutf8

2.���ı��Լ��ֶεĵ��ַ���Ϊutf8

Illegal mix of collations ������



ALTER TABLE so_publish_rule CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE so_video_file_deploy CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;



�鿴���ṩ��������

show variables like '%char%';

show table status from datebase like '%tb%';

show full colums form tablename;

�޸ģ�

����û���ı���Ĭ���ַ��������е��ַ��е��ַ�����һ���µ��ַ�����ʹ���������䣺
ALTER TABLE tbl_name CONVERT TO CHARACTER SET charset_name;

���棺
�������������ַ�����ת����ֵ������û����ַ������� gb2312������һ���У����洢��ֵʹ�õ���������һЩ�����ݵ��ַ������� utf8������ô�ò���������õ��û������Ľ��������������£��û������ÿһ�������²�����

ALTER TABLE t1 CHANGE c1 c1 BLOB;
ALTER TABLE t1 CHANGE c1 c1 TEXT CHARACTER SET utf8;

��������ԭ���ǣ��� BLOB ��ת����ת���� BLOB ��û��ת��������

����û�ָ���Զ����ƽ��� CONVERT TO CHARACTER SET���� CHAR��VARCHAR �� TEXT �н�ת��Ϊ���Ƕ�Ӧ�Ķ������ַ������ͣ�BINARY��VARBINARY��BLOB��������ζ����Щ�н��������ַ��������� CONVERT TO ����Ҳ���������õ������ϡ�

��������ı�һ�����ȱʡ�ַ�������ʹ���������䣺

ALTER TABLE tbl_name DEFAULT CHARACTER SET charset_name;

DEFAULT�ǿ�ѡ�ġ�����һ���������һ���µ���ʱ�����û��ָ���ַ�������Ͳ���ȱʡ���ַ��������統ALTER TABLE ... ADD column����

ALTER TABLE ... DEFAULT CHARACTER SET �� ALTER TABLE ... CHARACTER SET �ǵȼ۵ģ��޸ĵĽ�����ȱʡ�ı��ַ�����



1.�޸�MySQL�����ݿ���ַ���
alter database shop default character set utf8 collate utf8_bin;
2.�޸�MySQL�ı���ַ���
alter table producttype default character set utf8 collate utf8_bin
3.�޸�MySQL���ֶε��ַ���
alter table producttype change name name varchar(128) character set utf8 collate utf8_bin not null;


UPDATE tbl_a a , tbl_b b SET a.Id= b.id WHERE CONVERT(a.email USING utf8) COLLATE utf8_unicode_ci = b.email



mysql concat����������
concat(str1,str2)
��concat�������������ʱ�������������ӵ��ֶ����Ͳ�ͬ���£���concat�е��ֶβ���һ����varchar���ͣ�һ����int���ͻ�doule���ͣ��ͻ�������롣

���������
����mysql���ַ���ת������CONVERT��������ʽ��Ϊchar���;Ϳ����ˡ�
������
concat('����:',CONVERT(int1,char),CONVERT(int2,char),'���:',CONVERT(double1,char),CONVERT(double2,char))
