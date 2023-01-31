[ERROR] Failed to execute goal on project debezium-connector-mysql: Could not resolve dependencies for project io.debezium:
debezium-connector-mysql:jar:1.7.0.Beta1: Failed to collect dependencies at 
com.zendesk:mysql-binlog-connector-java:jar:0.25.1: Failed to read artifact descriptor for 
com.zendesk:mysql-binlog-connector-java:jar:0.25.1: Could not transfer artifact
com.zendesk:mysql-binlog-connector-java:pom:0.25.1 from/to central (https://repo.maven.apache.org/maven2): 
transfer failed for https://repo.maven.apache.org/maven2/com/zendesk/mysql-binlog-connector-java/0.25.1/mysql-binlog-connector-java-0.25.1.pom: 
PKIX path validation failed: java.security.cert.CertPathValidatorException: validity check failed: NotBefore:
Wed Sep 08 00:43:53 CST 2021 -> [Help 1]


yum install ntpd  
yum install ntpdate  
yum enable ntpd --now  
yum enable ntpdate --now