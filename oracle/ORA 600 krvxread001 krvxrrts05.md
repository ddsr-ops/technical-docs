ENV: ORACLE 11.2.0.4.0 DEBEZIUM Oracle Plugin 1.8
`alter system switch logfile;`, `alter system checkpoint`, 数据库的重启都不会出发CDC关于logmnr的BUG。
但是调整了数据库的内存参数，如`memory_target, memory_max_target, sga_target, pga_aggregate_target`, 则会触发BUG。
已遇见的BUG列表：
* 13507159 logminer raises ORA-600 [krvxread001]
* 14458322 ORA-600 [krvxrrts05] from LogMiner during SQL apply in RAC 
通过测试可知，可以通过手动add_logfile问题日志和dict_from_online_catalog+continuous暂时屏蔽上述问题，
至于continuous选项推荐继续使用，以避免丢失数据。