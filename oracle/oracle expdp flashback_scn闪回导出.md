在使用10g后的Oracle data pump导出数据时，我们可以使用flashback_scn参数指定导出的时间点，这时

oracle会使用flashback query查询导出scn时的数据，flashback query使用undo，无需打开flashback database功能。

也就是说，只要undo信息不被覆盖，即使数据库被重启，仍然可以进行基于flashback_scn的导出动作。


expdp scott/tiger directory=DATA_PUMP_DIR dumpfile=t1.dmp tables=t flashback_scn=21870773