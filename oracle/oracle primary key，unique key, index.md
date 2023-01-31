1、查找表的所有索引（包括索引名，类型，构成列）：  
select t.*,i.index_type from user_ind_columns t,user_indexes i where t.index_name = i.index_name and t.table_name = i.table_name and t.table_name = 表名

2、查找表的主键（包括名称，构成列）：  
select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = ‘P’ and au.table_name = 表名

3、查找表的唯一性约束（包括名称，构成列）：  
select column_name from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = ‘U’ and au.table_name = 表名

4、查找表的外键（包括名称，引用表的表名和对应的键名，下面是分成多步查询）：  
select * from user_constraints c where c.constraint_type = ‘R’ and c.table_name = 表名