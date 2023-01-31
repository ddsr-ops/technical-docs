# sqoop 缺少lzo压缩包

## 报错信息  

```log20/06/05 16:27:07 ERROR sqoop.Sqoop: Got exception running Sqoop: java.lang.IllegalArgumentException: Compression codec com.hadoop.compression.lzo.LzoCodec not found.
java.lang.IllegalArgumentException: Compression codec com.hadoop.compression.lzo.LzoCodec not found.
	at org.apache.hadoop.io.compress.CompressionCodecFactory.getCodecClasses(CompressionCodecFactory.java:139)
	at org.apache.hadoop.io.compress.CompressionCodecFactory.<init>(CompressionCodecFactory.java:180)
	at org.apache.sqoop.mapreduce.CombineFileInputFormat.isSplitable(CombineFileInputFormat.java:157)
	at org.apache.sqoop.mapreduce.CombineFileInputFormat.getMoreSplits(CombineFileInputFormat.java:296)
	at org.apache.sqoop.mapreduce.CombineFileInputFormat.getSplits(CombineFileInputFormat.java:256)
	at org.apache.sqoop.mapreduce.ExportInputFormat.getSplits(ExportInputFormat.java:73)
	at org.apache.hadoop.mapreduce.JobSubmitter.writeNewSplits(JobSubmitter.java:310)
	at org.apache.hadoop.mapreduce.JobSubmitter.writeSplits(JobSubmitter.java:327)
	at org.apache.hadoop.mapreduce.JobSubmitter.submitJobInternal(JobSubmitter.java:200)
	at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1570)
	at org.apache.hadoop.mapreduce.Job$11.run(Job.java:1567)
	at java.security.AccessController.doPrivileged(Native Method)
	at javax.security.auth.Subject.doAs(Subject.java:422)
	at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1875)
	at org.apache.hadoop.mapreduce.Job.submit(Job.java:1567)
	at org.apache.hadoop.mapreduce.Job.waitForCompletion(Job.java:1588)
	at org.apache.sqoop.mapreduce.ExportJobBase.doSubmitJob(ExportJobBase.java:323)
	at org.apache.sqoop.mapreduce.ExportJobBase.runJob(ExportJobBase.java:300)
	at org.apache.sqoop.mapreduce.ExportJobBase.runExport(ExportJobBase.java:441)
	at org.apache.sqoop.manager.SqlManager.exportTable(SqlManager.java:930)
	at org.apache.sqoop.tool.ExportTool.exportTable(ExportTool.java:93)
	at org.apache.sqoop.tool.ExportTool.run(ExportTool.java:112)
	at org.apache.sqoop.Sqoop.run(Sqoop.java:146)
	at org.apache.hadoop.util.ToolRunner.run(ToolRunner.java:76)
	at org.apache.sqoop.Sqoop.runSqoop(Sqoop.java:182)
	at org.apache.sqoop.Sqoop.runTool(Sqoop.java:233)
	at org.apache.sqoop.Sqoop.runTool(Sqoop.java:242)
	at org.apache.sqoop.Sqoop.main(Sqoop.java:251)
Caused by: java.lang.ClassNotFoundException: Class com.hadoop.compression.lzo.LzoCodec not found
	at org.apache.hadoop.conf.Configuration.getClassByName(Configuration.java:2409)
	at org.apache.hadoop.io.compress.CompressionCodecFactory.getCodecClasses(CompressionCodecFactory.java:132)
	... 27 more
```

## 解决方式  

集群配置的xml文件内，已经配置所有压缩、解压格式。Sqoop从Mysql到HDFS没问题，但是，Sqoop从HDFS到MySQL依旧报错。最后尝试在Sqoop语句中加入配置参数，成功解决。

```shell
sqoop export \
-D io.compression.codecs=org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.SnappyCodec \
--connect 'jdbc:mysql://10.54.146.107:3306/mdb?useUnicode=true&characterEncoding=utf-8'  \
--username root \
--password 123456 \
--table data_item \
--input-fields-terminated-by ',' \
--export-dir /user/hive/warehouse/my_temp.db/di_to_mysql \
-m 3

sqoop export \
-D io.compression.codecs=org.apache.hadoop.io.compress.DefaultCodec,org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.SnappyCodec \
--connect 'jdbc:mysql://10.54.146.107:3306/mdb?useUnicode=true&characterEncoding=utf-8'  \
--username root \
--password 123456 \
--table is_try \
--input-fields-terminated-by ',' \
--export-dir /user/hive/warehouse/my_temp.db/di_istry_to_mysql \
-m 1
```



或者shell中加入lib Path

```shellshell脚本导入这个东西就行，这个是我把lzo jar包传到lib目录了
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:./hadoop-lzo-0.4.15-cdh6.2.0.jar
也可以用全路径
/opt/cloudera/parcels/GPLEXTRAS/lib/hadoop/lib
```