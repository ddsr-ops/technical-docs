数据库中查询报错:Illegal mix of collations (latin1_swedish_ci,IMPLICIT) and (utf8_general_ci,COERCIBLE) for operation '=';

1.更改mysql的my.ini,把client和server的字符集改为utf8

2.更改表以及字段的的字符集为utf8

Illegal mix of collations 处理方法



ALTER TABLE so_publish_rule CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE so_video_file_deploy CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;



查看：提供以下三种

show variables like '%char%';

show table status from datebase like '%tb%';

show full colums form tablename;

修改：

如果用户想改变表的默认字符集和所有的字符列的字符集到一个新的字符集，使用下面的语句：
ALTER TABLE tbl_name CONVERT TO CHARACTER SET charset_name;

警告：
上述操作是在字符集中转换列值。如果用户在字符集（如 gb2312）中有一个列，但存储的值使用的是其它的一些不兼容的字符集（如 utf8），那么该操作将不会得到用户期望的结果。在这种情况下，用户必须对每一列做如下操作：

ALTER TABLE t1 CHANGE c1 c1 BLOB;
ALTER TABLE t1 CHANGE c1 c1 TEXT CHARACTER SET utf8;

这样做的原因是：从 BLOB 列转换或转换到 BLOB 列没有转换发生。

如果用户指定以二进制进行 CONVERT TO CHARACTER SET，则 CHAR、VARCHAR 和 TEXT 列将转换为它们对应的二进制字符串类型（BINARY，VARBINARY，BLOB）。这意味着这些列将不再有字符集，随后的 CONVERT TO 操作也将不会作用到它们上。

如果仅仅改变一个表的缺省字符集，可使用下面的语句：

ALTER TABLE tbl_name DEFAULT CHARACTER SET charset_name;

DEFAULT是可选的。当向一个表里添加一个新的列时，如果没有指定字符集，则就采用缺省的字符集（例如当ALTER TABLE ... ADD column）。

ALTER TABLE ... DEFAULT CHARACTER SET 和 ALTER TABLE ... CHARACTER SET 是等价的，修改的仅仅是缺省的表字符集。



1.修改MySQL的数据库的字符集
alter database shop default character set utf8 collate utf8_bin;
2.修改MySQL的表的字符集
alter table producttype default character set utf8 collate utf8_bin
3.修改MySQL的字段的字符集
alter table producttype change name name varchar(128) character set utf8 collate utf8_bin not null;


UPDATE tbl_a a , tbl_b b SET a.Id= b.id WHERE CONVERT(a.email USING utf8) COLLATE utf8_unicode_ci = b.email



mysql concat乱码问题解决
concat(str1,str2)
当concat结果集出现乱码时，大都是由于连接的字段类型不同导致，如concat中的字段参数一个是varchar类型，一个是int类型或doule类型，就会出现乱码。

解决方法：
利用mysql的字符串转换函数CONVERT将参数格式化为char类型就可以了。
举例：
concat('数量:',CONVERT(int1,char),CONVERT(int2,char),'金额:',CONVERT(double1,char),CONVERT(double2,char))
