ENV: ORACLE 11.2.0.4.0 DEBEZIUM Oracle Plugin 1.8
`alter system switch logfile;`, `alter system checkpoint`, ���ݿ���������������CDC����logmnr��BUG��
���ǵ��������ݿ���ڴ��������`memory_target, memory_max_target, sga_target, pga_aggregate_target`, ��ᴥ��BUG��
��������BUG�б�
* 13507159 logminer raises ORA-600 [krvxread001]
* 14458322 ORA-600 [krvxrrts05] from LogMiner during SQL apply in RAC 
ͨ�����Կ�֪������ͨ���ֶ�add_logfile������־��dict_from_online_catalog+continuous��ʱ�����������⣬
����continuousѡ���Ƽ�����ʹ�ã��Ա��ⶪʧ���ݡ�