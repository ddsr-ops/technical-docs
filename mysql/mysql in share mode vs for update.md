# ���������

SELECT ... LOCK IN SHARE MODE�ߵ���IS��(��������)�����ڷ���������rows�϶����˹�������
�����Ļ�������session���Զ�ȡ��Щ��¼��Ҳ���Լ������IS���������޷��޸���Щ��¼ֱ�������������sessionִ�����(����ֱ�����ȴ���ʱ)��

SELECT ... FOR UPDATE �ߵ���IX��(����������)�����ڷ���������rows�϶�������������
����sessionҲ���޷�����Щ��¼������κε�S����X�������������һ���Է��������Ļ�����ô����session���޷���ȡ���޸���Щ��¼�ģ�
����innodb�з�������(���ն�������Ҫ����)��for update֮�󲢲�����������session�Ŀ��ն�ȡ������
����select ...lock in share mode��select ... for update������ʾ�����Ĳ�ѯ������

���ն�����һ���SELECT ... FROM table�ǿ��ն�ȡ��FOR UPDATE�����������ն���

ͨ���Աȣ�����for update�ļ�����ʽ�޷��Ǳ�lock in share mode�ķ�ʽ��������select...lock in share mode�Ĳ�ѯ��ʽ��
�������������ն���

# Ӧ�ó���

���ҿ�����SELECT ... LOCK IN SHARE MODE��Ӧ�ó����ʺ������ű���ڹ�ϵʱ��д������
��mysql�ٷ��ĵ���������˵��һ������child��һ����parent������child���ĳһ��child_idӳ�䵽parent���c_child_id�У�
��ô��ҵ��ǶȽ�����ʱ��ֱ��insertһ��child_id=100��¼��child���Ǵ��ڷ��յģ�
��Ϊ��insert��ʱ�������parent����ɾ��������c_child_id=100�ļ�¼����ôҵ�����ݾʹ��ڲ�һ�µķ��ա�
��ȷ�ķ������ٲ���ʱִ��select * from parent where c_child_id=100 lock in share mode,������parent���������¼��
Ȼ��ִ��insert into child(child_id) values (100)��ok�ˡ�

���������ͬһ�ű��Ӧ�ó������ٸ����ӣ�����ϵͳ�м���һ����Ʒ��ʣ���������ڲ�������֮ǰ��Ҫȷ����Ʒ����>=1,
��������֮��Ӧ�ý���Ʒ������1��
1 select amount from product where product_name='XX';
2 update product set amount=amount-1 where product_name='XX';


��Ȼ1���������������⣬��Ϊ���1��ѯ��amountΪ1��������ʱ��������sessionҲ���˸���Ʒ�������˶�������ôamount�ͱ����0��
��ô��ʱ�ڶ�����ִ�о������⡣
��ô����lock in share mode������Ҳ�ǲ�����ģ���Ϊ����sessionͬʱ�������м�¼ʱ��
��ʱ����session��updateʱ��Ȼ�����������������ع��������ǲ�������(��ʱ��˳��)

```session1
mysql> begin;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from test_jjj lock in share mode;
+-----+------------+
| id  | name       |
+-----+------------+
| 234 | asdasdy123 |
| 123 | jjj        |
+-----+------------+
2 rows in set (0.00 sec)


session2(ͬ����������ͬ����)
mysql> begin;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from test_jjj lock in share mode;
+-----+------------+
| id  | name       |
+-----+------------+
| 234 | asdasdy123 |
| 123 | jjj        |
+-----+------------+
2 rows in set (0.00 sec)


session1(��ʱsession1��updateʱ�ͻ��������ȴ�)
mysql> update test_jjj set name='jjj1' where name='jjj';


session2(��ʱsession2ͬ��update�ͻ��⵽�������ع�session2��ע��ִ��ʱ�䲻Ҫ����session1�����ȴ���ʱ���ʱ�䣬
����Ҫ����innodb_lock_wait_timeout���õ�ֵ)
mysql> update test_jjj set name='jjj1' where name='jjj';
ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction


session1(��ʱsession1ִ�����)
mysql> update test_jjj set name='jjj1' where name='jjj';
Query OK, 1 row affected (29.20 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

ͨ���ð�����֪lock in share mode�ķ�ʽ����������в����ã�������Ҫʹ��for update�ķ�ʽֱ�Ӽ�X����
�Ӷ����ݵ�����session2��select...for update����;�����ǲ�������

```session1
mysql> begin;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from test_jjj for update;
+-----+------------+
| id  | name       |
+-----+------------+
| 234 | asdasdy123 |
| 123 | jjj1       |
+-----+------------+
2 rows in set (0.00 sec)


session2(��ʱsession2�������ȴ�״̬���ò������)
mysql> begin;
Query OK, 0 rows affected (0.00 sec)


mysql> select * from test_jjj for update;


session1(��ʱsession1 update֮���ύ�������)
mysql> update test_jjj set name='jjj1' where name='jjj';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0


mysql> commit;
Query OK, 0 rows affected (0.00 sec)


session2(session1�ύ֮��session2�ղŵĲ�ѯ����ͳ����ˣ�Ҳ�Ϳ����ٴ�update����ִ����)
mysql> select * from test_jjj for update;
+-----+------------+
| id  | name       |
+-----+------------+
| 234 | asdasdy123 |
| 123 | jjj1       |
+-----+------------+
2 rows in set (37.19 sec)
mysql> select * from test_jjj for update;
+-----+------------+
| id  | name       |
+-----+------------+
| 234 | asdasdy123 |
| 123 | jjj1       |
+-----+------------+
2 rows in set (37.19 sec)


mysql> update test_jjj set name='jjj1' where name='jjj';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 0  Changed: 0  Warnings: 0


mysql> commit;
Query OK, 0 rows affected (0.00 sec)
```

ͨ���Աȣ�lock in share mode���������ű����ҵ���ϵʱ��һ����Ҫ��for  update�����ڲ���ͬһ�ű�ʱ��һ����Ҫ��


***
https://stackoverflow.com/questions/32827650/mysql-innodb-difference-between-for-update-and-lock-in-share-mode

I have been trying to understand the difference between the two. I'll document what I have found in hopes it'll be useful to the next person.

Both LOCK IN SHARE MODE and FOR UPDATE ensure no other transaction can update the rows that are selected. The difference between the two is in how they treat locks while reading data.

LOCK IN SHARE MODE does not prevent another transaction from reading the same row that was locked.

FOR UPDATE prevents other locking reads of the same row (non-locking reads can still read that row; LOCK IN SHARE MODE and FOR UPDATE are locking reads).

This matters in cases like updating counters, where you read value in 1 statement and update the value in another. Here using LOCK IN SHARE MODE will allow 2 transactions to read the same initial value. So if the counter was incremented by 1 by both transactions, the ending count might increase only by 1 - since both transactions initially read the same value.

Using FOR UPDATE would have locked the 2nd transaction from reading the value till the first one is done. This will ensure the counter is incremented by 2.