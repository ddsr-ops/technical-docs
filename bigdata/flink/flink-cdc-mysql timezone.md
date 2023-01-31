flink-connector-jdbc 获取mysql的timestamp类型的数据后，sink到mysql后时间会晚八个小时。
Ex: 获取到的是2020-05-12T11:53:08，写入mysql后变成2020-05-11 22:53:08

问题详情：
我是通过 flink-sql-connector-mysql-cdc获取mysql的binlog。通过flink-connector-jdbc sink到mysql中。

source 中有调节时区的参数'server-time-zone' = 'Asia/Shanghai'。所以读取到的是正确的。但是sink 中没有调节时区的参数。时间就有了时差。

sink中url需要添加serverTimezone=Asia/Shanghai

```
source：
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