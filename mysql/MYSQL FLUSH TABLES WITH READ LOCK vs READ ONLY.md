# Difference between flush tables with read lock and read only

## Flush tables with read lock 

关闭所有表并且给所有数据库里的表加上全局读锁。这是一种非常方便地备份时保证数据文件一致性方法。使用UNLOCK TABLES可以释放锁。

FLUSH TABLES WITH READ LOCK获取的是全局读锁而非表锁，因此它和LOCK TABLES获取表锁不一样，并且UNLOCK TABLES会隐式提交。

当任何表被LOCK TABLES语句锁住时，UNLOCK TABLES会隐式提交。但FLUSH TABLES WITH READ LOCK后再执行UNLOCK TABLES不会隐式提交,因为后者不会获取表锁。
新事务的开始(BEGIN;)会让LOCK TABLES操作产生的锁释放，即便还没执行UNLOCK TABLES.开始事务不会释放FLUSH TABLES WITH READ LOCK产生的全局读锁

在5.1.19之前，FLUSH TABLES WITH READ LOCK和分布式事务时不兼容的

FLUSH TABLES WITH READ LOCK不会影响慢查询日志和和通用查询日志表的写入

**该操作仅阻塞其他会话的更新操作，但是发起flush操作的会话一旦以unlock tables命令或这退出当前会话，全局读锁被释放，其他更新操作将继续执行DML**

所以使用flush操作去切库动作是有问题的，flush tables with read lock主要用途是非innodb引擎的数据库备份，[参考链接](https://www.percona.com/doc/percona-xtrabackup/LATEST/xtrabackup_bin/flush-tables-with-read-lock.html)

<u>Flush tables with read lock会被复制至slave节点，flush local tables with read lock不会复制到slave节点</u>

## read_only 
`set global read_only = 1`, 这是全局表锁，如果其他会话想更新数据，则直接报错，并**不会阻塞**。从库设置read_only, 并不影响sql thread运行，同时带有super权限的用户仍然可以更新数据。


## Difference
从上可看出，两者主要区别
* 阻塞， 前者阻塞其他会话的DML执行；后者不阻塞，其他会话若更新数据， 则直接报错
* 解锁， 前者使用unlock tables主动解锁或退出发起flush命令的会话被动解锁， 解锁后被阻塞的会话继续执行， 后者退出发起命令的会话无法解锁， 只能使用`set global read_only = 0`解锁

另外，上述两个命令，没有冲突关系，可在同一个会话中先后执行。


如果想锁表，且让表不可读，这里的不可读是阻塞。使用lock命令可解决`lock tables tab_a write, tab_b write, ...`, 会阻塞其他会话读取被锁的表，使用`unlock tables`或退出当前会话可解锁。
被锁的表都需写在一行代码里。

使用场景：
当我们进行物理分库时，当应用完全停止后，使用`set global read_only = 1`让主库只读， 完成拆库后，关闭只读。使用`lock tables ....`锁定被拆出去的表，防止应用误读误写，打开vip服务，启动应用。
观察应用日志，查看是否存在误读误写被拆出去的表，有则及时修改应用配置。无问题后，使用unlock tables释放锁。 

