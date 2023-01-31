-- 创建本地分区索引  
create index sales_idx1 on sales_par (product,year) local;   
-- 创建全局分区索引  
create index hgidx on tab (c1,c2)
global partition by hash (c1,c2) partitions 64;