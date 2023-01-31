1. Download source code from github.com
2. Remove checkstyle plugin of pom.xml in debezium-parent module
3. Remove docker build plugin in root pom.xml 
4. mvn clean verify -Pquick -DskipITs -Dcheckstyle.skip=true -Dformat.skip=true -Drevapi.skip=true

*Note: Not set mirror in maven settings.*  
**Note£ºMakes sure system time on building machine is right**
```shell
# query system time
date
# restart ntpd
systemctl restart ntpd
ntpq -p
```



***
**Deploy**

After building completion, Finds jar by using `find . -name "debezium*jar"` referring to plugin jars released by redhat.
```shell
mkdir mysql-plugin
# find . -name antlr4-runtime-4.8.jar  | xargs -i cp {} mysql-plugin  
find . -name debezium-api-1.7.0.Beta1.jar   | xargs -i cp {} mysql-plugin
find . -name debezium-connector-mysql-1.7.0.Beta1.jar | xargs -i cp {} mysql-plugin 
find . -name debezium-core-1.7.0.Beta1.jar | xargs -i cp {} mysql-plugin
find . -name debezium-ddl-parser-1.7.0.Beta1.jar | xargs -i cp {} mysql-plugin
# find . -name failureaccess-1.0.1.jar | xargs -i cp {} mysql-plugin
# find . -name guava-30.0-jre.jar | xargs -i cp {} mysql-plugin
# find . -name mysql-binlog-connector-java-0.25.1.jar | xargs -i cp {} mysql-plugin
# find . -name mysql-connector-java-8.0.26.jar | xargs -i cp {} mysql-plugin
```
```shell
mkdir mysql-plugin
# find . -name antlr4-runtime-4.8.jar  | xargs -i cp {} mysql-plugin  
find . -name debezium-api-1.7.0-SNAPSHOT.jar   | xargs -i cp {} mysql-plugin
find . -name debezium-connector-mysql-1.7.0-SNAPSHOT.jar | xargs -i cp {} mysql-plugin 
find . -name debezium-core-1.7.0-SNAPSHOT.jar | xargs -i cp {} mysql-plugin
find . -name debezium-ddl-parser-1.7.0-SNAPSHOT.jar | xargs -i cp {} mysql-plugin
```

*Note: Uploads mysql-connector-java-8.0.26.jar manually.*
When using mysql-connector jar of 8.0.21 version, following exception arose.
> com.mysql.cj.CharsetMapping.getStaticCollationNameForCollationIndex