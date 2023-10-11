As for drop / truncate operation in MySQL, Percona and MySQL community have spent much cost on delving and improving it for their separate products.

In MySQL 5.7 or 8.0+, drop / truncate operations behave differently as their implements were improved. https://www.showapi.com/book/view/2096/95

Drop or truncate operations must affect the performance of MySQL servers, the greater the table is, the greater influences.
[Drop Table对MySQL的性能影响分析](https://www.cnblogs.com/CtripDBA/p/11465315.html)

Some enhancements are completed in MySQL 8.0, [WL#14100: InnoDB: Faster truncate/drop table space](https://dev.mysql.com/worklog/task/?id=14100)

Another post is related to Faster truncate and drop, [[WorkLog] InnoDB Faster truncate/drop table space](https://juejin.cn/post/6952908144364224525)

truncate语法在大buffer pool下面的优化, https://cloud.tencent.com/developer/article/1700905

源码分析truncate为什么慢，针对MySQL8,5分别说明，[故障分析 | TRUNCATE 到底因何而慢？](https://opensource.actionsky.com/%E6%95%85%E9%9A%9C%E5%88%86%E6%9E%90-truncate-%E5%88%B0%E5%BA%95%E5%9B%A0%E4%BD%95%E8%80%8C%E6%85%A2%EF%BC%9F/)
