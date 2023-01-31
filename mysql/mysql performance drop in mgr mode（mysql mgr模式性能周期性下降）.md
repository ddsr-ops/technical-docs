官方回应是
感谢您评估Group Replication，您（以及所有社区反馈）非常重要！
与您的建议一样，Group Replication会定期执行维护，更确切地说，每60秒执行一次维护。
我们的表现结果显示，第2.4节。 随着时间的推移稳定
http://mysqlhighavailability.com/performance-evaluation-mysql-5-7-group-replication/
更确切地说，每个成员每隔60秒交换其持久化的事务集并且这些集合用于垃圾收集每个成员维护的认证信息。 在写密集型工作负载（如您的工作负载）上，此操作可能比预期的要长。
我们计划改善这一点。

Thank you for evaluating Group Replication, your (and all community feedback) is important!
Like you did suggest, Group Replication performs maintenance at a regular interval, more precisely each 60 seconds.
Our performance results show that, section 2.4. Stability over time at
http://mysqlhighavailability.com/performance-evaluation-mysql-5-7-group-replication/
More precisely, every 60 seconds every member exchange its persisted transactions set and the intersection of these sets is used to garbage collect the certification info that each member maintains. On write intensive workloads, like yours, this operation can be longer than expected.
We have plans to improve this.


[Reference](https://blog.csdn.net/ashic/article/details/88547014)


Introduce a quota limitation in mysql 8+
[Group replication configuration in mgr mode](https://www.modb.pro/db/23301)