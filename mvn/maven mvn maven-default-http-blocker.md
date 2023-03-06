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

�����֮�����ʹ��HTTPЭ���������������ܻᵼ���м��˹��������磬����������һ��nacos-client�ģ�������صĽ���б������˶�����룬Ȼ�󿪷���Ա������һ�£��ڿ;��ܻ�ÿ�����Ա�ļ��������Ȩ�ˡ�

����Maven 3.8.1�ͽ�ֹ������HTTPЭ���Maven�ֿ⡣

���������ճ������У����Ǿ������õ���˾�ڲ���maven�ֿ⡣��Щ�ֿ�һ�㶼��httpЭ�飬Maven 3.8.1��ֹ��httpЭ�飬��ô�ͻᵼ�¿�ͷ�ı���

���ǲ����£����԰������·�ʽ�رգ�

��~/.m2/setttings.xml�����ͬ��mirror��Ȼ��ָ�����mirror�����κβֿ���Ч���ɡ�

```
<mirror>
    <id>maven-default-http-blocker</id>
    <mirrorOf>!*</mirrorOf>
    <url>http://0.0.0.0/</url>
</mirror>
```
Ȼ��Ϳ��Լ�������ʹ��Maven�ˡ�

P.S. �����ⲿ�ֿ⣬���ǽ���ʹ��HTTPSЭ����ʣ���ֹ��������Ե��м��˹�����
