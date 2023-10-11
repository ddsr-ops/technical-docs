# 一、背景

DBA在做大表truncate/drop时偶尔会导致数据库夯住，尤其是核心业务系统，一旦夯住，立马就是一次故障，这是为什么呢？有什么办法避免呢？

# 二、原因

大表truncate/drop时，操作线程会若干次持有buffer pool mutex和flush list mutex，导致其他线程被阻塞。

影响大表truncate/drop的时间及范围主要是以下几个原因（大buffer pool + innodb_adaptive_hash_index）：

1、操作表在buffer pool中脏页数量

2、整个buffer pool脏页数量(非操作表)

3、操作表ibd文件大小

# 三、避免方式

针对以上原因，线上执行truncate/drop必须遵守以下原则：

（推荐）1、线上热表建议先rename为 backup_ 表，同时创建一张新表，过一周后再操作 backup_ 表，可以尽量消除该表的脏页带来的影响（建议改用分区表，一般热数据都是最近的分区，操作存冷数据的分区，影响会小）。

2、必须在该表的业务低峰期操作，可以尽量降低该表在buffer pool中的脏页带来的影响。

3、尽量在业务系统的低峰期操作，可以尽量降低整个库buffer pool中脏页带来的影响

4、尽量小表，buffer pool越小，脏页越少，性能越平稳，持锁时间越短，变更的影响越小。

5、在5.7版本用drop+create代替truncate（见官方文档truncate table Statement一节）。

注：大buffer pool 和 innodb_adaptive_hash_index=on时：TRUNCATE TABLE操作InnoDB表的自适应哈希索引条目是一个bug(drop table操作已经解决该bug)，(Bug #68184)

On a system with a large InnoDB buffer pool and innodb_adaptive_hash_index enabled,
TRUNCATE TABLE operations may cause a temporary drop in system performance due to an LRU
scan that occurs when removing an InnoDB table's adaptive hash index entries. The problem was
addressed for DROP TABLE in MySQL 5.5.23 (Bug #13704145, Bug #64284) but remains a known
issue for TRUNCATE TABLE (Bug #68184).

# 四、替换方式（没在生产环境验证过）

以下是采用硬链接的一种方式消除大表删除时突发性IO带来的影响（实际生产环境用处不大）：

1、表文件过大，直接删除会瞬时占用大量IO，造成IO阻塞，使用硬链接方式优化。

2、删除系统层真正的大文件，使用seq和truncate命令减轻直接rm 删除造成的IO瞬时高峰。

3、如果slave上不提供读，则下面的步骤只在master上操作。

```
shell# cd /opt/mysql3306/data/test && ll -th test*
-rw-r----- 1 mysql mysql 107G Mar 16 16:37 test.ibd
-rw-r----- 1 mysql mysql 8.5K Oct 16 21:59 test.frm
shell# ln test.ibd test.ibd.hdlk
shell# ll -th test*
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd.hdlk
-rw-r----- 1 mysql mysql 8.5K Oct 16 21:59 test.frm
mysql> drop table test;
shell# ll -th test*
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd.hdlk
shell# for i in `seq 107 -1 1`;do sleep 2;truncate -s ${i}G /opt/mysql3306/data/test/test.ibd.hdlk;done
```

注意：虽然这些方式能降低大表truncate和drop对业务的影响，但是强烈建议MySQL的表不要过大，如果生产表数据保留过久，大表肯定无法避免，那个时候再清理或转储，就是一件比较繁琐的事情，建议从数据架构层规划好表的生命保留周期，才是治本的方法。