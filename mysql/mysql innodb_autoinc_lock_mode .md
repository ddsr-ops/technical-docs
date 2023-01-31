背景
先描述下故障吧

step0: 环境介绍

1. MySQL5.6.27
2. InnoDB
3. Centos
基本介绍完毕，应该跟大部分公司的实例一样
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
   
step1: 业务需要导入历史数据到新表，新表有写入
1. insert into new_table(x) select xx from old_table
2. 批量插入在new_table上

step2: 结果 
show processlist;
看到好多语句都处于executing阶段，DB假死，任何语句都非常慢，too many connection

step3: 查看innoDB状况
show engine innodb status\G
结果：
==lock==
---TRANSACTION 7509250, ACTIVE 0 sec setting auto-inc lock  --一堆
TABLE LOCK table `xx`.`y'y` trx id 7498948 lock mode AUTO-INC waiting  --一堆
模拟问题，场景复现
让问题再次发生才好定位解决问题

表结构
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
session1：insert into t_inc(x) select cookie_unique from t_inc_template;
session2：mysqlslap -hxx -ulc_rx -plc_rx -P3306  --concurrency=10 --iterations=1000 --create-schema='lc'  --query="insert into t_inc(x) select 'lanchun';" --number-of-queries=10
产生并发,然其自动分配自增id。

step2：观察
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
一堆这样的waiting
然后卡死
好了问题已经复现，大概也知道是什么原因造成了，那就是：AUTO-INC lock

自增锁
接下来聊聊自增锁

和auto_increment相关的insert种类
INSERT-like
解释：任何会产生新记录的语句，都叫上INSERT-like，比如：
 INSERT, INSERT ... SELECT, REPLACE, REPLACE ... SELECT, and LOAD DATA
 
 
总之包括：“simple-inserts”, “bulk-inserts”, and “mixed-mode” inserts.

simple insert
插入的记录行数是确定的：比如：insert into values，replace
但是不包括： INSERT ... ON DUPLICATE KEY UPDATE.

Bulk inserts
插入的记录行数不能马上确定的，比如： INSERT ... SELECT, REPLACE ... SELECT, and LOAD DATA
Mixed-mode inserts
这些都是simple-insert，但是部分auto increment值给定或者不给定
1. INSERT INTO t1 (c1,c2) VALUES (1,'a'), (NULL,'b'), (5,'c'), (NULL,'d');
2. INSERT ... ON DUPLICATE KEY UPDATE
以上都是Mixed-mode inserts
   
锁模式
innodb_autoinc_lock_mode = 0 (“traditional” lock mode)

优点：极其安全
缺点：对于这种模式，写入性能最差，因为任何一种insert-like语句，都会产生一个table-level AUTO-INC lock
innodb_autoinc_lock_mode = 1 (“consecutive” lock mode)

原理：这是默认锁模式，当发生bulk inserts的时候，会产生一个特殊的AUTO-INC table-level lock直到语句结束，注意：（这里是语句结束就释放锁，并不是事务结束哦，因为一个事务可能包含很多语句）
对于Simple inserts，则使用的是一种轻量级锁，只要获取了相应的auto increment就释放锁，并不会等到语句结束。
PS：当发生AUTO-INC table-level lock的时候，这种轻量级的锁也不会加锁成功，会等待。。。。
优点：非常安全，性能与innodb_autoinc_lock_mode = 0相比要好很多。
缺点：还是会产生表级别的自增锁
深入思考： 为什么这个模式要产生表级别的锁呢？
因为：他要保证bulk insert自增id的连续性，防止在bulk insert的时候，被其他的insert语句抢走auto increment值。
innodb_autoinc_lock_mode = 2 (“interleaved” lock mode)

原理：当进行bulk insert的时候，不会产生table级别的自增锁，因为它是允许其他insert插入的。
来一个记录，插入分配一个auto 值，不会预分配。
优点：性能非常好，提高并发，SBR不安全
缺点：
    一条bulk insert，得到的自增id可能不连续
    SBR模式下：会导致复制出错，不一致
延伸
当innodb_autoinc_lock_mode = 2 ，SBR为什么不安全
master 插入逻辑和结果
表结构：a primary key auto_increment,b varchar(3)
```
time_logic_clock	session1：bulk insert（）	session2： insert like
0	                       1,A		
1		                                                        2,AA
2	                       3,B		
3	                       4,C		
4		                                                        5,CC
5	                       6,D	
```
最终的结果是：
```
a	b
1	A
2	AA
3	B
4	C
5	CC
6	D
```
slave的最终结果
因为binlog中session2的语句先执行完，导致结果为
```
a	b
1	AA
2	CC
3	A
4	B
5	C
6	D
```
RBR为什么就安全呢？
因为RBR都是根据row image来的，跟语句没关系的。

好了，通过以上对比分析，相信大家都知道该如何抉择了吧？

innodb_autoinc_lock_mode = 2 的一个小问题
由于innodb_autoinc_lock_mode = 2是语句级别的锁，那么就有可能造成 后面的id先提交，前面的id后提交

举个例子：
```
session A:
    begin;
    insert into xx values() ;   --这时候的自增id 是100
session B:
    begin
    insert into xx values() ;   --这时候的自增id 是101
session B:
    commit;  --意味着id=101的记录先插入到数据库
session A:
    commit;  --意味着id=100的记录后插入到数据库
```
最后，对于数据库来说，没有大问题，因为数据都插入进来了，只是后面的id先插入进来而已。

但是有的业务就有问题：比如，某些业务根据自增id进行遍历

```
select * from xx where id>1 limit N
select * from xx where id>1+N limit N
select * from xx where id>1+N+N limit N
```
如果id是顺序插入的，就没问题。 如果后面的id先插入进来（比如id=101），那么id=100还没提交的id就被程序忽略掉了，由此对业务来说就丢了id=100 这条记录

解决方法：where id>N and add_date< (NOW() - INTERVAL 5 second) 取前5s的数据，降低并发写入带来的困扰

总结
如果你的binlog-format是row模式，而且不关心一条bulk-insert的auto值连续（一般不用关心），那么设置innodb_autoinc_lock_mode = 2 可以提高更好的写入性能。