�Ż�1������ÿ��channel���ٶ�

��DataX�ڲ���ÿ��Channel�����ϸ���ٶȿ��ƣ������֣�һ���ǿ���ÿ��ͬ���ļ�¼��������һ����ÿ��ͬ�����ֽ�����Ĭ�ϵ��ٶ�������1MB/s�����Ը��ݾ���Ӳ������������byte�ٶȻ���record�ٶȣ�һ������byte�ٶȣ����磺���ǿ��԰ѵ���Channel���ٶ���������Ϊ5MB

�Ż�2������DataX Job��Channel������ ������=taskGroup������ÿһ��TaskGroup����ִ�е�Task�� (Ĭ�ϵ���������Ĳ�������Ϊ5)��

����job��Channel�������������÷�ʽ��

����ȫ��Byte�����Լ���Channel Byte���٣�Channel���� = ȫ��Byte���� / ��Channel Byte����
����ȫ��Record�����Լ���Channel Record���٣�Channel���� = ȫ��Record���� / ��Channel Record����
ֱ������Channel����.

���ú��壺

job.setting.speed.channel : channel������
job.setting.speed.record : ȫ������channel��record����
job.setting.speed.byte��ȫ������channel��byte����

core.transport.channel.speed.record����channel��record����
core.transport.channel.speed.byte����channel��byte����