����
�������¹��ϰ�

step0: ��������

1. MySQL5.6.27
2. InnoDB
3. Centos
����������ϣ�Ӧ�ø��󲿷ֹ�˾��ʵ��һ��
CREATE TABLE `new_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` varchar(200) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5908151 DEFAULT CHARSET=utf8 
CREATE TABLE `old_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xx` varchar(200) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5908151 DEFAULT CHARSET=utf8
   
step1: ҵ����Ҫ������ʷ���ݵ��±��±���д��
1. insert into new_table(x) select xx from old_table
2. ����������new_table��

step2: ��� 
show processlist;
�����ö���䶼����executing�׶Σ�DB�������κ���䶼�ǳ�����too many connection

step3: �鿴innoDB״��
show engine innodb status\G
�����
==lock==
---TRANSACTION 7509250, ACTIVE 0 sec setting auto-inc lock  --һ��
TABLE LOCK table `xx`.`y'y` trx id 7498948 lock mode AUTO-INC waiting  --һ��
ģ�����⣬��������
�������ٴη����źö�λ�������

��ṹ
```
| t_inc | CREATE TABLE `t_inc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` varchar(199) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5908151 DEFAULT CHARSET=utf8 |
CREATE TABLE `t_inc_template` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cookie_unique` varchar(255) NOT NULL DEFAULT '' COMMENT '',
    PRIMARY KEY (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=5857489 DEFAULT CHARSET=utf8
```

step1
session1��insert into t_inc(x) select cookie_unique from t_inc_template;
session2��mysqlslap -hxx -ulc_rx -plc_rx -P3306  --concurrency=10 --iterations=1000 --create-schema='lc'  --query="insert into t_inc(x) select 'lanchun';" --number-of-queries=10
��������,Ȼ���Զ���������id��

step2���۲�
```
| 260126 | lc_rx       | x:22833 | NULL | Sleep   |       8 |                                                        | NULL                                                          |
| 260127 | lc_rx       | x:22834 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260128 | lc_rx       | x:22835 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260129 | lc_rx       | x:22836 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260130 | lc_rx       | x:22837 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260131 | lc_rx       | x:22838 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260132 | lc_rx       | x:22840 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260133 | lc_rx       | x:22839 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260134 | lc_rx       | x:22842 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260135 | lc_rx       | x:22841 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
| 260136 | lc_rx       | x:22843 | lc   | Query   |       8 | executing                                              | insert into t_inc(x) select 'lanchun'                         |
```
step3 show engine innodb status
TABLE LOCK table `lc`.`t_inc` trx id 113776506 lock mode AUTO-INC waiting
һ��������waiting
Ȼ����
���������Ѿ����֣����Ҳ֪����ʲôԭ������ˣ��Ǿ��ǣ�AUTO-INC lock

������
����������������

��auto_increment��ص�insert����
INSERT-like
���ͣ��κλ�����¼�¼����䣬������INSERT-like�����磺
 INSERT, INSERT ... SELECT, REPLACE, REPLACE ... SELECT, and LOAD DATA
 
 
��֮��������simple-inserts��, ��bulk-inserts��, and ��mixed-mode�� inserts.

simple insert
����ļ�¼������ȷ���ģ����磺insert into values��replace
���ǲ������� INSERT ... ON DUPLICATE KEY UPDATE.

Bulk inserts
����ļ�¼������������ȷ���ģ����磺 INSERT ... SELECT, REPLACE ... SELECT, and LOAD DATA
Mixed-mode inserts
��Щ����simple-insert�����ǲ���auto incrementֵ�������߲�����
1. INSERT INTO t1 (c1,c2) VALUES (1,'a'), (NULL,'b'), (5,'c'), (NULL,'d');
2. INSERT ... ON DUPLICATE KEY UPDATE
���϶���Mixed-mode inserts
   
��ģʽ
innodb_autoinc_lock_mode = 0 (��traditional�� lock mode)

�ŵ㣺���䰲ȫ
ȱ�㣺��������ģʽ��д����������Ϊ�κ�һ��insert-like��䣬�������һ��table-level AUTO-INC lock
innodb_autoinc_lock_mode = 1 (��consecutive�� lock mode)

ԭ������Ĭ����ģʽ��������bulk inserts��ʱ�򣬻����һ�������AUTO-INC table-level lockֱ����������ע�⣺�����������������ͷ������������������Ŷ����Ϊһ��������ܰ����ܶ���䣩
����Simple inserts����ʹ�õ���һ������������ֻҪ��ȡ����Ӧ��auto increment���ͷ�����������ȵ���������
PS��������AUTO-INC table-level lock��ʱ����������������Ҳ��������ɹ�����ȴ���������
�ŵ㣺�ǳ���ȫ��������innodb_autoinc_lock_mode = 0���Ҫ�úܶࡣ
ȱ�㣺���ǻ���������������
����˼���� Ϊʲô���ģʽҪ������������أ�
��Ϊ����Ҫ��֤bulk insert����id�������ԣ���ֹ��bulk insert��ʱ�򣬱�������insert�������auto incrementֵ��
innodb_autoinc_lock_mode = 2 (��interleaved�� lock mode)

ԭ��������bulk insert��ʱ�򣬲������table���������������Ϊ������������insert����ġ�
��һ����¼���������һ��auto ֵ������Ԥ���䡣
�ŵ㣺���ܷǳ��ã���߲�����SBR����ȫ
ȱ�㣺
    һ��bulk insert���õ�������id���ܲ�����
    SBRģʽ�£��ᵼ�¸��Ƴ�����һ��
����
��innodb_autoinc_lock_mode = 2 ��SBRΪʲô����ȫ
master �����߼��ͽ��
��ṹ��a primary key auto_increment,b varchar(3)
```
time_logic_clock	session1��bulk insert����	session2�� insert like
0	                       1,A		
1		                                                        2,AA
2	                       3,B		
3	                       4,C		
4		                                                        5,CC
5	                       6,D	
```
���յĽ���ǣ�
```
a	b
1	A
2	AA
3	B
4	C
5	CC
6	D
```
slave�����ս��
��Ϊbinlog��session2�������ִ���꣬���½��Ϊ
```
a	b
1	AA
2	CC
3	A
4	B
5	C
6	D
```
RBRΪʲô�Ͱ�ȫ�أ�
��ΪRBR���Ǹ���row image���ģ������û��ϵ�ġ�

���ˣ�ͨ�����϶Աȷ��������Ŵ�Ҷ�֪������ξ����˰ɣ�

innodb_autoinc_lock_mode = 2 ��һ��С����
����innodb_autoinc_lock_mode = 2����伶���������ô���п������ �����id���ύ��ǰ���id���ύ

�ٸ����ӣ�
```
session A:
    begin;
    insert into xx values() ;   --��ʱ�������id ��100
session B:
    begin
    insert into xx values() ;   --��ʱ�������id ��101
session B:
    commit;  --��ζ��id=101�ļ�¼�Ȳ��뵽���ݿ�
session A:
    commit;  --��ζ��id=100�ļ�¼����뵽���ݿ�
```
��󣬶������ݿ���˵��û�д����⣬��Ϊ���ݶ���������ˣ�ֻ�Ǻ����id�Ȳ���������ѡ�

�����е�ҵ��������⣺���磬ĳЩҵ���������id���б���

```
select * from xx where id>1 limit N
select * from xx where id>1+N limit N
select * from xx where id>1+N+N limit N
```
���id��˳�����ģ���û���⡣ ��������id�Ȳ������������id=101������ôid=100��û�ύ��id�ͱ�������Ե��ˣ��ɴ˶�ҵ����˵�Ͷ���id=100 ������¼

���������where id>N and add_date< (NOW() - INTERVAL 5 second) ȡǰ5s�����ݣ����Ͳ���д�����������

�ܽ�
������binlog-format��rowģʽ�����Ҳ�����һ��bulk-insert��autoֵ������һ�㲻�ù��ģ�����ô����innodb_autoinc_lock_mode = 2 ������߸��õ�д�����ܡ�