```
18/03/15 09:39:16 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
java.io.IOException: No FileSystem for scheme: hdfs
    at org.apache.hadoop.fs.FileSystem.getFileSystemClass(FileSystem.java:2676)
    at org.apache.hadoop.fs.FileSystem.createFileSystem(FileSystem.java:2690)
    at org.apache.hadoop.fs.FileSystem.access$200(FileSystem.java:94)
    at org.apache.hadoop.fs.FileSystem$Cache.getInternal(FileSystem.java:2733)
    at org.apache.hadoop.fs.FileSystem$Cache.get(FileSystem.java:2715)
    at org.apache.hadoop.fs.FileSystem.get(FileSystem.java:382)
    at com.xcar.etl.ApendToHdfs.apend(ApendToHdfs.java:50)
    at com.xcar.etl.ApendToHdfs.main(ApendToHdfs.java:154)
```

解决办法: 将 java -jar XXX.jar 改为 hadoop jar xxx.jar 命令执行。