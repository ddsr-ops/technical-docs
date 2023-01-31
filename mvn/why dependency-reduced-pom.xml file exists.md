�����maven��Ŀ��jar����������pom.xml�ļ���ͬ·���£�ͻȻ������һ��dependency-reduced-pom.xml��Ҳ��֪������ļ��Ǹ�ʲô�ģ����ű�Ť������ɾ��������

����֪��������pom.xml�У�ʹ����maven-shade-plugin�����jar�����ŵ��������ĳ��֡���������´�����Ա������ɴ��ļ���
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