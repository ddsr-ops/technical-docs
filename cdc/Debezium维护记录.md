# Ŀ��

���ļ�¼���õ�Debeziumά���ʼǡ�

# �����޷������DML

## ֢״����
```
...
Caused by: io.debezium.connector.oracle.logminer.parser.DmlParserException: DML statement couldn't be parsed
...
```

һ�㷢����Դ�ⲻ��ȷ��ִ����Connector��������ر��DDL��䣬����Logminer�������ֵ��޷�ʶ����־�е��ֶΡ�

ͨ����˵���������������Connector�޷����������ؽ����޸�Connector History topic�������ⲿ����־��

1. ��Git�ֿ���ȡ���µ�Debezium Connector����
2. ִ��connector��ɾ����`curl -X DELETE http://10.50.253.6:8085/connectors/oracle_tftfxq`
3. ���ö�Ӧconnector��offsetλ�ã�`select current_scn from v$database; `276598572096��
   �޸Ľű�/opt/kafka_2.12-2.7.0_1/connector-json/debezium-util.sh�е�connector������`scn`��276598572096��
   ִ�нű�`bash debezium-util.sh`, ������Ͷ����connector-offset topic��
4. ��History topic��ȡ���µ�Schema DDL message��Ϣ
   Query history topic data , you can use KSQL of kafka-eagle(path : messages - topic - ksql).
   For example, `select * from oracle_tsm_his where `partition` in (0) and `msg` like '%T_ACT_TRADE_DETAIL%'`
5. ��������ȡ����������SCN��COMMITTED_SCN���޸�Ϊ��С��276598572096�󣬽�����Ͷ����history topic
   Here, we send messages to history topic(such as oracle_ups_his) via kafka-eagle. 
   Enter the web ui , http://namenode2:8049/topic/mock, path : MESSAGES -- TOPICS -- MOCK
6. �½�������connector, `curl -Ss -X POST http://namenode2:8084/connectors/connector_name/tasks/0/restart`
7. ��֤connector�����ɹ����鿴��־`tailf /opt/kafka_2.12-2.7.0_1/logs/connect.log`
   ```For connector oracle_tftfxq, Oracle Session UGA 2.97MB (max = 3.15MB), PGA 155.32MB (max = 235.45MB)```
   ע�⣺N1��N2����־·��Ϊ/opt/kafka_2.12-2.7.0_1/logs/connect.log, D1-D5����־·��Ϊ/opt/kafka_2.12-2.7.0/logs/connect.log
   
TODO: �������޸���Ӱ����ҵ

Note�������ȷʵʩDDL����ο��ĵ���oracle cdc table structure evolution.sql��