1�����ұ���������������������������ͣ������У���  
select t.*,i.index_type from user_ind_columns t,user_indexes i where t.index_name = i.index_name and t.table_name = i.table_name and t.table_name = ����

2�����ұ���������������ƣ������У���  
select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = ��P�� and au.table_name = ����

3�����ұ��Ψһ��Լ�����������ƣ������У���  
select column_name from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = ��U�� and au.table_name = ����

4�����ұ��������������ƣ����ñ�ı����Ͷ�Ӧ�ļ����������Ƿֳɶಽ��ѯ����  
select * from user_constraints c where c.constraint_type = ��R�� and c.table_name = ����