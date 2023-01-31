Because packages conflict.

If you package a application jar including flink dependencies, when submitting a job with the application jar 
"Multiple factories for identifier ..." error happens.

Modify the pom file, set the scope of relevant flink dependency to "provided", such as 

```
<dependency>
    <groupId>org.apache.flink</groupId>
    <artifactId>flink-table-api-scala_2.12</artifactId>
    <version>${flink.version}</version>
    <scope>provided</scope>
</dependency>
```