ͨ������£� ��ҵ����У�ʹ��DML��DDL���Թ�������ɾ�����ƶ����鵵�⣬�ﵽ����ҵ������ݴ洢������
ά�����ݿ�ƽ�ȵķ���������

���ǣ���ҵ������delete������ͬʱ�鵵��������delete��䣬�����cdc���������Ѻ�׼ȷ�����delete���
��˭�������Ӱ��������ҵ��δ����ⲿ�����ݡ�

todo: how to handle rows which are archived
When finished archiving data, someone or program delete some rows which locate in the archived data. 
They want to remove the rows solidly, but the rows have already been archived and saved, which may influence
the quality of model relevant to the rows.

���cdc�����й��˹鵵������event�߼����ü�������ҵ�ӹ���
todo��scripts to handle rows that op is 'd' in the layer sdm bwt , then tftactdb
solution: build a cdc streaming road on the archive databases, then ingest data into iceberg or starrocks.
Keep the data(from archive databases) for a certain long time, such as 2 days,  data from production databases join the relevant data
from archive database to remove the data has been archived.

��ǰ��ȡ�Ĵ�ʩ��  
�͹鵵�����������ֲü�������ҵ����������������������ۣ��Ա���Ϊ���ݷ��ദ��ɾ�����ݡ����鵵����˵���������Ϊɾ�������ݣ�
�������δ����ⲿ�����ݣ��ǹ鵵�����˲�������Ϊɾ�������ݣ������δ����ⲿ�����ݣ����α�����������ɾ����ϲ�