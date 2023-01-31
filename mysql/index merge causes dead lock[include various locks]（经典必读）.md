[reference](https://www.jianshu.com/p/38b13b8b3920)

����

����������־
��־����
����֪ʶ��ϰ
���� ԭ�����
����취
д������ ��
����������־
��һ�� �ȵ�¼�� ��˾ ��yearing ���ƽ̨

ͨ�� show engine innodb status;
�����򵥵ĸ�ʽ�������õ�һ����־

 2019-09-22 04:00:05 0x2b9980b91700 
 *** (1) TRANSACTION: TRANSACTION 131690250, ACTIVE 0 sec fetching rows mysql tables in use 3, locked 3 

 LOCK WAIT 73 lock struct(s), heap size 8400, 
 3 row lock(s) 
 MySQL thread id 518726, OS thread handle 47938289870592, query id 813732402 172.31.16.205 ops_write updating 

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204222951376' and target_type = 0 and target = '171064635';

*** (1) WAITING FOR THIS LOCK TO BE GRANTED: 
RECORD LOCKS space id 118 page no 451030 n bits 640 index target of table `cf_msgbox`.`msgbox_message` 
/* Partition `p1910` */ 
trx id 131690250 lock_mode X locks rec but not gap waiting Record lock, 

heap no 569 PHYSICAL RECORD: n_fields 4; compact format;
 info bits 0 
0: len 9; hex 313731303634363335; asc 171064635;; 
1: len 1; hex 00; asc ;; 
2: len 8; hex 00000000031952bc; asc R ;; 
3: len 4; hex 5d79c74f; asc ]y O;; 


*** (2) TRANSACTION: 
TRANSACTION 131690230, ACTIVE 1 sec fetching rows mysql tables in use 3, 
locked 3 70 lock struct(s), heap size 8400, 
7 row lock(s) 
MySQL thread id 501733, 
OS thread handle 47938289604352, 
query id 813732142 172.31.29.84 ops_write updating 

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635' 


*** (2) HOLDS THE LOCK(S): 
RECORD LOCKS space id 118 page no 451030 n bits 640 index target of table `cf_msgbox`.`msgbox_message` 
/* Partition `p1910` */ 
trx id 131690230 lock_mode X locks rec but not gap Record lock, 
heap no 569 PHYSICAL RECORD: n_fields 4; compact format; info bits 0 

0: len 9; hex 313731303634363335; asc 171064635;; 
1: len 1; hex 00; asc ;; 
2: len 8; hex 00000000031952bc; asc R ;; 
3: len 4; hex 5d79c74f; asc ]y O;; 

Record lock, heap no 571 PHYSICAL RECORD: n_fields 4; compact format; info bits 0
0: len 9; hex 313731303634363335; asc 171064635;; 
1: len 1; hex 00; asc ;; 
2: len 8; hex 00000000031962fc; asc b ;; 
3: len 4; hex 5d79c808; asc ]y ;; 

*** (2) 
WAITING FOR THIS LOCK TO BE GRANTED: 
RECORD LOCKS space id 118 page no 1283285 n bits 152 index PRIMARY of table `cf_msgbox`.`msgbox_message` 
/* Partition `p1910`*/ 
trx id 131690230 lock_mode X locks rec but not gap waiting Record lock, 
heap no 60 PHYSICAL RECORD: n_fields 18; compact format; info bits 0 
0: len 8; hex 00000000031962fc; asc b ;; 
1: len 4; hex 5d79c808; asc ]y ;; 
2: len 6; hex 000006232f37; asc #/7;; 
3: len 7; hex 72000003330b29; asc r 3 );; 
4: len 4; hex 7fffffff; asc ;; 
5: len 4; hex 5d7c3e27; asc ]|>';; 
6: len 30; hex 6f726465724d73673a72657475726e3a534f4e3139303931323034323232; asc orderMsg:return:SON19091204222; (total 36 bytes); 
7: len 5; hex 6f72646572; asc order;; 
8: len 1; hex 00; asc ;; 
9: len 9; hex 313731303634363335; asc 171064635;; 
10: len 15; hex 52657475726e204175646974696e67; asc Return Auditing;; 
11: len 15; hex 52657475726e204175646974696e67; asc Return Auditing;; 
12: len 30; hex 2f6f7264657273232f534f3133343830393937322f72657475726e5f7265; asc /orders#/SO134809972/return_re; (total 34 bytes); 
13: len 4; hex 5dca3388; asc ] 3 ;; 
14: SQL NULL; 
15: len 13; hex 6f726465725f6d657373616765; asc order_message;; 
16: len 8; hex 8000000003195e72; asc ^r;; 
17: len 18; hex 63662d736572762d7573657263656e746572; asc cf-serv-usercenter;; 
*** WE ROLL BACK TRANSACTION (2) 

����:���ն����仯 ���¶�����Ϣ(�������漰�����һ��update���)
���±�ṹ:

CREATE TABLE `msgbox_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `record_status` int(11) NOT NULL DEFAULT '0' COMMENT '0 ����   -1ɾ��',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modify` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `msg_key` varchar(64)  DEFAULT NULL 
  `box` varchar(64)  NOT NULL COMMENT 'box key',
  `target_type` tinyint(3) unsigned NOT NULL ,
  `target` varchar(32)  NOT NULL ,
  `disappear_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`,`gmt_modify`),
  KEY `target` (`target`,`target_type`),
  KEY `msg_key` (`msg_key`),
  KEY `box_key` (`box`),
  KEY `gmt_modify` (`gmt_modify`),
  KEY `disappear_at` (`disappear_at`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='��Ϣ��¼��'

����һ������ѯʹ��ͬһ�����������һ��Block����TimeOut�Ĵ���Ŷԣ���ô��DeadLock?
��־���� ע��:
- (1) TRANSACTION���˴���ʾ����1��ʼ ��
- MySQL thread id 518726, OS thread handle 47938289870592, query id 813732402 172.31.16.205 ops_write updating �˴�Ϊ��¼��ǰ���ݿ��߳�id��
- update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635'  
: ��ʾ����1��ִ�е�sql,ͨ��show engine innodb status �ǲ鿴���������������sql�ģ�
  ͨ����ʾ��ǰ���ڵȴ�����sql�������ڱ�����  ����ֻ�漰����һ��sql;
- (1) WAITING FOR THIS LOCK TO BE GRANTED: �˴���ʾ��ǰ����1�ȴ���ȡ������
������ �ȴ� index target �� lock_mode X locks rec but not gap(Record Locks)

- (2) TRANSACTION���˴���ʾ����2��ʼ ��
- update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635' 
: ʾ����2��ִ�е�sql;
- (2) HOLDS THE LOCK(S)���˴���ʾ��ǰ����2���е�������
- (2) WAITING FOR THIS LOCK TO BE GRANTED���˴���ʾ��ǰ����2�ȴ���ȡ������
������ �ȴ� index PRIMARY ��lock_mode X locks rec but not gap waiting Record lock
���Կ���������������ӵ�жԷ���Ҫ��������¼����
�����ڵȴ��Է�����һ�����ͷţ����������������
��һ�����������ص����ݣ�

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204222951376' and target_type = 0 and target = '171064635';

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635'
ͨ�� where ���� ���ǿ��Կ�����
������䲢û���غϵ����ݣ��о��ϲ�����"����"����ô�����������ˣ�

Ϊʲô�������������
����֪ʶ��ϰ:
mysql ����ʵ�ֻ���:
���Ƕ�֪������ mysql innoDB ��������ͨ�������ϵ������������ʵ�ֵġ�
innoDB ������Ϊ���������ͷ������������֣����һ��sql������������������MySQL�ͻ����������������������һ���������˷�����������MySQL���������÷�������������������ص�����������
��innoDB�����������Ǿ۴�����,������Ҷ�ӽڵ������������ݡ�
������������Ҷ�ӽڵ��������������ֵ����InnoDB�У�����������Ҳ����Ϊ�Ǿ۴�����
innodb֧�����ݿ�ACID�����ԣ������ݸ���ʱ�ᱣ֤����һ���ԣ�������������update��䲻����ôִ�У����ݿⶼ�ᱣ֤���ݵĺϷ��ԣ�����ʹ���ݶ�ʧ�������ô����ô��ʵ������أ�
����˵�����Ƕ����ݼ�������С���Ⱦ����м��������������������������ܣ�Ϊ����߲����ԣ�MySQLʵ����MVCC��Ҳ���Ƕ�汾�������ƣ�ʵ�ֶ�����������д����ͻ��������ȡ������Ϊ���֣����ն���������& ��ǰ��������
���ն����ǳ����select��䣬��ȡʱ�����������п��ܶ��������°汾�����Խп��ն���
��ǰ���Ƕ�ȡ���ݵ����°汾�������¼��������
select * from table where ? lock in share mode;
select * from table where ? for update;
insert into table values(��);insert���ܻᴥ��unique��飬Ҳ�㵱ǰ��
update table set ? where ?;
delete from table where ?;
��ɾ�ı������������֣� �Ƚ����ݶ�ȡ�������ٶ����ݽ����޸ġ�ǰһ���ֶ�ȡ�����ǵ�ǰ������Ҫ��ȡ���°汾�����ݡ�Ϊ�˷�ֹ������������������ݽ����޸ģ���ǰ����Ҫ�Ե�ǰ���ݼ��ϻ��������޸���ɺ�Ž����ͷţ������ݵ��޸Ĵ��л�����֤��ȫ��
ԭ�����:
������ �� ���sql ��Ϊ:
update msgbox_message set record_status = -1 where
record_status = 0
and msg_key = X;
and target_type = Y and target = Z;
update ��� ����ʹ���� ��ǰ��(���Ƕ�ȡʵ�ʵĳ־û�������) ��ѯ��Ҫ���µļ�¼
��������� �����ȸ������� target ����
Ȼ�����ҵ������ϵ� primary key �ٴν���������
��� ͨ�� primary key ���µ����ǵ����ݡ�

���ΰ�����
����һ�ȴ� index target ����� �ȴ� primary key
�������ڵ�ǰ����������Ҫ�ص�ִ�мƻ����鿴��ǰ����ν��С�
(���� Yearning ��֧�� �� �� updete ��explan )
��������ֻ��ͨ��select ��� ��ѯ���׶���update �Ķ�ȡ�Ǹ���ô���Ĺ���

partitions	type	possible_keys	key	key_len	ref	row	filtered	Extra
p1910	index_merge	target_key,msg_key,gmt_create	target_key,msg_key	131,259		1	5	Useing intersect(target_key,msg_key),Useing where
�� ִ�мƻ��п��Կ�����MySQLʹ����index merge��
ʹ�����������ֱ�����ݣ�Ȼ�����ݽ���intersect(ȡ����)��Ҳ����˵��ǰ�������������������ϣ����������Ĺؼ�!!!
���Կ��� ִ�мƻ��� ������target��msg_key������merge

��Ϊ����ʹ�õ�������������where�������Ǹ�����������ômysql��ʹ��index merge�����Ż����Ż�������mysql����������1����ɨ����������2����ɨ��Ȼ���󽻼��γ�һ���ϲ����������ʹ������ɨ��Ĺ��̺����Ǳ����sqlʹ��������˳����ܴ��ڻ��⣬���������������

���������ϲ�
intersection ֻ�� �����ϲ��е�һ�֣����� union, sort_union ��
�����õ� index_merge ���бȽϿ��̵�������

������ Range ����(>5.6.7)������ key1=1 or (key1=2 and key2=3)������key1�ǿ���ת���� range scan �ģ�����ʹ�� index merge union
��Σ�Intersect��UnionҪ���� ROR���� Rowid-Ordered-Retrival��
�������
��� target + msg_key����������������Ϳ��Ա����index merge��
�� �Ż�����index merge�Ż��ر�
��select id Ȼ�����id updete ��
������� ��¼һ��֪ʶ��:
��������&����
Shared and Exclusive Locks

Shared lock: ������,�ٷ�������permits the transaction that holds the lock to read a row
eg��select * from xx where a=1 lock in share mode

Exclusive Locks����������
permits the transaction that holds the lock to update or delete a row
eg: select * from xx where a=1 for update

Intention Locks

������Ǽ���table�ϵģ���ʾҪ����һ���㼶����¼�����м���
Intention shared (IS����Transaction T intends to set S locks on individual rows in table t
Intention exclusive (IX): Transaction T intends to set X locks on those rows
�����ݿ�㿴���Ľ���������ģ�
TABLE LOCK table `lc_3`.`a` trx id 133588125 lock mode IX
Record Locks

�����ݿ�㿴���Ľ���������ģ�
RECORD LOCKS space id 281 page no 3 n bits 72 index PRIMARY of table 
`lc_3`.`a` trx id 133588125   
lock_mode X locks rec but not gap
�����Ǽ��������ϵģ��������index PRIMARY of table lc_3.a ���ܿ�������
��¼���������������ͣ�
lock_mode X locks rec but not gap
lock_mode S locks rec but not gap
Gap Locks

�����ݿ�㿴���Ľ���������ģ�
- RECORD LOCKS space id 281 page no 5 n bits 72 index idx_c of table 
`lc_3`.`a` trx id 133588125   
lock_mode X locks gap before rec
Gap����������ֹinsert��
Gap������������϶������ס�Ĳ��Ǽ�¼�����Ƿ�Χ,
���磺(negative infinity, 10����(10, 11�����䣬���ﶼ�ǿ�����Ŷ
Next-Key Locks

�����ݿ�㿴���Ľ���������ģ�
RECORD LOCKS space id 281 page no 5 n bits 72 index idx_c of table 
`lc_3`.`a` trx id 133588125   
lock_mode X
Next-Key Locks = Gap Locks + Record Locks �Ľ��,
��������ס��¼��������ס��϶��
���磺 (negative infinity, 10����(10, 11�����䣬��Щ�ұ߶��Ǳ�����Ŷ
Insert Intention Locks

�����ݿ�㿴���Ľ���������ģ�
RECORD LOCKS space id 279 page no 3 n bits 72 index PRIMARY of table lc_3.t1 trx id 133587907   
lock_mode X insert intention waiting
Insert Intention Locks �������Ϊ�����Gap����һ�֣�������������д�������
AUTO-INC Locks

�����ݿ�㿴���Ľ���������ģ�
TABLE LOCK table xx trx id 7498948 lock mode AUTO-INC waiting
���ڱ������
����������ϸ�������֮ǰ��һƪ����:
http://keithlan.github.io/2017/03/03/auto_increment_lock/
��¼������϶����Next-key ���Ͳ���������������������Ӧ���������£�
��¼����LOCK_REC_NOT_GAP��: lock_mode X locks rec but not gap
��϶����LOCK_GAP��: lock_mode X locks gap before rec
Next-key ����LOCK_ORNIDARY��: lock_mode X
������������LOCK_INSERT_INTENTION��: lock_mode X locks gap before rec insert intention
�ο�����:

https://www.hollischuang.com/archives/3461
https://www.jianshu.com/p/1dc4250c6f6f
https://ruby-china.org/topics/38429(һ�� MySQL ������������ --Index merge when update)
https://yq.aliyun.com/articles/8963/
https://www.aneasystone.com/archives/2018/04/solving-dead-locks-four.html
http://seanlook.com/2017/03/11/mysql-index_merge-deadlock/
http://www.ishenping.com/ArtInfo/133925.html (Innodb������־�ֶν��-����Ķ�������־)
https://segmentfault.com/a/1190000018730103 (�˽�MySQL������־)
https://www.itread01.com/content/1546402384.html
https://www.jianshu.com/p/e4f87d301415
http://loesspie.com/2019/06/12/mysql-using-intersect-deadlock/
������ǳ��Mysql�� �ڶ���

