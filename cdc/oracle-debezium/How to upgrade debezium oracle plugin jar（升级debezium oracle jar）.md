# Ŀ��
����kafka connector��Ⱥ��oracle�������  

# ׼��
���ػ����oracle�������

# ����
���²��������ر�˵��������ͬһkafka connector�ڵ�ִ�С�

**NOTE�����²������ڹ���������connector cdc�ڷֲ�ʽ����ģʽ�£��������жϡ�**  
*�����Ҫ��ȫֹͣconnector task���񼰼�Ⱥ���ο���debezium��ȫͣ������.md��*

## ����
```shell
tar -czf oracle-plugin.tgz /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/
```
## �滻jar��
```shell
# ֹͣ�ýڵ��connector����
jps -l |grep ConnectDistributed|awk '{print $1}'|xargs kill -9 

# �鿴�����Ƿ���ȫֹͣ
jps -l |grep ConnectDistributed

# ��jar��ѹ���滻
tar -zxf /tmp/oracle-jar.tgz -C /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/
cd /opt/kafka_2.12-2.7.0/connector/debezium-connector-oracle/ && mv oracle-jar/* .

# ɾ����ͻ��jar������ΪAlpha1�İ�
rm -f *Alpha1*

# �ָ��ýڵ�connector����
cd /opt/kafka_2.12-2.7.0/ && bin/connect-distributed.sh -daemon config/connect-distributed.properties && tailf logs/connect.log
```

## ��������connector�ڵ�
�ڼ�Ⱥ�����ڵ㣬�������ݡ��滻jar��������

# ����
������ˣ������ݵ�jar���ָ�������connector����

# ���
���������󣬲���������־��������kafka topic�У��Ƿ������������ݡ�