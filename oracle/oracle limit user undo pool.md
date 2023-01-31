[REF](https://docs.oracle.com/cd/E11882_01/server.112/e25494/dbrm.htm#ADMIN027)

```text

SQL> conn mcdonac/alicat1
Connected.

SQL> alter system set resource_manager_plan ='';

System altered.

SQL>
SQL> begin
  2    dbms_resource_manager.create_pending_area();
  3    --
  4
  5    dbms_resource_manager.create_consumer_group(
  6      CONSUMER_GROUP=>'CG_UNDO_LIMIT_PLAN',
  7      COMMENT=>'This is the consumer group that small undo limits'
  8      );
  9
 10    dbms_resource_manager.create_plan(
 11      PLAN=> 'UNDO_LIMIT_PLAN',
 12      COMMENT=>'Disallow exceeding undo'
 13    );
 14
 15    dbms_resource_manager.create_plan_directive(
 16      PLAN=> 'UNDO_LIMIT_PLAN',
 17      GROUP_OR_SUBPLAN=>'CG_UNDO_LIMIT_PLAN',
 18      COMMENT=>'Disallow exceeding undo',
 19      UNDO_POOL=>1000  -- one megabyte
 20    );
 21
 22
 23    dbms_resource_manager.create_plan_directive(
 24      PLAN=> 'UNDO_LIMIT_PLAN',
 25      GROUP_OR_SUBPLAN=>'OTHER_GROUPS',
 26      COMMENT=>'leave others alone'
 27    );
 28
 29    DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA;
 30
 31    DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA();
 32
 33  end;
 34  /

PL/SQL procedure successfully completed.

SQL>
SQL> exec dbms_resource_manager_privs.grant_switch_consumer_group('DEMO','CG_UNDO_LIMIT_PLAN',false);

PL/SQL procedure successfully completed.

SQL> exec dbms_resource_manager.set_initial_consumer_group('DEMO','CG_UNDO_LIMIT_PLAN');

PL/SQL procedure successfully completed.

SQL>
SQL> alter system set resource_manager_plan ='UNDO_LIMIT_PLAN';

System altered.

SQL> conn demo/demo
Connected.

SQL> create table t as select * from all_Objects;

Table created.

SQL> insert /*+ APPEND */ into t select * from t;

57034 rows created.

SQL> commit;

Commit complete.

SQL> insert /*+ APPEND */ into t select * from t;

114068 rows created.

SQL> commit;

Commit complete.

SQL> delete from t;
delete from t
            *
ERROR at line 1:
ORA-30027: Undo quota violation - failed to get 288 (bytes)


SQL>
```