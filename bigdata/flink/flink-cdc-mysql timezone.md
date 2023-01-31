flink-connector-jdbc ��ȡmysql��timestamp���͵����ݺ�sink��mysql��ʱ�����˸�Сʱ��
Ex: ��ȡ������2020-05-12T11:53:08��д��mysql����2020-05-11 22:53:08

�������飺
����ͨ�� flink-sql-connector-mysql-cdc��ȡmysql��binlog��ͨ��flink-connector-jdbc sink��mysql�С�

source ���е���ʱ���Ĳ���'server-time-zone' = 'Asia/Shanghai'�����Զ�ȡ��������ȷ�ġ�����sink ��û�е���ʱ���Ĳ�����ʱ�������ʱ�

sink��url��Ҫ���serverTimezone=Asia/Shanghai

```
source��
CREATE TABLE student (
  id INT,
  name STRING,
  create_time TIMESTAMP(0),
  update_time TIMESTAMP(0),
  time_ds STRING,
  ret INT
) WITH (
  'connector' = 'mysql-cdc',
  'hostname' = '127.0.0.1',
  'port' = '3306',
  'username' = 'dev',
  'password' = '**',
  'database-name' = 'wms',
  'table-name' = 'student',
  'source-offset-file' = 'mysql-bin.000007',
  'source-offset-pos' = '1574112',
  'server-time-zone' = 'Asia/Shanghai'
);

sink:
CREATE TABLE student_02 (
id INT,
  name STRING,
  create_time TIMESTAMP(0),
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
   'connector' = 'jdbc',
   'url' = 'jdbc:mysql://127.0.0.1:3306/wms&serverTimezone=Asia/Shanghai',
   'table-name' = 'student_02',
   'username' = 'dev',
   'password' = '***'
);

```