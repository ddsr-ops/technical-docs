通过创建pfile.ora文件，然后在文件里删除两个参数"MEMORY_TARGET/MEMORY_MAX_TARGET"。
然后再创建spfile就可以了.

一般来说，需要指定PGA和SGA大小

通过修改pfile文件，
sga_target = 
pga_aggregate_target = 

Note: byte

通过命令修改：  
alter system set sga_target = 4096m scope=both;
alter system set pga_aggregate_target = 3072m scope=both;