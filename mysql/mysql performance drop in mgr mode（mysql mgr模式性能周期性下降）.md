�ٷ���Ӧ��
��л������Group Replication�������Լ����������������ǳ���Ҫ��
�����Ľ���һ����Group Replication�ᶨ��ִ��ά������ȷ�е�˵��ÿ60��ִ��һ��ά����
���ǵı��ֽ����ʾ����2.4�ڡ� ����ʱ��������ȶ�
http://mysqlhighavailability.com/performance-evaluation-mysql-5-7-group-replication/
��ȷ�е�˵��ÿ����Աÿ��60�뽻����־û������񼯲�����Щ�������������ռ�ÿ����Աά������֤��Ϣ�� ��д�ܼ��͹������أ������Ĺ������أ��ϣ��˲������ܱ�Ԥ�ڵ�Ҫ����
���Ǽƻ�������һ�㡣

Thank you for evaluating Group Replication, your (and all community feedback) is important!
Like you did suggest, Group Replication performs maintenance at a regular interval, more precisely each 60 seconds.
Our performance results show that, section 2.4. Stability over time at
http://mysqlhighavailability.com/performance-evaluation-mysql-5-7-group-replication/
More precisely, every 60 seconds every member exchange its persisted transactions set and the intersection of these sets is used to garbage collect the certification info that each member maintains. On write intensive workloads, like yours, this operation can be longer than expected.
We have plans to improve this.


[Reference](https://blog.csdn.net/ashic/article/details/88547014)


Introduce a quota limitation in mysql 8+
[Group replication configuration in mgr mode](https://www.modb.pro/db/23301)