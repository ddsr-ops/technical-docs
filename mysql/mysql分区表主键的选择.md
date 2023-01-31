���Ƕ�֪������mysql�Ŀ����淶�У�������ϵ�����ʹ������id�������ڲ����ʱ�򣬲���ȥ�����ƶ����ݣ���������Ƭ�����������ٶ�Ҳ����Ӱ�죬���Ƕ��ڷ�������Ϊ��������Ҫ�����������У���ô�������������ѡ��ҵ���ֶλ���ʹ������id+�������ķ�ʽ���������һ�£�

```
CREATE TABLE `t_table` (
  `account_id` varchar(20) NOT NULL DEFAULT '',
  `table_catalog` varchar(20) DEFAULT NULL,
  `table_schema` varchar(20) DEFAULT NULL,
  `table_name` varchar(20) DEFAULT NULL,
  `table_type` varchar(20) DEFAULT NULL,
  `engine` varchar(20) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `table_rows` varchar(20) DEFAULT NULL,
  `checksum` varchar(20) DEFAULT NULL,
  `table_comment` varchar(20) DEFAULT NULL,
  `start_date` date NOT NULL DEFAULT '0000-00-00',
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`account_id`,`start_date`)
) 
/*!50100 PARTITION BY RANGE (TO_DAYS(start_date))
(PARTITION p201510 VALUES LESS THAN (736268) ENGINE = InnoDB,
 PARTITION p201511 VALUES LESS THAN (736298) ENGINE = InnoDB,
 PARTITION p201512 VALUES LESS THAN (736329) ENGINE = InnoDB,
 PARTITION p201601 VALUES LESS THAN (736360) ENGINE = InnoDB,
 PARTITION p201602 VALUES LESS THAN (736389) ENGINE = InnoDB,
 PARTITION p201603 VALUES LESS THAN (736420) ENGINE = InnoDB,
 PARTITION p201604 VALUES LESS THAN (736450) ENGINE = InnoDB,
 PARTITION p201605 VALUES LESS THAN (736481) ENGINE = InnoDB,
 PARTITION p201606 VALUES LESS THAN (736511) ENGINE = InnoDB,
 PARTITION p201607 VALUES LESS THAN (736542) ENGINE = InnoDB,
 PARTITION p201608 VALUES LESS THAN (736573) ENGINE = InnoDB,
 PARTITION p201609 VALUES LESS THAN (736603) ENGINE = InnoDB,
 PARTITION p201610 VALUES LESS THAN (736634) ENGINE = InnoDB,
 PARTITION p201611 VALUES LESS THAN (736664) ENGINE = InnoDB,
 PARTITION p201612 VALUES LESS THAN (736695) ENGINE = InnoDB,
 PARTITION p201701 VALUES LESS THAN (736726) ENGINE = InnoDB,
 PARTITION p201702 VALUES LESS THAN (736754) ENGINE = InnoDB,
 PARTITION p201703 VALUES LESS THAN (736785) ENGINE = InnoDB,
 PARTITION p201704 VALUES LESS THAN (736815) ENGINE = InnoDB,
 PARTITION p201705 VALUES LESS THAN (736846) ENGINE = InnoDB,
 PARTITION p201706 VALUES LESS THAN (736876) ENGINE = InnoDB,
 PARTITION p201707 VALUES LESS THAN (736907) ENGINE = InnoDB,
 PARTITION p201708 VALUES LESS THAN (736938) ENGINE = InnoDB,
 PARTITION p201709 VALUES LESS THAN (736968) ENGINE = InnoDB,
 PARTITION p201710 VALUES LESS THAN (736999) ENGINE = InnoDB,
 PARTITION p201711 VALUES LESS THAN (737029) ENGINE = InnoDB,
 PARTITION p201712 VALUES LESS THAN (737060) ENGINE = InnoDB,
 PARTITION p201801 VALUES LESS THAN (737091) ENGINE = InnoDB,
 PARTITION p201802 VALUES LESS THAN (737119) ENGINE = InnoDB,
 PARTITION p201803 VALUES LESS THAN (737150) ENGINE = InnoDB,
 PARTITION p201804 VALUES LESS THAN (737180) ENGINE = InnoDB,
 PARTITION p201805 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */
```
���ɲ������ݵĽű���
```
#!/usr/bin/python
#encoding: utf-8
import MySQLdb
import random
import string
# �����ݿ�����
db = MySQLdb.connect(host="127.0.0.1",user="root",passwd="",db="test",port=3333)
# # ʹ��cursor()������ȡ�����α�
cursor = db.cursor()
# # ʹ��execute����ִ��SQL���
a = None
for i in range (1,2000000):
    sql = "insert ignore into test.t_table(account_id,table_catalog,table_schema,table_name,table_type,engine,version,tab
le_rows,checksum,table_comment,start_date,end_date)" \
       " values(rand_string(10),rand_string(10),'%s','%s','%s','%s',%d,%d,%d,'%s',concat('2017-',floor(4+rand()*10),'-',f
loor(rand()*30)),concat('2017-',floor(4+rand()*10),'-',floor(rand()*30)))"%(random.choice('abcdefghijklmnopqrstuvwxyz!@#$
%^&*()'),random.choice('abcdefghijklmnopqrstuvwxyz!@#$%^&*()'),random.choice('abcdefghijklmnopqrstuvwxyz!@#$%^&*()'),rand
om.choice('abcdefghijklmnopqrstuvwxyz!@#$%^&*()'), random.randint(1,50), random.randint(1,50), random.randint(1,50),rando
m.choice('abcdefghijklmnopqrstuvwxyz!@#$%^&*()'))
    #print sql
    cursor.execute(sql)

    db.commit()
# # �ر����ݿ�����
db.close()
```

ʹ�õ�����������ַ����ĺ�����ժ������
```
CREATE DEFINER=`root`@`localhost` FUNCTION `rand_string`(n INT) RETURNS varchar(255) CHARSET utf8
BEGIN
    DECLARE chars_str varchar(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    DECLARE return_str varchar(255) DEFAULT '';
    DECLARE i INT DEFAULT 0;
    WHILE i < n DO
        SET return_str = concat(return_str,substring(chars_str , FLOOR(1 + RAND()*62 ),1));
        SET i = i +1;
    END WHILE;
    RETURN return_str;
END 
```
����Ա��в�����200w�����ݣ��鿴��Ƭ���
```
mysql> select count(*) from t_table;
+������-+
| count(*) |
+������-+
| 1999975 |
+������-+

mysql> select table_name,engine,table_rows,data_length+index_length length,DATA_FREE from information_schema.tables where TABLE_SCHEMA=��test�� and table_name=��t_table��;
+��������+�����C+��������+�������C+�������C+
| table_name | engine | table_rows | length | DATA_FREE |
+��������+�����C+��������+�������C+�������C+
| t_table | InnoDB | 1992893 | 227377152 | 44040192 |
+��������+�����C+��������+�������C+�������C+
```
��������������+�����ֶε�����в����
```
 CREATE TABLE `t_table2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(20) DEFAULT NULL,
  `table_catalog` varchar(20) DEFAULT NULL,
  `table_schema` varchar(20) DEFAULT NULL,
  `table_name` varchar(20) DEFAULT NULL,
  `table_type` varchar(20) DEFAULT NULL,
  `engine` varchar(20) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `table_rows` varchar(20) DEFAULT NULL,
  `checksum` varchar(20) DEFAULT NULL,
  `table_comment` varchar(20) DEFAULT NULL,
  `start_date` date NOT NULL DEFAULT '0000-00-00',
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`,`start_date`)
) ENGINE=InnoDB AUTO_INCREMENT=905084 DEFAULT CHARSET=utf8 
/*!50100 PARTITION BY RANGE (TO_DAYS(start_date))
(PARTITION p201510 VALUES LESS THAN (736268) ENGINE = InnoDB,
 PARTITION p201511 VALUES LESS THAN (736298) ENGINE = InnoDB,
 PARTITION p201512 VALUES LESS THAN (736329) ENGINE = InnoDB,
 PARTITION p201601 VALUES LESS THAN (736360) ENGINE = InnoDB,
 PARTITION p201602 VALUES LESS THAN (736389) ENGINE = InnoDB,
 PARTITION p201603 VALUES LESS THAN (736420) ENGINE = InnoDB,
 PARTITION p201604 VALUES LESS THAN (736450) ENGINE = InnoDB,
 PARTITION p201605 VALUES LESS THAN (736481) ENGINE = InnoDB,
 PARTITION p201606 VALUES LESS THAN (736511) ENGINE = InnoDB,
 PARTITION p201607 VALUES LESS THAN (736542) ENGINE = InnoDB,
 PARTITION p201608 VALUES LESS THAN (736573) ENGINE = InnoDB,
 PARTITION p201609 VALUES LESS THAN (736603) ENGINE = InnoDB,
 PARTITION p201610 VALUES LESS THAN (736634) ENGINE = InnoDB,
 PARTITION p201611 VALUES LESS THAN (736664) ENGINE = InnoDB,
 PARTITION p201612 VALUES LESS THAN (736695) ENGINE = InnoDB,
 PARTITION p201701 VALUES LESS THAN (736726) ENGINE = InnoDB,
 PARTITION p201702 VALUES LESS THAN (736754) ENGINE = InnoDB,
 PARTITION p201703 VALUES LESS THAN (736785) ENGINE = InnoDB,
 PARTITION p201704 VALUES LESS THAN (736815) ENGINE = InnoDB,
 PARTITION p201705 VALUES LESS THAN (736846) ENGINE = InnoDB,
 PARTITION p201706 VALUES LESS THAN (736876) ENGINE = InnoDB,
 PARTITION p201707 VALUES LESS THAN (736907) ENGINE = InnoDB,
 PARTITION p201708 VALUES LESS THAN (736938) ENGINE = InnoDB,
 PARTITION p201709 VALUES LESS THAN (736968) ENGINE = InnoDB,
 PARTITION p201710 VALUES LESS THAN (736999) ENGINE = InnoDB,
 PARTITION p201711 VALUES LESS THAN (737029) ENGINE = InnoDB,
 PARTITION p201712 VALUES LESS THAN (737060) ENGINE = InnoDB,
 PARTITION p201801 VALUES LESS THAN (737091) ENGINE = InnoDB,
 PARTITION p201802 VALUES LESS THAN (737119) ENGINE = InnoDB,
 PARTITION p201803 VALUES LESS THAN (737150) ENGINE = InnoDB,
 PARTITION p201804 VALUES LESS THAN (737180) ENGINE = InnoDB,
 PARTITION p201805 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */
```

�ٴ�ִ�в���������ݵĴ��룬�鿴��Ƭ���
```
mysql> select count(*) from t_table2;
+������-+
| count(*) |
+������-+
| 1999999 |
+������-+
1 row in set (0.63 sec)
mysql> select table_name,engine,table_rows,data_length+index_length length,DATA_FREE from information_schema.tables where TABLE_SCHEMA=��test�� and table_name in(��t_table2��,��t_table��);
+��������+�����C+��������+�������C+�������C+
| table_name | engine | table_rows | length | DATA_FREE |
+��������+�����C+��������+�������C+�������C+
| t_table | InnoDB | 1992893 | 227377152 | 44040192 |
| t_table2 | InnoDB | 1993098 | 152698880 | 41943040 |
+��������+�����C+��������+�������C+�������C+
```
����table2�е���Ƭ��СҪСһЩ�������пռ���Ȼ�ܴ󣬵����ҵ������û����Ƭ��������������Ƭ����Ϊid�������ģ����Ŀǰ������������Ĵ����ʽ�������Ǹ������еĲ�̫һ���������и�table3������ͨ��id��������������200w���ݺ󣬿��пռ�5M��Զ��40MС��
optimize �����Ƭ��ʧ
```
mysql> optimize table t_table;
+���������C+������-+������-+��������������������������������������������-+
| Table | Op | Msg_type | Msg_text |
+���������C+������-+������-+��������������������������������������������-+
| test.t_table | optimize | note | Table does not support optimize, doing recreate + analyze instead |
| test.t_table | optimize | status | OK |
+���������C+������-+������-+��������������������������������������������-+
2 rows in set (9.56 sec)

mysql> select table_name,engine,table_rows,data_length+index_length length,DATA_FREE from information_schema.tables where TABLE_SCHEMA=��test�� and table_name in(��t_table2��,��t_table��);
+��������+�����C+��������+�������C+�������C+
| table_name | engine | table_rows | length | DATA_FREE |
+��������+�����C+��������+�������C+�������C+
| t_table | InnoDB | 1984043 | 147668992 | 0 |
| t_table2 | InnoDB | 1993098 | 152698880 | 41943040 |
+��������+�����C+��������+�������C+�������C+
������������Ϣ����

mysql> SELECT PARTITION_NAME,TABLE_ROWS FROM INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME='t_table2';                  
+----------------+------------+
| PARTITION_NAME | TABLE_ROWS |
+----------------+------------+
| p201510        |     259307 |
| p201511        |          0 |
| p201512        |          0 |
| p201601        |          0 |
| p201602        |          0 |
| p201603        |          0 |
| p201604        |          0 |
| p201605        |          0 |
| p201606        |          0 |
| p201607        |          0 |
| p201608        |          0 |
| p201609        |          0 |
| p201610        |          0 |
| p201611        |          0 |
| p201612        |          0 |
| p201701        |          0 |
| p201702        |          0 |
| p201703        |          0 |
| p201704        |     193085 |
| p201705        |     193344 |
| p201706        |     192407 |
| p201707        |     192660 |
| p201708        |     192030 |
| p201709        |     192886 |
| p201710        |     191968 |
| p201711        |     193030 |
| p201712        |     192359 |
| p201801        |          0 |
| p201802        |          0 |
| p201803        |          0 |
| p201804        |          0 |
| p201805        |          0 |
+----------------+------------+
mysql> SELECT PARTITION_NAME,TABLE_ROWS FROM INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME='t_table';
+----------------+------------+
| PARTITION_NAME | TABLE_ROWS |
+----------------+------------+
| p201510        |     258544 |
| p201511        |          0 |
| p201512        |          0 |
| p201601        |          0 |
| p201602        |          0 |
| p201603        |          0 |
| p201604        |          0 |
| p201605        |          0 |
| p201606        |          0 |
| p201607        |          0 |
| p201608        |          0 |
| p201609        |          0 |
| p201610        |          0 |
| p201611        |          0 |
| p201612        |          0 |
| p201701        |          0 |
| p201702        |          0 |
| p201703        |          0 |
| p201704        |     193187 |
| p201705        |     192100 |
| p201706        |     192778 |
| p201707        |     192552 |
| p201708        |     187915 |
| p201709        |     193230 |
| p201710        |     193004 |
| p201711        |     187255 |
| p201712        |     193456 |
| p201801        |          0 |
| p201802        |          0 |
| p201803        |          0 |
| p201804        |          0 |
| p201805        |          0 |
+----------------+------------+
```
```
CREATE TABLE t_table3 (
id int(11) NOT NULL AUTO_INCREMENT,
account_id varchar(20) DEFAULT NULL,
table_catalog varchar(20) DEFAULT NULL,
table_schema varchar(20) DEFAULT NULL,
table_name varchar(20) DEFAULT NULL,
table_type varchar(20) DEFAULT NULL,
engine varchar(20) DEFAULT NULL,
version varchar(20) DEFAULT NULL,
table_rows varchar(20) DEFAULT NULL,
checksum varchar(20) DEFAULT NULL,
table_comment varchar(20) DEFAULT NULL,
start_date date DEFAULT NULL,
end_date date DEFAULT NULL,
PRIMARY KEY (id)
mysql> select table_name,engine,table_rows,data_length+index_length length,DATA_FREE from information_schema.tables where TABLE_SCHEMA=��test�� and table_name in(��t_table2��,��t_table��,��t_table3��);
+��������+�����C+��������+�������C+�������C+
| table_name | engine | table_rows | length | DATA_FREE |
+��������+�����C+��������+�������C+�������C+
| t_table | InnoDB | 1984043 | 147668992 | 0 |
| t_table2 | InnoDB | 1993098 | 152698880 | 9437184 |
| t_table3 | InnoDB | 1991739 | 139100160 | 5242880 |
+��������+�����C+��������+�������C+�������C+

create index idx_start_date on t_table3(start_date);
Query OK, 0 rows affected (4.95 sec)

ysql>
select table_name,engine,table_rows,data_length+index_length length,DATA_FREE from information_schema.tables where TABLE_SCHEMA=��test�� and table_name in(��t_table2��,��t_table��,��t_table3��);
+��������+�����C+��������+�������C+�������C+
| table_name | engine | table_rows | length | DATA_FREE |
+��������+�����C+��������+�������C+�������C+
| t_table | InnoDB | 1984043 | 147668992 | 0 |
| t_table2 | InnoDB | 1993098 | 152698880 | 9437184 |
| t_table3 | InnoDB | 1991739 | 139100160 | 0 |
+��������+�����C+��������+�������C+�������C+
```
���ǿ��Կ����ڲ��������ݺ󣬼�ʹ��id��������Ҳ������Ƭ���ڣ������ڴ��������󣬻�ʹ����Ƭ�Ŀռ䡣
�ܽ᣺
�Ӳ��Խ���������������ѡ��Ч����id����+�����ֶθ�ҵ���ֶ�+�����ֶ�Ч����ûʲô����