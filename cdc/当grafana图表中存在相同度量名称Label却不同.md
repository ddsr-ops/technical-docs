������˵�����Դ��ڲ�ͬLabelֵ��Metric�ģ�
����Metric{LabelA="value1"}=,Metric{LabelA="value2"}=

������ĳЩ�ض������£�����Metric�ǲ�����ͬʱ���ڵġ�

������Debezium�Ĺٷ�Metric�У�ͬһ��Connector���Ƶ�Metric��ֻ��ͬʱ����һ����
��ΪConnector�����ظ�������������

When debezium connectors switch to another server,  alert rule measurement result may be error, because different host labels
brings two or more measurement result.

This is because one connector node seems to be hanged.

I restart the connector node so resolve it.