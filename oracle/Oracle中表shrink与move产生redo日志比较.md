```
1 move时实验

SQL> create table my_objects_move tablespace ASSM as select * from all_objects where rownum < 20000;

Table created

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

   2317832

 

SQL> delete from my_objects_move where object_name like '%C%';

7546 rows deleted

SQL> delete from my_objects_move where object_name like '%U%';

2959 rows deleted

SQL> commit;

Commit complete

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

   6159912

 

SQL> alter table my_objects_move move;

Table altered

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

   7265820

 

SQL> select (7265820 - 6159912) / 1024 / 1024 "redo_size(M)" from dual;

redo_size(M)

------------

1.0546760559

2 shrink时实验

SQL> create table my_objects tablespace ASSM as select * from all_objects where rownum < 20000;

Table created

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

   2315104

 

SQL> delete from my_objects where object_name like '%C%';

7546 rows deleted

SQL> delete from my_objects where object_name like '%U%';

2959 rows deleted

SQL> commit;

Commit complete

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

   6157428

 

SQL> alter table my_objects enable row movement;

Table altered

SQL> alter table my_objects shrink space;

Table altered

 

SQL> select value

  2    from v$mystat, v$statname

  3   where v$mystat.statistic# = v$statname.statistic#

  4     and v$statname.name = 'redo size';

     VALUE

----------

  11034900

 

SQL> select (11034900 - 6157428) / 1024 / 1024 "redo_size(M)" from dual;

redo_size(M)

------------

4.6515197753

3 结论

move时产生的日志比shrink时少．
```