oci 和 thin 的区别

Java 程序连接 Oracle 数据库时，用 oci 驱动要比用 thin 驱动性能好些。

主要的区别是使用 thin 驱动时，不需要安装 Oracle 的客户端，而使用 oci 时则要安装 Oracle 的客户端。

这里Oracle客户端，指的是oracle instant client，里面包含C相关的库、ojdbc.jar、xstream.jar

下载解压后，将环境变量LD_LIBRARY_PATH指向解压后的目录：  
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_6:$LD_LIBRARY_PATH