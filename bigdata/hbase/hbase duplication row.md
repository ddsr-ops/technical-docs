【原创】HBase中同一条记录重复写入数据库的情况
如果打算向HBase集群数据库中循环存入10000次同一条记录，有两种修改方法：

设置不同的rowkey和设置可存储版本数为10000。

（1）不同的rowkey设置方法是在现有的时间、监测点、车牌号的基础上追加随机数以完成同一条记录的存储。

（2）设置可存储版本数为10000时，可以将时间戳设置为数据记录插入时的时间。这样就可以插入10000个时间戳不同的版本。

[但是经测试：记录一样时，只要行键是唯一就可以写入数据库，如果行键不唯一即使根据时间戳属性将版本设置为10000也是写不进去的，并且系统还会崩掉]