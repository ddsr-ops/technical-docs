# Mysql5.6版本之前

更新步骤

对原始表加写锁

按照原始表和执行语句的定义，重新定义一个空的临时表。

对临时表进行添加索引（如果有）。

再将原始表中的数据逐条Copy到临时表中。

当原始表中的所有记录都被Copy临时表后，将原始表进行删除。再将临时表命名为原始表表名。
这样的话整个DDL过程的就是全程锁表的。


# Mysql5.6版本之后

更新步骤

对原始表加写锁

按照原始表和执行语句的定义，重新定义一个空的临时表。并申请rowlog的空间。

拷贝原表数据到临时表，此时的表数据修改操作（增删改）都会存放在rowlog中。此时该表客户端可以进行操作的。

原始表数据全部拷贝完成后，会将rowlog中的改动全部同步到临时表，这个过程客户端是不能操作的。

当原始表中的所有记录都被Copy临时表，并且Copy期间客户端的所有增删改操作都同步到临时表。再将临时表命名为原始表表名。

# 总结

ALTER TABLE 加字段会加锁。只是Mysql5.6版本之后新增了ONLINE DDL的功能，可以使该表不能使用的时间大大缩短。
注意
ALTER TABLE 加字段的时候。如果该表的数据量非常大。不要设置default值。
比如，当前有2000万以上数据量的表。如果加字段加了default值。Mysql会执行在执行Online DDL之后，对整个表的数据进行更新默认值的操作，即
UPDATE `table_name` SET new_col = [默认值] WHERE TRUE


这样就相当于是更新了2000w+的数据，而且是在同一个事务里。也就是说这个事务会把整个表都锁住，直到所有的数据记录都更新完默认值以后，才会提交。
这个时间非常长，而且由于会锁全表的记录，所以该表不可用的时间会非常长。


笔者实验过16核，32G，Mysql默认配置。500w的数据量加一个字段。
不加default值，整个DDL更新过程是66秒。而且整个更新过程，该表的查询、修改、新增操作都是可用的。几乎对该表的可用性没有任何影响。
加default值，整个DDL更新过程是213秒。经过测试，大约在100秒之后，该表的查询、修改、新增操作都会陷入等待状态。