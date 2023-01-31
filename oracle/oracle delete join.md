**delete join for oracle**

```text
SQL> delete from t join t1 on  t1.id = t.id;
delete from t join t1 on  t1.id = t.id
              *
第 1 行出现错误:
ORA-00933: SQL 命令未正确结束


SQL> delete (select * from t join t1 on t.id = t1.id);
delete (select * from t join t1 on t.id = t1.id)
       *
第 1 行出现错误:
ORA-01752: 不能从没有一个键值保存表的视图中删除


SQL> delete from (select * from t join t1 on t.id = t1.id);
delete from (select * from t join t1 on t.id = t1.id)
            *
第 1 行出现错误:
ORA-01752: 不能从没有一个键值保存表的视图中删除

SQL> delete t join t1 on t.id = t1.id;
delete t join t1 on t.id = t1.id
         *
第 1 行出现错误:
ORA-00933: SQL 命令未正确结束
```

> No delete join statements are permitted in oracle grammar, but in mysql. 