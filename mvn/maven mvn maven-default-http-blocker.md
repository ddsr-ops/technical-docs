Use maven with `-X` option, some messages including `maven-default-http-blocker` keywords
are produced.

```
Using mirror maven-default-http-blocker (http://0.0.0.0/) for apache.snapshots
......
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for apache.snapshots (http://people.apache.org/repo/m2-snapshot-repository).
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for codehaus.snapshots (http://snapshots.repository.codehaus.org).
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for snapshots (http://snapshots.maven.codehaus.org/maven2).
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for central (http://repo1.maven.org/maven2).
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for apache-snapshots (http://people.apache.org/maven-snapshot-repository).
[DEBUG] Using mirror maven-default-http-blocker (http://0.0.0.0/) for codehaus-snapshots (http://snapshots.repository.codehaus.org).
......
[DEBUG] Resolving artifact org.apache.maven:maven-project:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.apache.maven:maven-settings:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact junit:junit:jar:3.8.1 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.apache.maven:maven-model:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.apache.maven:maven-artifact-manager:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.apache.maven:maven-repository-metadata:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.apache.maven:maven-artifact:jar:2.0.6 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.codehaus.plexus:plexus-utils:jar:3.0.5 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
[DEBUG] Resolving artifact org.codehaus.plexus:plexus-digest:jar:1.0 from [aliyun-nexus (https://maven.aliyun.com/nexus/content/groups/public, default, releases+snapshots), central (https://repo.maven.apache.org/maven2, default, releases), maven-default-http-blocker (http://0.0.0.0/, default, snapshots, blocked)]
```

```
[WARNING] Could not validate integrity of download from http://0.0.0.0/com/alibaba/nacos/nacos-client-mse-extension/1.4.2-SNAPSHOT/maven-metadata.xml
org.eclipse.aether.transfer.ChecksumFailureException: Checksum validation failed, expected <!doctype but is 18420d7f1430a348837b97a31a80e374e3b00254
    at org.eclipse.aether.connector.basic.ChecksumValidator.validateExternalChecksums (ChecksumValidator.java:174)
    at org.eclipse.aether.connector.basic.ChecksumValidator.validate (ChecksumValidator.java:103)
    at org.eclipse.aether.connector.basic.BasicRepositoryConnector$GetTaskRunner.runTask (BasicRepositoryConnector.java:460)
    at org.eclipse.aether.connector.basic.BasicRepositoryConnector$TaskRunner.run (BasicRepositoryConnector.java:364)
    at org.eclipse.aether.util.concurrency.RunnableErrorForwarder$1.run (RunnableErrorForwarder.java:75)
    at org.eclipse.aether.connector.basic.BasicRepositoryConnector$DirectExecutor.execute (BasicRepositoryConnector.java:628)
    at org.eclipse.aether.connector.basic.BasicRepositoryConnector.get (BasicRepositoryConnector.java:235)
    at org.eclipse.aether.internal.impl.DefaultMetadataResolver$ResolveTask.run (DefaultMetadataResolver.java:573)
    at org.eclipse.aether.util.concurrency.RunnableErrorForwarder$1.run (RunnableErrorForwarder.java:75)
    at java.util.concurrent.ThreadPoolExecutor.runWorker (ThreadPoolExecutor.java:1130)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run (ThreadPoolExecutor.java:630)
    at java.lang.Thread.run (Thread.java:832)
[WARNING] Checksum validation failed, expected <!doctype but is 18420d7f1430a348837b97a31a80e374e3b00254 from maven-default-http-blocker for http://0.0.0.0/com/alibaba/nacos/nacos-client-mse-extension/1.4.2-SNAPSHOT/maven-metadata.xml
Downloaded from maven-default-http-blocker: http://0.0.0.0/com/alibaba/nacos/nacos-client-mse-extension/1.4.2-SNAPSHOT/maven-metadata.xml (63 kB at 19 kB/s)
```

简而言之，如果使用HTTP协议下载依赖，可能会导致中间人攻击。比如，本来想下载一个nacos-client的，结果下载的结果中被插入了恶意代码，然后开发人员运行了一下，黑客就能获得开发人员的计算机控制权了。

所以Maven 3.8.1就禁止了所有HTTP协议的Maven仓库。

问题是在日常开发中，我们经常会用到公司内部的maven仓库。这些仓库一般都是http协议，Maven 3.8.1禁止了http协议，那么就会导致开头的报错。

于是查了下，可以按照如下方式关闭：

在~/.m2/setttings.xml中添加同名mirror，然后指定这个mirror不对任何仓库生效即可。

```
<mirror>
    <id>maven-default-http-blocker</id>
    <mirrorOf>!*</mirrorOf>
    <url>http://0.0.0.0/</url>
</mirror>
```
然后就可以继续正常使用Maven了。

P.S. 对于外部仓库，还是建议使用HTTPS协议访问，防止出现针对性的中间人攻击。
