MySQL Connector������Ԫ���ݽ���ʱ�� ������Ķ�Ӧconnect��offsetλ�ã� ���ܵ����޷�ʶ����schema��
����'Encountered change event for table XXX whose schema isn't known to this connector'
 
ʹ��MySQL Connector��ȡָ����־ָ���������־�� ʵ���н�previousOffset��Ϊ�գ�����Ϊ�˱��ⱨ��������
������Բο�MySqlConnectorTask���io.debezium.connector.mysql.MySqlConnectorTask#start������

���MySQL CDCȷʵ�������жϣ� ��Ϊ���������Դ���ݿ�ɻָ��Ͳ��ɻָ��� ����������������ӱ��Ϸ�������ԵĽǶȣ� ����������л������⡣
��ʱ�� �����ַ�ʽֵ�ó��Իָ�CDC��·��
1. ���ڱ��⣨�������� �½�һ��CDC��·��Connector���Ʋ�ͬ�� schema_onlyģʽ��ͨ��CDC transform����ת�����ݵ�ԭ��kafka topic��
   ȷ��ȱʧ��־���䣬����CDC��·����ȡȱʧ��־��ͨ��CDC transform���ܣ� ��ȱʧ��־����ԭ��kafka topic��
   ȱ�㣺���û�����ݰ汾�������ݹ��̲�һ�£�����һ�£����ø��ӣ��ŵ㣺ʱЧ���б�֤
2. ���ڱ��⣨�������� �½�һ��CDC��·��Connector���Ʋ�ͬ�� initialģʽ��ͨ��CDC transform����ת�����ݵ�ԭ��kafka topic
   ȱ�㣺ʱЧ���޷���֤��ȡ���ڿ������������ŵ㣺����һ���Ե��Ա�֤�����ü�