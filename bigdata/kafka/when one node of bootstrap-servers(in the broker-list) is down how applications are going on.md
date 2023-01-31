当配置的bootstrap-server或broker-list其中一台挂掉后， 相关流式程序如何？

结论：无论kafka节点增减（不论节点是否在bootstrap-server或broker-list中），
已连接kafka集群的程序，均能正常获取最新的kafka集群元数据信息。

验证过程：

```text
环境：三台机器cdh1/2/3，组建Kafka集群

当前三台broker均在线，启动生产者消费者程序

kafka-console-producer --broker-list cdh1:9092 --topic test

kafka-console-consumer --bootstrap-server cdh1:9092 --from-beginning --topic test

尝试在生产端生产几条数据，消费端能正常消费，此时通过CM管理台直接停止cdh1。

当完全停止cdh1后，继续尝试在生产端生产几条数据，消费端仍然能正常消费。
```

当然，这里还需要考虑分区和副本数，如果副本数为1，且恰好在cdh1上，则该副本对应的分区可不用，程序将会报错。

bootstrap.servers这个参数，是需要随时保证列表中的节点至少有一个可用吗？
还是在初始化的时候保证就可以了？我最开始bootstrap.servers里面只有一个节点，
现在在kafka server端扩展了一个节点，客户端一切正常， 
但现在bootstrap.servers里配置的这个节点挂了，还能正常运行吗？

解答：
我这边测试的结果是producer和consumer都可以正常工作。
bootstrap.servers只是用于客户端启动（bootstrap）的时候有一个可以热启动的一个连接者，
一旦启动完毕客户端就应该可以得知当前集群的所有节点的信息，
日后集群扩展的时候客户端也能够自动实时的得到新节点的信息，即使bootstrap.servers里面的挂掉了也应该是能正常运行的，
除非节点挂掉后客户端也重启了。 所以，bootstrap.servers参数，只在启动客户端kafka连接时有用，且列表里面多个项，只要一个可用就行了。

[Reference](https://blog.csdn.net/zollty/article/details/108975026)

```
1、我们知道旧版Kafka，用的是zookeeper地址而非bootstrap.servers，

那么新版 kafka 消费者、生产者配置为何使用 bootstrap-servers 而不是 zookeeper 服务器地址？

解答：

    Kafka修改这个配置的提案叫做“KIP-500: Replace ZooKeeper with a Self-Managed Metadata Quorum”，该提案一出，大部分人都赞同组件越少越好，并认为这会让部署变得更加容易；当然也有网友担心，移除 ZooKeeper 后，Kafka 会像 ElasticSearch 那样在集群发现、首领选举、故障检测方面出现各种问题。

    详细说明，参见：

    官方文档：https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum

    中文翻译：https://www.aboutyun.com/thread-27567-1-1.html

    我总结一下，主要有两个目的/动机：一是优化元数据管理，原来的zk方案，极端情况下可能会造成数据不一致；二是简化部署和配置。文中还讨论了，元数据管理为什么不使用Etcd或Consul，那是因为用这些中间件，都无法达成上面两个目标。

 

2、bootstrap.servers这个参数，是需要随时保证列表中的节点至少有一个可用吗？还是在初始化的时候保证就可以了？我最开始bootstrap.servers里面只有一个节点，现在在kafka server端扩展了一个节点，客户端一切正常，但现在bootstrap.servers里配置的这个节点挂了，还能正常运行吗？

    解答：

    我这边测试的结果是producer和consumer都可以正常工作。

    bootstrap.servers只是用于客户端启动（bootstrap）的时候有一个可以热启动的一个连接者，一旦启动完毕客户端就应该可以得知当前集群的所有节点的信息，日后集群扩展的时候客户端也能够自动实时的得到新节点的信息，即使bootstrap.servers里面的挂掉了也应该是能正常运行的，除非节点挂掉后客户端也重启了。

    所以，bootstrap.servers参数，只在启动客户端kafka连接时有用，且列表里面多个项，只要一个可用就行了。

 

3、高速上换轮胎——假设Kafka有3个节点，现在某个节点的服务器因为某种原因不能继续使用了，那要怎么增加一个节点来恢复到原来的状态？
    第一种方案：新增一个全新节点。该方案的弊端是，以前的partition数据不会重新分配。但可以手工执行partition数据迁移，参见：https://www.jianshu.com/p/df7d0ec9ac29

    第二种方案：将需要替换的旧节点的数据完整深度克隆一份，在新服务器上启动即可（IP变了不影响，因为Kafka识别broker节点，是根据broker_id，只要kafka的broker_id不变，集群仍然认为这个原来那个节点）。

    备注1：第二种方案已经通过了测试，不放心的可以自己在测试一下。

    备注2：之前我们公司采用第二个方案时，加了一个额外步骤：

kafka IP1优雅停机，修改原IP1为IP2，准备一个备用机并修改备用机的 IP为IP1，在备用机1上配置端口转发如下：

iptables -t nat -A PREROUTING -d IP1 -p tcp --dport 9092 -j DNAT --to-destination IP2:9092

iptables -t nat -A POSTROUTING -d IP2 -p tcp --dport 9092 -j SNAT --to-source IP1

    解释一下：相当于将原来的IP1落到另一个备用机上，然后备用机接管IP1的流量，将其转发到IP2（偷梁换柱）。

    但到底有没有必要这么做？

    实际上，我认为是没有必要的，因为kafka IP1优雅停机后，一切与IP1的流量就切断了。这个方案是另一个架构师设计的，他当时设计这个的原因是，客户端（bootstrap.servers列表里面）有配置IP1，他担心客户端仍然会向IP1发请求。但如果懂bootstrap.servers的真正含义，就知道，客户端的启动配置里面虽然有IP1，但是客户端运行时会自动连接master节点获取完整的IP列表。即使IP1不可用了，也不会对客户端的运行造成影响。

 

4、Kafka中Zookeeper的具体作用是什么？

    细节比较多，包括集群注册、维护等，参看：

    https://zhuanlan.zhihu.com/p/95831768

    https://www.cnblogs.com/huazai007/articles/10990449.html
```