���ܿ����г������´���

Caused by: java.lang.SecurityException: JCE cannot authenticate the provider BC

��ϸ�������£�

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
ԭ���ǣ�

Oracle JDK ���ڼ����㷨����֤provider jar�Ƿ�ΪOracleǩ��jar

���� Spring Boot ��Ŀ��Ĭ�ϴ����ʽ�ὫBouncy Castle��������lib jar�ķ�ʽ�����jar�У�������ԭʼ��jar��ǩ�������Կ�������ʹ��
������ͨJava��Ŀ�����ʹ��maven-assembly-plugin��maven-shade-plugin���Ὣ������jar��ѹ��ȫ�������һ��jar�У���ʱ���ü��ܷ�������ִ���
# ����취һ��
ʹ�� maven-jar-plugin��maven-dependency-plugin������Ӧ�ò���ṹΪ��

������ lib/*.jar
������ app.jar

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
# ����취����
��Ȼʹ��maven-assembly-plugin��maven-shade-plugin������д�������ǿ��Խ���Ӧ��������Ϊprovided��
```
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk15on</artifactId>
    <version>1.62</version>
    <scope>provided</scope>
</dependency>
```
��������󣬸ð�������jar�У�����������������bcprov-jdk15on-1.62.jar���ŵ����л����м���

# ����취����
ʹ��Open JDK��Open JDK������֤����provider��ǩ����

yum install java-1.8.0-openjdk
