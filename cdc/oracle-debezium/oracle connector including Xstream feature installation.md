```shell
tar -zxf instantclient_19_6.tgz

# ojdbc8.jar and xstreams.jar originate from instantclient_19_6.tgz
# copy them to $kafka_home/libs where connect-distributed service started
cp ojdbc8.jar /opt/$kafka_home/libs/
cp xstreams.jar /opt/$kafka_home/libs/

export JAVA_HOME=/opt/jdk-11.0.18
export CLASSPATH=${JAVA_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH 
export KAFKA_CONN_PORT=8085
export LD_LIBRARY_PATH=/opt/oracle/instantclient_19_6

java -version

# start connect-distributed service using java 11
bin/connect-distributed-oracle.sh  -daemon config/connect-distributed-oracle.properties
```