ͨ������pfile.ora�ļ���Ȼ�����ļ���ɾ����������"MEMORY_TARGET/MEMORY_MAX_TARGET"��
Ȼ���ٴ���spfile�Ϳ�����.

һ����˵����Ҫָ��PGA��SGA��С

ͨ���޸�pfile�ļ���
sga_target = 
pga_aggregate_target = 

Note: byte

ͨ�������޸ģ�  
alter system set sga_target = 4096m scope=both;
alter system set pga_aggregate_target = 3072m scope=both;