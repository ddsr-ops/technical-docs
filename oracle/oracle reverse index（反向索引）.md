♣

题目部分

在Oracle中，反向键索引（Reverse Key Indexes）是什么？

♣

答案部分

反向键索引也称为反转索引，是一种B-Tree索引，它在物理上反转每个索引键的字节，但保持列顺序不变。例如，如果索引键是20，并且在一个标准的B-Tree索引中此键被存为十六进制的两个字节C1，15，那么反向键索引会将其存为15，C1。

```
SYS@orclasm > SELECT DUMP(20,'16') FROM DUAL;
DUMP(20,'16')
------------------
Typ=2 Len=2: c1,15
```

反向键索引解决了在B-Tree索引右侧的的叶块争用问题。在Oracle RAC数据库中的多个实例重复不断地修改同一数据块时，这个问题尤为严重。在一个反向键索引中，对字节顺序反转，会将插入分散到索引中的所有叶块。例如键20和21，本来在一个标准键索引中会相邻，现在存储在相隔很远的独立的块中。这样，顺序插入产生的I/O被更均匀地分布了。

使用反向键索引的最大的优点莫过于降低索引叶子块的争用，减少热点块，提高系统性能。由于反向键索引自身的特点，如果系统中经常使用范围扫描进行读取数据的话（例如在WHERE子句中使用“BETWEEN AND”语句或比较运算符“>”、“<”、“>=”、“<=”等），那么反向键索引将不会被使用，因为此时会选择全表扫描，反而会降低系统的性能。只有对反向键索引列进行“=”操作时，其反向键索引才会使用。

反向键索引应用场合：

①　在索引叶块成为热点块时使用

通常，使用数据时（常见于批量插入操作）都比较集中在一个连续的数据范围内，那么在使用正常的索引时就很容易发生索引叶子块过热的现象，严重时将会导致系统性能下降。

②　在RAC环境中使用

当RAC环境中几个节点访问数据的特点是集中和密集，索引热点块发生的几率就会很高。如果系统对范围检索要求不是很高的情况下可以考虑使用反向键索引技术来提高系统的性能。因此该技术多见于RAC环境，它可以显著的降低索引块的争用。

③　反向键索引通常建立在值是连续增长的列上，使数据均匀地分布在整个索引上。

使用如下的SQL语句可以查询到所有的反向键索引：

```
SELECT * FROM DBA_INDEXES D WHERE D.INDEX_TYPE LIKE '%/REV';


--创建索引时使用REVERSE关键字，如下所示：
CREATE INDEX REV_INDEX_LHR ON XT_REVI_LHR(OBJECT_ID) REVERSE;
ALTER INDEX REV_INDEX REBUID NOREVERSE;
ALTER INDEX NAME_INX REBUILD ONLINE NOREVERSE;
ALTER INDEX ID_INX REBUILD REVERSE ONLINE;
ALTER INDEX ID_INX REBUILD ONLINE REVERSE;
```