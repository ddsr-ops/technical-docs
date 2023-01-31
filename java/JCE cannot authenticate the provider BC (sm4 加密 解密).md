国密开发中出现以下错误：

Caused by: java.lang.SecurityException: JCE cannot authenticate the provider BC

详细错误如下：

```
Caused by: java.lang.SecurityException: JCE cannot authenticate the provider BC
	at javax.crypto.Cipher.getInstance(Cipher.java:656)
	at javax.crypto.Cipher.getInstance(Cipher.java:595)
    ...
	... 9 common frames omitted
Caused by: java.util.jar.JarException: file:/C:/app-with-dependencies.jar has unsigned entries - app.properties
	at javax.crypto.JarVerifier.verifySingleJar(JarVerifier.java:502)
	at javax.crypto.JarVerifier.verifyJars(JarVerifier.java:363)
	at javax.crypto.JarVerifier.verify(JarVerifier.java:289)
	at javax.crypto.JceSecurity.verifyProviderJar(JceSecurity.java:164)
	at javax.crypto.JceSecurity.getVerificationResult(JceSecurity.java:190)
	at javax.crypto.Cipher.getInstance(Cipher.java:652)
	... 12 common frames omitted
```
原因是：

Oracle JDK 对于加密算法会验证provider jar是否为Oracle签名jar

对于 Spring Boot 项目，默认打包方式会将Bouncy Castle依赖包以lib jar的方式打包到jar中，保留了原始的jar与签名，所以可以正常使用
对于普通Java项目，如果使用maven-assembly-plugin或maven-shade-plugin，会将依赖的jar解压，全部打包到一个jar中，这时调用加密方法会出现错误。
# 解决办法一：
使用 maven-jar-plugin、maven-dependency-plugin，最终应用部署结构为：

├── lib/*.jar
└── app.jar

Pom plugin
```
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>2.6</version>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <classpathPrefix>lib/</classpathPrefix>
                        <mainClass>com.lakala.sh.mms.sm4.DecMain</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
            <version>2.10</version>
            <executions>
                <execution>
                    <id>copy-dependencies</id>
                    <phase>package</phase>
                    <goals>
                        <goal>copy-dependencies</goal>
                    </goals>
                    <configuration>
                        <includeScope>runtime</includeScope>
                        <outputDirectory>${project.build.directory}/lib</outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```
# 解决办法二：
虽然使用maven-assembly-plugin或maven-shade-plugin插件进行打包，但是可以将对应依赖设置为provided。
```
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk15on</artifactId>
    <version>1.62</version>
    <scope>provided</scope>
</dependency>
```
这样打包后，该包不会打进jar中，单独将该依赖包（bcprov-jdk15on-1.62.jar）放到运行环境中即可

# 解决办法三：
使用Open JDK，Open JDK不会验证加密provider包签名。

yum install java-1.8.0-openjdk
