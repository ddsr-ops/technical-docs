In some scenarios, dataframe data type can not be extrapolated in spark program.

We can use interactive spark-shell terminal to judge the data type. 

```text
[root@namenode1 spark]# ./spark3-shell.sh 2
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://namenode1:4041
Spark context available as 'sc' (master = spark://namenode1:7077,namenode2:7077, app id = app-20221212161651-5879).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.0.1
      /_/
         
Using Scala version 2.12.10 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_144)
Type in expressions to have them evaluated.
Type :help for more information.

scala> val df = spark.sql("select sum(case when service_id = 'METRO' and in_time is not null and out_time is not null then round(35 * ((unix_timestamp(out_time) - unix_timestamp(in_time))/3600), 2) else 0 end) as metro_qr_distance, sum(case when service_id = 'BUS'  then 8.25 else 0 end) as bus_qr_distance from hadoop_catalog.sdm.s_tft_xcgl_j_trip_open")
df: org.apache.spark.sql.DataFrame = [metro_qr_distance: double, bus_qr_distance: decimal(22,2)]
```