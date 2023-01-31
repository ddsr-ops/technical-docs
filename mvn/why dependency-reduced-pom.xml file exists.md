今天给maven项目打jar包，发现在pom.xml文件的同路径下，突然生出了一个dependency-reduced-pom.xml，也不知道这个文件是干什么的，看着别扭就想着删除了它。

后来知道是我在pom.xml中，使用了maven-shade-plugin插件打jar包，才导致了它的出现。添加上以下代码可以避免生成此文件：
<configuration>
      <createDependencyReducedPom>false</createDependencyReducedPom>
</configuration>

 

```xml
<plugin>
   <groupId>org.apache.maven.plugins</groupId>
   <artifactId>maven-shade-plugin</artifactId>
   <version>2.4.3</version>
   <configuration>
      <createDependencyReducedPom>false</createDependencyReducedPom>
   </configuration>
   <executions>
      <execution>
         <phase>package</phase>
         <goals>
            <goal>shade</goal>
         </goals>
         <configuration>
            <transformers>
               <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                  <mainClass>Main</mainClass>
               </transformer>
            </transformers>
         </configuration>
      </execution>
   </executions>
</plugin>
```