 Could not find a suitable table factory for ¡®org.apache.flink.table.delegation.ExecutorFactory¡®
 

Add the dependency.
```
       <dependency>
         <groupId>org.apache.flink</groupId>
         <artifactId>flink-table-planner_${scala.binary.version}</artifactId>
         <version>${flink.version}</version>
<!--         <scope>provided</scope>-->
      </dependency>
```