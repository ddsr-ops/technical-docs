����Ҫ���ľ���ʹ�� flush logs ���flush logs ���� MySQL rotate(��ת) ����һ�� binlog ����д�롣 
���������ǾͿ��Դﵽ�� flush logs ֮ǰ�� binlog ������������Ŀ�ġ�

���磺
```mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000015 |       241 |
| mysql-bin.000016 |       241 |
| mysql-bin.000017 |       217 |
| mysql-bin.000018 |       824 |
| mysql-bin.000019 |      1081 |
| mysql-bin.000020 |       241 |
| mysql-bin.000021 |       217 |
| mysql-bin.000022 |       241 |
| mysql-bin.000023 |       194 |
+------------------+-----------+
9 rows in set (0.00 sec)

mysql> flush logs;
Query OK, 0 rows affected (0.01 sec)

mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000015 |       241 |
| mysql-bin.000016 |       241 |
| mysql-bin.000017 |       217 |
| mysql-bin.000018 |       824 |
| mysql-bin.000019 |      1081 |
| mysql-bin.000020 |       241 |
| mysql-bin.000021 |       217 |
| mysql-bin.000022 |       241 |
| mysql-bin.000023 |       241 |
| mysql-bin.000024 |      1104 |
+------------------+-----------+
```
ԭ�� MySQL ���ڽ� binlog д�� mysql-bin.000023��flush logs ���� MySQL �ر� mysql-bin.000023��
Ȼ��� mysql-bin.000024 ��Ϊ��ǰ��������־д�롣 �������ǾͿ��԰�ȫ�ı��� mysql-bin.000015 �� mysql-bin.000023 �⼸����־�ļ��ˡ�

��־���ݽ׶Σ�����ʹ�� rsync��scp �ȹ��߽��䱸�ݣ���ȻҲ������ʹ�� tar ���������ٱ��ߡ�

������ɺ���ȷ�ϱ��ݼ���Ч������£����Խ���־���

```mysql> purge master logs to 'mysql-bin.000024';```