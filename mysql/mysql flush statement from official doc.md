语法：
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

flush语句会触发隐式提交

部分flush语句可以由mysqladmin工具执行，例如flush-hosts,flush-logs,flush-privileges,flush-status,以及flush-tables等等。

### LOCAL
LOCAL：主从复制环境下flash语句默认会同步到Slave节点，flush logs，flush binary logs,flush tables(or table_list) read lock,以及flush tables table_list for export除外，因为这些语句同步到slave节点会出问题。
。Local(或NO_WRITE_TO_BINLOG)表示不写入Binlog，即不会同步到slave节点。

向服务器发送SIGNUP指令会触发某些flush操作。

reset语句类似于flush。

###FLUSH BINARY LOGS

关闭并且重新打开正在写的binlog。在binlog开启的情况下，这个命令会让binlog文件增加一个

###FLUSH DES KEY FILE

从--des-key-file选项指定的文件中重新加载DES键

注意：
DES_ENCRYPT()和DES_DECRYPT()函数在5.7.6降级了，会在将来的版本中移除。--des-key-file选项和des_key_file系统参数也会移除

###FLUSH ENGINE LOGS

关闭并重新打开所有已安装的存储引擎的“可刷新”的日志。这会让innodb把日志刷入磁盘

###FLUSH ERROR LOGS

关闭并重新打开服务器正在写的错误日志

###FLUSH GENERAL LOGS

关闭并重新打开服务器正在写的通用日志

###FLUSH HOST

清空host缓存以及Performance Schme中的host_cache表。
当出现主机IP地址改变或出现 host ‘host_name’ is blocked报错时需要Flush host 缓存。
当某个host IP连接时出现了more than max_connect_errors errors报错，则后续连接会一直认为这台服务器有问题并且阻止后续连接，而flush host可以让该IP地址再次尝试连接。

###FLUSH LOGS

关闭并重新打开服务器写的所有日志文件。如果binlog开启，会增加一个binlog文件。
如果relay logging开启了，会增加一个relay log文件。

但对慢查询日志和通用查询日志没有影响

###FLUSH OPTIMIZER COST
重新读取成本模型表，使得优化器使用当前最新的成本评估统计。只对Flush操作后建立的会话有影响

###FLUSH PRIVILEGES

重新读取MYSQL系统数据库中的授权相关的表。

GRANT、CREATE USER，CREATE SERVER和INSTALL PLUGIN等语句会在服务器中缓存信息。
但这些缓存不会随着REVOKE，DROP USER，DROP SERVER以及UNINSTALL PLUGIN语句的执行而消失。
FLUSH PRIVILEGES语句可以释放这些缓存

###FLUSH QUERY CACHE

整理查询缓存的碎片以更好地利用内存。FLUSH QUERY CACHE不会清除任何查询缓存，
不像FLUSH TABLES或RESET QUERY CACHE那样（会清除缓存）。

注意：
查询缓存在5.7.20被降级，在Mysql8.0被移除。

###FLUSH RELAY LOGS[FOR CHANNEL channel]

关闭并重新打开服务器正在写的relay log 文件。如果relay log开启，会增加一个relay log文件。

FOR CHANNEL *channel*子句用于指定特定复制（replication）通道。
可以不指定通道，语句会作用于默认通道。也可以指定多个通道，语句会作用于指定的所有通道

###FLUSH SLOW LOGS

关闭并且重新打开服务器正在写的慢查询日志。

###FLUSH STATUS

注意：
show_compatibility_56系统变量的值会影响这个选项的操作。详情参考系统变量手册

这个选项会把当前线程的会话状态变量值设置位全局值，同时把会话值设为0.某些全局变量也会被设置为0.
也会把key caches的计数器重置为0并且把max_used_connections状态变量设置为当前打开的连接数量.
这些信息在对查询进行debugging时会使用到。

###FLUSH USER RESOURCES

将所有per-hour用户资源重置为0.这会让所有达到资源（per-hour连接，查询，更新等）上限的客户端立刻恢复活动。

***
FLASH TABLES 语法

FLUSH TABLES=FLUSH TABLE，flush表的同时具有多种获取锁的模式，并且每次只能使用一个选项。

注意：
这里描述

FLUSH TABLES

关闭所有打开的表，强制让所有的表关闭，然后清空查询缓存和就绪的语句缓存。FLUSH TABLES也会将所有查询缓存中的查询结果清除，就像RESET QUERY CACHE一样。

LOCK TABLE ... READ的同时不能FLUSH TABLES。想要在flush的同时锁表，使用FLUSH TABLES tbl_name ... with READ LOCK.

###FLUSH TABLES tbl_name [,tbl_name] ...

只flush指定的一张或多张表，表名之间逗号隔开。若表名不存在，也不会报错

###FLUSH TABLES WITH READ LOCK

关闭所有表并且给所有数据库里的表加上全局读锁。这是一种非常方便地备份时保证数据文件一致性方法。使用UNLOCK TABLES可以释放锁。

FLUSH TABLES WITH READ LOCK获取的是全局读锁而非表锁，因此它和LOCK TABLES获取表锁不一样，并且UNLOCK TABLES会隐式提交。

当任何表被LOCK TABLES语句锁住时，UNLOCK TABLES会隐式提交。但FLUSH TABLES WITH READ LOCK后再执行UNLOCK TABLES不会隐式提交,因为后者不会获取表锁。
新事务的开始(BEGIN;)会让LOCK TABLES操作产生的锁释放，即便还没执行UNLOCK TABLES.开始事务不会释放FLUSH TABLES WITH READ LOCK产生的全局读锁
在5.1.19之前，FLUSH TABLES WITH READ LOCK和分布式事务时不兼容的

FLUSH TABLES WITH READ LOCK不会影响慢查询日志和和通用查询日志表的写入

FLUSH TABLES tbl_name [, tbl_name] ... WITH READ LOCK

Flush某些表并获取读锁。首先是获取表的元数据独占锁，所以会等待表上的事务完成。然后语句会Flush表的缓存，重新打开表，获取表锁，然后将元数据独占锁降级为共享锁。获取到锁以及降级元数据锁之后，其他会话可以读取，但无法修改表。

由于这条语句获取了表锁，因此必须拥有对每张表的LOCK TABLES权限，另外，Flush表需要RELOAD权限。

这条语句值只能应用于存在的基表（非临时表）。如果是临时表，会被忽略。如果是视图，会报错：ER_WRONG_OBJECT。

使用UNLOCK TABLES可以释放锁，LOCK TABLES释放锁并且获取其他锁，或者START TRANSACTION来释放锁并开始新的事务。

如果一张被Flushed的表被一个HANDLER打开，这个handler会隐式地被flushed并且丢失位置

###FLUSH TABLES tbl_name [, tbl_name] ... FOR EXPORT

这种FLUSH TABLES变体适用于innnodb表。确保表上的变化刷新到磁盘，使表二进制文件可以在服务器运行的情况下拷贝。

语句的工作原理：

获取表的共享元数据锁。只要其他会话在修改这些表或者持有锁，语句就会被阻塞。一旦获取了锁，尝试更新表的语句也会被阻塞，只允许只读操作继续执行。
检查是表的存储引擎是否支持导出。如果有不支持的，会出现ER_ILLEGAL_HA报错，并且语句执行失败。
语句会通知存储引擎为每张表做好导出的准备。存储引擎必须确保所有的脏数据写入磁盘。
语句把会话至于锁表模式，以使在FOR EXPORT语句完成时前面获得的元数据锁不被释放
FLUSH TABLES ... FOR EXPORT语句需要拥有对表的select权限。因为这条语句会获取表锁，因此也必须拥有LOCK TABLES权限，另外flush操作还需要reload权限。

语句只能应用于非临时表。如果含有临时表，会被忽略。如果含有视图，会出现ER WRONG OBJECT报错。其他情况，会出现ER NO SUCH TABLE报错。

innodb支持拥有自己的.ibd文件的表的FOR EXPORT（即，使用innodb_file_per_table参数启用时创建的表）。innodb会保证在FOR EXPORT语句发出通知时表所有的变化都刷新到磁盘。当FOR EXPORT语句生效时，二进制表数据文件就可以拷贝了，因为此时在服务器运行时.ibd文件上的事务处于一致性状态。FOR EXPORT不会应用于innodb系统表空间文件或者具有FULLTEXT索引的innodb表。

FLUSH TABLES ... FOR EXPORT支持innodb分区表

当FOR EXPORT下达通知后，Innodb会将内存中或表空间文件外独立的磁盘缓存中的某种类型的数据写入磁盘。对每张表，innodb还会生成一个table_name.cfg文件放在数据库目录里。这个.cfg文件包含的信息是以后再次导入表空间文件所需要的元数据，可以导入原服务器或另外的服务器。

当FOR EXPORT语句完成，Innodb会把所有的脏页刷新到表的数据文件。所有变更缓存记录在刷新之前会先合并。此时，表被锁住，是静态的：表处于事务一致状态，然后就可以拷贝.bd表空间文件以及对应的.cfg文件来获取这些表的一致性快照。

完成表的导出之后，使用UNLOCK TABLES就能释放锁，或使用LOCK TABLES也可以释放锁并获得另一种锁，或使用start transaction来释放锁并开始新的事务。

当会话内的以下任何语句正在使用时，执行FLUSH TABLES ... FOR EXPORT会报错：

FLUSH TABLES ... WITH READ LOCK
FLUSH TABLES ... FOR EXPORT
LOCK TABLES ... READ
LOCK TABLES ... WRITE
当会话内FLUSH TABLES ... FOR EXPORT生效时，使用以下这些语句也会报错：


FLUSH TABLES WITH READ LOCK
FLUSH TABLES ... WITH READ LOCK
FLUSH TABLES ... FOR EXPORT
