Online Table Redefinition (DBMS_REDEFINITION) Enhancements in Oracle Database 11g Release 1
By default, online table redefinitions no longer invalidate dependent objects (PL/SQL, views, synonyms etc.), provided the redefinition does not logically affect them. An exception to this behavior is triggers, which are associated directly with a table.

* Setup
* Basic Online Table Redefinition
* Online Table Redefinition Including Dependents (COPY_TABLE_DEPENDENTS)

Related articles.

* Online Table Redefinition (DBMS_REDEFINITION)
* Online Table Redefinition (DBMS_REDEFINITION) Enhancements in Oracle Database 10g Release 1

# Setup
To see this new behaviour, first we must create a table with some dependent objects.

```sql
CONN test/test@db11g

DROP PROCEDURE get_description;
DROP VIEW redef_tab_v;
DROP SEQUENCE redef_tab_seq;
DROP TABLE redef_tab PURGE;

CREATE TABLE redef_tab (
  id           NUMBER,
  description  VARCHAR2(50),
  CONSTRAINT redef_tab_pk PRIMARY KEY (id)
);

CREATE VIEW redef_tab_v AS
SELECT * FROM redef_tab;

CREATE SEQUENCE redef_tab_seq;

CREATE OR REPLACE PROCEDURE get_description (
  p_id          IN  redef_tab.id%TYPE,
  p_description OUT redef_tab.description%TYPE) AS
BEGIN
  SELECT description
  INTO   p_description
  FROM   redef_tab
  WHERE  id = p_id;
END;
/

CREATE OR REPLACE TRIGGER redef_tab_bir
BEFORE INSERT ON redef_tab
FOR EACH ROW
WHEN (new.id IS NULL)
BEGIN
  :new.id := redef_tab_seq.NEXTVAL;
END;
/
```

If we check the status of the schema objects we can see that all of them are valid.

```sql
COLUMN object_name FORMAT A20
SELECT object_name, object_type, status FROM user_objects ORDER BY object_name;

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
GET_DESCRIPTION      PROCEDURE           VALID
REDEF_TAB            TABLE               VALID
REDEF_TAB_BIR        TRIGGER             VALID
REDEF_TAB_PK         INDEX               VALID
REDEF_TAB_SEQ        SEQUENCE            VALID
REDEF_TAB_V          VIEW                VALID

6 rows selected.
```

# Basic Online Table Redefinition
Now we perform an online table redefinition.

```sql
CONN sys/password@db11g AS SYSDBA

-- Check table can be redefined
EXEC DBMS_REDEFINITION.can_redef_table('TEST', 'REDEF_TAB');

-- Create new table
CREATE TABLE test.redef_tab2 (
  id           NUMBER,
  description  VARCHAR2(50)
);

-- Alter parallelism to desired level for large tables.
--ALTER SESSION FORCE PARALLEL DML PARALLEL 8;
--ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8;

-- Start Redefinition
EXEC DBMS_REDEFINITION.start_redef_table('TEST', 'REDEF_TAB', 'REDEF_TAB2');

-- Optionally synchronize new table with interim data before index creation
EXEC DBMS_REDEFINITION.sync_interim_table('TEST', 'REDEF_TAB', 'REDEF_TAB2'); 

-- Add new PK.
ALTER TABLE test.redef_tab2 ADD (CONSTRAINT redef_tab2_pk PRIMARY KEY (id));

-- Complete redefinition
EXEC DBMS_REDEFINITION.finish_redef_table('TEST', 'REDEF_TAB', 'REDEF_TAB2');

-- Remove original table which now has the name of the new table
DROP TABLE test.redef_tab2;

-- Rename the primary key constraint.
ALTER TABLE test.redef_tab RENAME CONSTRAINT redef_tab2_pk TO redef_tab_pk;
Finally, we re-check the status of the schema objects.

CONN test/test@db11g

COLUMN object_name FORMAT A20
SELECT object_name, object_type, status FROM user_objects ORDER BY object_name;

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
GET_DESCRIPTION      PROCEDURE           VALID
REDEF_TAB            TABLE               VALID
REDEF_TAB2_PK        INDEX               VALID
REDEF_TAB_SEQ        SEQUENCE            VALID
REDEF_TAB_V          VIEW                VALID

5 rows selected.

```
Notice that the GET_DESCRIPTION procedure and REDEF_TAB_V view are still valid, but the REDEF_TAB_BIR trigger is gone. 
The trigger was still associated with the original table, renamed to REDEF_TAB2, so when the original table was dropped, 
the trigger was dropped with it.

# Online Table Redefinition Including Dependents (COPY_TABLE_DEPENDENTS)
In addition to the dependency changes, the COPY_TABLE_DEPENDENTS procedure was added in Oracle 10g to copy grants, 
triggers, constraints and privileges from the source table to the interim table. 
In Oracle 11g the COPY_TABLE_DEPENDENTS procedure can optionally copy statistics and materialized view logs. 
Using this procedure may leave some of the dependent objects in an invalid state at the end of the redefinition process.

Recreate the trigger that was dropped by the previous redefinition, rerun the whole setup.
```sql
CREATE OR REPLACE TRIGGER redef_tab_bir
BEFORE INSERT ON redef_tab
FOR EACH ROW
WHEN (new.id IS NULL)
BEGIN
  :new.id := redef_tab_seq.NEXTVAL;
END;
/
```
Let's repeat the redefinition, but this time including a call to the COPY_TABLE_DEPENDENTS procedure. 
In this case we are not manually recreating the primary key constraints as this will be done by the procedure call.

```sql
CONN sys/password@db11g AS SYSDBA

-- Check table can be redefined
EXEC DBMS_REDEFINITION.can_redef_table('TEST', 'REDEF_TAB');

-- Create new table
CREATE TABLE test.redef_tab2 (
  id           NUMBER,
  description  VARCHAR2(50)
);

-- Alter parallelism to desired level for large tables.
--ALTER SESSION FORCE PARALLEL DML PARALLEL 8;
--ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8;

-- Start Redefinition
EXEC DBMS_REDEFINITION.start_redef_table('TEST', 'REDEF_TAB', 'REDEF_TAB2');

-- Optionally synchronize new table with interim data before index creation
EXEC DBMS_REDEFINITION.sync_interim_table('TEST', 'REDEF_TAB', 'REDEF_TAB2'); 

-- Copy dependents.
SET SERVEROUTPUT ON
DECLARE
  l_num_errors PLS_INTEGER;
BEGIN
  DBMS_REDEFINITION.copy_table_dependents(
    uname               => 'TEST',
    orig_table          => 'REDEF_TAB',
    int_table           => 'REDEF_TAB2',
    copy_indexes        => 1,             -- Default
    copy_triggers       => TRUE,          -- Default
    copy_constraints    => TRUE,          -- Default
    copy_privileges     => TRUE,          -- Default
    ignore_errors       => FALSE,         -- Default
    num_errors          => l_num_errors,
    copy_statistics     => FALSE,         -- Default
    copy_mvlog          => FALSE);        -- Default
    
  DBMS_OUTPUT.put_line('num_errors=' || l_num_errors); 
END;
/
   
-- Complete redefinition
EXEC DBMS_REDEFINITION.finish_redef_table('TEST', 'REDEF_TAB', 'REDEF_TAB2');

-- Remove original table which now has the name of the new table DROP TABLE
DROP TABLE test.redef_tab2;
```
We re-check the status of the schema objects.
```sql
CONN test/test@db11g

COLUMN object_name FORMAT A20
SELECT object_name, object_type, status FROM user_objects ORDER BY object_name;

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
GET_DESCRIPTION      PROCEDURE           VALID
REDEF_TAB            TABLE               VALID
REDEF_TAB2_PK        INDEX               VALID
REDEF_TAB_BIR        TRIGGER             INVALID
REDEF_TAB_SEQ        SEQUENCE            VALID
REDEF_TAB_V          VIEW                INVALID

6 rows selected.

SQL>
This time the trigger has not been lost, as it was cloned by the COPY_TABLE_DEPENDENTS procedure. Notice the trigger and view are both marked as invalid now. They can be recompiled as follows.

ALTER TRIGGER redef_tab_bir COMPILE;
ALTER VIEW redef_tab_v COMPILE;

COLUMN object_name FORMAT A20
SELECT object_name, object_type, status FROM user_objects ORDER BY object_name;

OBJECT_NAME          OBJECT_TYPE         STATUS
-------------------- ------------------- -------
GET_DESCRIPTION      PROCEDURE           VALID
REDEF_TAB            TABLE               VALID
REDEF_TAB2_PK        INDEX               VALID
REDEF_TAB_BIR        TRIGGER             VALID
REDEF_TAB_SEQ        SEQUENCE            VALID
REDEF_TAB_V          VIEW                VALID

6 rows selected.

```