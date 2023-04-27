When using Xstream core in Oracle connector, the interoperability of Oracle instance client and Debezium version
are described as follows.

# Case one:

* instantclient_19_6
* Debezium Oracle version: 2.3.0

Note: Connect service using ojdbc8.jar and xstream.jar which come from the instantclient_19_6.

```sql
create table TB_TEST10
(
  id   NUMBER,
  name VARCHAR2(2048),
  dt   DATE,
  ts   TIMESTAMP(6),
  ts1  TIMESTAMP(6) WITH TIME ZONE,
  ts2  TIMESTAMP(6) WITH LOCAL TIME ZONE
);

insert into tb_test10 values(2, 'tft2', sysdate, systimestamp, systimestamp, systimestamp);
commit;
```

ORA-26824: user-defined XStream callback error

Refer to Case two to solve it.

# Case two:

* instantclient_21_10
* Debezium Oracle version: 2.3.0

Note: Connect service using ojdbc8.jar and xstream.jar which come from the instantclient_21_10.

ORA-26824 can be conquered by instantclient_21_10

In details, ORA-26824 occurs when the connector is handling `ts1` field whose data type is supported by Xstream.  
Lookup path: io.debezium.connector.oracle.OracleValueConverters#fromOracleTimeClasses ==> data = ts.toZonedDateTime()