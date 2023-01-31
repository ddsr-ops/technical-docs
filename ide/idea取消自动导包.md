启动自动导包有个问题，在Spark工程中import org.apache.spark.sql.functions._
这样导入，无法直接被使用，但是必须导入，导入后会被idea工具优化掉（实际删除）

设置取消自动导入后，可解决该问题，Editor --> General --> Auto Import --> Scala --> 取消Optimize imports on the fly.