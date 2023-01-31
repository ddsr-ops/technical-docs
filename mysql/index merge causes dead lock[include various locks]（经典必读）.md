[reference](https://www.jianshu.com/p/38b13b8b3920)

几点

读懂死锁日志
日志分析
基础知识补习
死锁 原因分析
解决办法
写在最后的 锁
读懂死锁日志
第一步 先登录上 公司 的yearing 审核平台

通过 show engine innodb status;
经过简单的格式化我们拿到一下日志

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

背景:接收订单变化 更新订单消息(事物所涉及代码就一行update语句)
大致表结构:

CREATE TABLE `msgbox_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `record_status` int(11) NOT NULL DEFAULT '0' COMMENT '0 正常   -1删除',
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息记录表'

大致一看，查询使用同一索引，最多是一个Block，报TimeOut的错误才对，怎么报DeadLock?
日志分析 注释:
- (1) TRANSACTION：此处表示事务1开始 ；
- MySQL thread id 518726, OS thread handle 47938289870592, query id 813732402 172.31.16.205 ops_write updating 此处为记录当前数据库线程id；
- update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635'  
: 表示事务1在执行的sql,通过show engine innodb status 是查看不到完整的事务的sql的，
  通常显示当前正在等待锁的sql；不过在本案中  我们只涉及到这一个sql;
- (1) WAITING FOR THIS LOCK TO BE GRANTED: 此处表示当前事务1等待获取行锁；
本案中 等待 index target 上 lock_mode X locks rec but not gap(Record Locks)

- (2) TRANSACTION：此处表示事务2开始 ；
- update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635' 
: 示事务2在执行的sql;
- (2) HOLDS THE LOCK(S)：此处表示当前事务2持有的行锁；
- (2) WAITING FOR THIS LOCK TO BE GRANTED：此处表示当前事务2等待获取行锁；
本案中 等待 index PRIMARY 的lock_mode X locks rec but not gap waiting Record lock
可以看出，两个事务互相拥有对方需要的主键记录锁，
而又在等待对方的另一把锁释放，所以造成了死锁。
看一看两条语句相关的内容：

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204222951376' and target_type = 0 and target = '171064635';

update msgbox_message set record_status = -1 where record_status = 0 and gmt_create >= now() - INTERVAL 3 MONTH and gmt_create < now() + INTERVAL 1 HOUR and msg_key = 'orderMsg:return:SON19091204192462327' and target_type = 0 and target = '171064635'
通过 where 条件 我们可以看到，
两条语句并没有重合的内容，感觉上不符合"常理"，那么问题问题来了：

为什么还会产生死锁？
基础知识补习:
mysql 行锁实现机制:
我们都知道的是 mysql innoDB 的行锁是通过索引上的索引项加锁来实现的。
innoDB 索引分为主键索引和非主键索引两种，如果一条sql语句操作了主键索引，MySQL就会锁定这条主键索引；如果一条语句操作了非主键索引，MySQL会先锁定该非主键索引，再锁定相关的主键索引。
在innoDB中主键索引是聚簇索引,索引的叶子节点存的是整行数据。
非主键索引的叶子节点的内容是主键的值，在InnoDB中，非主键索引也被称为非聚簇索引
innodb支持数据库ACID的特性，在数据更新时会保证数据一致性，上文中死锁的update语句不管怎么执行，数据库都会保证数据的合法性，不会使数据丢失或错误，那么它怎么来实现这点呢？
简单来说，就是对数据加锁，最小粒度就是行级锁。而锁会明显削弱并发性能，为了提高并发性，MySQL实现了MVCC，也就是多版本并发控制，实现读不加锁，读写不冲突，它将读取操作分为两种：快照读，不加锁& 当前读，加锁
快照读就是常规的select语句，读取时不加锁，但有可能读不到最新版本，所以叫快照读。
当前读是读取数据的最新版本，有以下几种情况：
select * from table where ? lock in share mode;
select * from table where ? for update;
insert into table values(…);insert可能会触发unique检查，也算当前读
update table set ? where ?;
delete from table where ?;
增删改本质上有两部分： 先将数据读取出来，再对数据进行修改。前一部分读取操作是当前读，需要获取最新版本的数据。为了防止其他并发的事务对数据进行修改，当前读需要对当前数据加上互斥锁，修改完成后才将锁释放，将数据的修改串行化，保证安全。
原因分析:
出问题 的 这句sql 简化为:
update msgbox_message set record_status = -1 where
record_status = 0
and msg_key = X;
and target_type = Y and target = Z;
update 语句 首先使用了 当前读(就是读取实际的持久化的数据) 查询出要更新的记录
在这个过程 比如先根据索引 target 锁定
然后再找到索引上的 primary key 再次进行锁定。
最后 通过 primary key 更新掉我们的数据。

本次案件中
事物一等待 index target 事物二 等待 primary key
锁产生在当前读，所以需要回到执行计划，查看当前读如何进行。
(由于 Yearning 不支持 像 带 updete 的explan )
所以我们只能通过select 语句 查询到底对于update 的读取是个怎么样的过程

partitions	type	possible_keys	key	key_len	ref	row	filtered	Extra
p1910	index_merge	target_key,msg_key,gmt_create	target_key,msg_key	131,259		1	5	Useing intersect(target_key,msg_key),Useing where
从 执行计划中可以看到，MySQL使用了index merge，
使用两个索引分别读数据，然后将数据进行intersect(取交集)。也就是说当前读发生在了两个索引上，这就是问题的关键!!!
可以看到 执行计划中 将我们target、msg_key进行了merge

因为我们使用的是两个索引，where条件中是复合条件，那么mysql会使用index merge进行优化，优化过程是mysql会先用索引1进行扫表，在用索引2进行扫表，然后求交集形成一个合并索引。这个使用索引扫表的过程和我们本身的sql使用索引的顺序可能存在互斥，所以造成了死锁。

关于索引合并
intersection 只是 索引合并中的一种，还有 union, sort_union 。
可以用到 index_merge 是有比较苛刻的条件。

首先是 Range 优先(>5.6.7)。比如 key1=1 or (key1=2 and key2=3)，其中key1是可以转化成 range scan 的，不会使用 index merge union
其次，Intersect和Union要符合 ROR，即 Rowid-Ordered-Retrival：
解决方法
添加 target + msg_key的组合索引，这样就可以避免掉index merge；
或将 优化器的index merge优化关闭
先select id 然后根据id updete ；
最后的最后 记录一下知识点:
锁的种类&概念
Shared and Exclusive Locks

Shared lock: 共享锁,官方描述：permits the transaction that holds the lock to read a row
eg：select * from xx where a=1 lock in share mode

Exclusive Locks：排他锁：
permits the transaction that holds the lock to update or delete a row
eg: select * from xx where a=1 for update

Intention Locks

这个锁是加在table上的，表示要对下一个层级（记录）进行加锁
Intention shared (IS）：Transaction T intends to set S locks on individual rows in table t
Intention exclusive (IX): Transaction T intends to set X locks on those rows
在数据库层看到的结果是这样的：
TABLE LOCK table `lc_3`.`a` trx id 133588125 lock mode IX
Record Locks

在数据库层看到的结果是这样的：
RECORD LOCKS space id 281 page no 3 n bits 72 index PRIMARY of table 
`lc_3`.`a` trx id 133588125   
lock_mode X locks rec but not gap
该锁是加在索引上的（从上面的index PRIMARY of table lc_3.a 就能看出来）
记录锁可以有两种类型：
lock_mode X locks rec but not gap
lock_mode S locks rec but not gap
Gap Locks

在数据库层看到的结果是这样的：
- RECORD LOCKS space id 281 page no 5 n bits 72 index idx_c of table 
`lc_3`.`a` trx id 133588125   
lock_mode X locks gap before rec
Gap锁是用来防止insert的
Gap锁，中文名间隙锁，锁住的不是记录，而是范围,
比如：(negative infinity, 10），(10, 11）区间，这里都是开区间哦
Next-Key Locks

在数据库层看到的结果是这样的：
RECORD LOCKS space id 281 page no 5 n bits 72 index idx_c of table 
`lc_3`.`a` trx id 133588125   
lock_mode X
Next-Key Locks = Gap Locks + Record Locks 的结合,
不仅仅锁住记录，还会锁住间隙，
比如： (negative infinity, 10】，(10, 11】区间，这些右边都是闭区间哦
Insert Intention Locks

在数据库层看到的结果是这样的：
RECORD LOCKS space id 279 page no 3 n bits 72 index PRIMARY of table lc_3.t1 trx id 133587907   
lock_mode X insert intention waiting
Insert Intention Locks 可以理解为特殊的Gap锁的一种，用以提升并发写入的性能
AUTO-INC Locks

在数据库层看到的结果是这样的：
TABLE LOCK table xx trx id 7498948 lock mode AUTO-INC waiting
属于表级别的锁
自增锁的详细情况可以之前的一篇文章:
http://keithlan.github.io/2017/03/03/auto_increment_lock/
记录锁，间隙锁，Next-key 锁和插入意向锁。这四种锁对应的死锁如下：
记录锁（LOCK_REC_NOT_GAP）: lock_mode X locks rec but not gap
间隙锁（LOCK_GAP）: lock_mode X locks gap before rec
Next-key 锁（LOCK_ORNIDARY）: lock_mode X
插入意向锁（LOCK_INSERT_INTENTION）: lock_mode X locks gap before rec insert intention
参考资料:

https://www.hollischuang.com/archives/3461
https://www.jianshu.com/p/1dc4250c6f6f
https://ruby-china.org/topics/38429(一个 MySQL 死锁案例分析 --Index merge when update)
https://yq.aliyun.com/articles/8963/
https://www.aneasystone.com/archives/2018/04/solving-dead-locks-four.html
http://seanlook.com/2017/03/11/mysql-index_merge-deadlock/
http://www.ishenping.com/ArtInfo/133925.html (Innodb死锁日志分段解读-如何阅读死锁日志)
https://segmentfault.com/a/1190000018730103 (了解MySQL死锁日志)
https://www.itread01.com/content/1546402384.html
https://www.jianshu.com/p/e4f87d301415
http://loesspie.com/2019/06/12/mysql-using-intersect-deadlock/
《深入浅出Mysql》 第二版

