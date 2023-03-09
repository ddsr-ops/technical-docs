# install jdk
download jdk from oracle website.  
**版本：要求大于11**
```shell
tar -zxf jdk-11.0.12_linux-x64_bin.tar.gz
echo "export JAVA_HOME=/root/jdk-11.0.12" >> /etc/profile
source /etc/profile
```
***NOTE: NOT install jdk by yum***


# install maven
下载：https://maven.apache.org/download.cgi
```shell
tar -zxf apache-maven-3.8.2-bin.tar.gz
echo "export PATH=$PATH:/root/apache-maven-3.8.2/bin:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile
```
Note: Maven of version 3.9.0 not works

# install oracle-instant-client
download:  https://www.oracle.com/cn/database/technologies/instant-client/linux-x86-64-downloads.html  
```shell
unzip instantclient-basic-linux.x64-21.3.0.0.0.zip
cd instantclient_21_3
mvn install:install-file \
  -DgroupId=com.oracle.instantclient \
  -DartifactId=xstreams \
  -Dversion=21.1.0.0 \
  -Dpackaging=jar \
  -Dfile=xstreams.jar
```


# build oracle-connector jar
modify pom.xml in debezium-parent module, in detail, comment on maven-checkstyle-plugin section.      

*NOTE: make sure memory of machine for building jar is enough*

```shell
mvn clean install -pl debezium-connector-oracle -am -Poracle,quick,logminer -Dinstantclient.dir=/path/to/instant-client-dir
mvn clean install -pl debezium-connector-oracle -am -Poracle,quick,oracle-ci,infinispan-buffer -Dcheckstyle.skip=true -Dformat.skip=true -Drevapi.skip -Dinstantclient.dir=/root/debezium/instantclient_21_3
```
Profile oracle-ci excludes xstream jar which needs oracle ogg license. 

In building directory, Gets jar files by using `find . -name "*jar"`

`mkdir oracle-plugin && find . -name "*1.7.0-SNAPSHOT.jar"|xargs -i cp {} oracle-plugin  
tar -czf debezium-1.7-oracle-utc8.tgz  oracle-plugin `  
zips oracle-plugin, and replaces jars in kafka connector directory. 