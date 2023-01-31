**delete join for oracle**

```text
SQL> delete from t join t1 on  t1.id = t.id;
delete from t join t1 on  t1.id = t.id
              *
�� 1 �г��ִ���:
ORA-00933: SQL ����δ��ȷ����


SQL> delete (select * from t join t1 on t.id = t1.id);
delete (select * from t join t1 on t.id = t1.id)
       *
�� 1 �г��ִ���:
ORA-01752: ���ܴ�û��һ����ֵ��������ͼ��ɾ��


SQL> delete from (select * from t join t1 on t.id = t1.id);
delete from (select * from t join t1 on t.id = t1.id)
            *
�� 1 �г��ִ���:
ORA-01752: ���ܴ�û��һ����ֵ��������ͼ��ɾ��

SQL> delete t join t1 on t.id = t1.id;
delete t join t1 on t.id = t1.id
         *
�� 1 �г��ִ���:
ORA-00933: SQL ����δ��ȷ����
```

> No delete join statements are permitted in oracle grammar, but in mysql. 