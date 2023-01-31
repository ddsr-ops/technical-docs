**Catalog must be set to `redo_log_catalog`, tracking `DDL` events when table structure is changed.**

conclusion: dml events of both old table and new table are all captured correctly. 

# Create table 
```
CREATE TABLE test_1
(
  employee_id         NUMBER,
  employee_name       VARCHAR2(20),
  create_time         DATE    
)
PARTITION BY RANGE(create_time)
INTERVAL (NUMTODSINTERVAL(1,'day'))
(
  PARTITION partition20140101 VALUES LESS THAN(to_date('2014-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss'))
);

create unique index uk_test1_emp_id on test_1(employee_id) global partition by hash(employee_id) partitions 4; 
alter table test_1 add primary key(employee_id) using index uk_test1_emp_id; 

create index idx_test1_emp_name on test_1(employee_name) local;


CREATE TABLE test_2
(
  employee_id         NUMBER,
  employee_name       VARCHAR2(20),
  create_time         DATE    
)
PARTITION BY RANGE(create_time)
INTERVAL (NUMTODSINTERVAL(1,'day'))
(
  PARTITION partition20140101 VALUES LESS THAN(to_date('2014-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss'))
);

create unique index uk_test2_emp_id on test_2(employee_id) global partition by hash(employee_id) partitions 4; 
alter table test_2 add primary key(employee_id) using index uk_test2_emp_id; 

create index idx_test2_emp_name on test_2(employee_name) local;

```

# Connector configuration
```
{
     "name": "devdboragch7",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "dba_test.test_1:employee_id;dba_test.test_2:employee_id",
         "tasks.max" : "1",
         "database.server.name" : "dev_oracle_gch7",
         "key.converter.schemas.enable": "false",
         "tombstones.on.delete": "false",
         "value.converter.schemas.enable": "false",
         "value.converter": "org.apache.kafka.connect.json.JsonConverter",
         "key.converter": "org.apache.kafka.connect.json.JsonConverter",
         "snapshot.mode" : "schema_only",
         "database.user" : "logminer",
         "log.mining.strategy" : "online_catalog",
         "log.mining.transaction.retention.hours" : "1",
         "database.password" : "logminer",
         "database.dbname" : "ora11g",
         "table.include.list":"dba_test.test_1,dba_test.test_2",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "dev_oracle_his_gch7"
     }
  }
```

Connector will capture table `test_1` and `test_2`.

# Mock ddl and dml events

When mocking ddl and dml events, see whether connector works correctly.

Invoke the following oracle procedure to mock ddl and dml events.

```
declare
  v_max_id number;
  sql_stmt varchar2(32646);
BEGIN
  -- Mock dml events on original table
  select nvl(max(employee_id), 0) + 1 into v_max_id from dba_test.test_1;
  FOR I IN v_max_id .. v_max_id + 3 LOOP
    DBMS_LOCK.SLEEP(0.5);
    --DBMS_OUTPUT.PUT_LINE(to_char(i));
    INSERT INTO dba_test.test_1
      (employee_id, employee_name, create_time)
    VALUES
      (i, '天府通original' || to_char(i), sysdate);
    COMMIT;
    --DELETE FROM dba_test.tb_test WHERE ID = i;
  --COMMIT;
  END LOOP;

  -- Rename ddl event happened here, and some dml events happened on renamed table
  sql_stmt := 'alter table test_1 rename to test_bak';
  execute immediate sql_stmt;
  sql_stmt := 'select nvl(max(employee_id), 0) + 1 from dba_test.test_2';
	execute immediate sql_stmt into v_max_id;
  FOR I IN v_max_id .. v_max_id + 3 LOOP
    DBMS_LOCK.SLEEP(0.5);
    --DBMS_OUTPUT.PUT_LINE(to_char(i));
    sql_stmt := 'INSERT INTO dba_test.test_2 
      (employee_id, employee_name, create_time) 
    VALUES 
      (:1, :2, :3)';
		execute immediate sql_stmt using i , 	'天府通renamed' || to_char(i), sysdate;
    COMMIT;
    
  END LOOP;

  -- Rename back to original table
  sql_stmt := 'alter table test_2 rename to test_1';
  execute immediate sql_stmt;
  sql_stmt := 'select nvl(max(employee_id), 0) + 1 from dba_test.test_1';
	execute immediate sql_stmt into v_max_id;
  FOR I IN v_max_id .. v_max_id + 3 LOOP
    DBMS_LOCK.SLEEP(0.5);
    --DBMS_OUTPUT.PUT_LINE(to_char(i));
    sql_stmt := 'INSERT INTO dba_test.test_1 
      (employee_id, employee_name, create_time) 
    VALUES 
      (:1, :2, :3)';
	  execute immediate sql_stmt using i , 	'天府通renamebak' || to_char(i), sysdate;
    COMMIT;
    --DELETE FROM dba_test.tb_test WHERE ID = i;
  --COMMIT;
  END LOOP;
END;
/

```

When finished the above procedure, lookup kafka topics to check number of records.