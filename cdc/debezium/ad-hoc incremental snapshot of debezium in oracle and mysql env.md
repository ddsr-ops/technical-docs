# Background

Initial snapshot may bring much pressure on databases, which is unfriendly to databases.
For example, in such an oracle database environment, long query of initial snapshot may cause ORA-01555 errors.
So, investigation on incremental snapshots is essential to us.

# Principle

When signal of incremental snapshotting comes, connector would launch another a thread to handle it.
Firstly, primary keys or unique keys must be on the destination tables, otherwise, connector would break down with errors.
For splitting the whole table data into plenty of snippets, debezium pages the table data via the primary key or unique key. 
Pagination sql would bring little pressure, simultaneously with de-duplication in the related window of streaming.
If returned data is empty, snapshotting ends. As a proposal, primary keys or unique keys should be type of number which could be comparable correctly.

# Steps to activate incremental snapshots

In the official document, refer to "How the XXX connector works-snapshots" section.

The important thing is to grant enough privileges on the signal table to `database.user`, because the `database.user` writes some infos to the signal table.

## Create a connector

```json
{
     "name": "devora_adhoc3",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         "message.key.columns": "tft_tsm.t_account_refunds_info:refund_trandno;tft_tsm.t_binding_credit_card:userid,credit_card_no;tft_tsm.t_einvoice_info:order_no",
         "tasks.max" : "1",
         "database.server.name" : "devora_adhoc3",
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
         "table.include.list":"tft_tsm.t_account_refunds_info,tft_tsm.t_binding_credit_card,tft_tsm.t_einvoice_info,logminer.debezium_signal",
         "database.history.skip.unparseable.ddl": "true",
         "database.url": "jdbc:oracle:thin:@(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = 88.88.16.112)(PORT = 1521)))(CONNECT_DATA =(SERVER = DEDICATED)(SERVICE_NAME = ora11g)))",
         "database.history.kafka.bootstrap.servers" : "hadoop189:9093",
         "database.history.kafka.topic": "devora_adhoc3_his",
         "decimal.handling.mode": "string",
         "database.history.store.only.captured.tables.ddl": "true",
         "signal.data.collection":"ORA11G.LOGMINER.DEBEZIUM_SIGNAL"
     }
  }
```

Except for common configurations, add a configuration item named "signal.data.collection" which the format is dbname.schema.table in the oracle env.
**Note: the value of signal.data.collection is upper in the oracle connector. Signal table must be included in the `table.include.list`**

If the env is mysql, the format is schema.table.
Add the signal table to "table.include.list", then the connector could find and accept the signal of ad-hoc incremental snapshotting.

Mysql connector example is as follows:

```json
{ "name" : "mysql_0_adhoc3",
"config" : {
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "message.key.columns": "msx_online_bak.user_base_1025:user_id",
  "database.user": "root",
  "database.server.id": "12",
  "tasks.max": "1",
  "database.history.kafka.bootstrap.servers": "hadoop189:9093,hadoop190:9093,hadoop191:9093",
  "database.history.kafka.topic": "mysql_0_adhoc3.mysql_cdc_test",
  "database.server.name": "mysql_0_adhoc3",
  "database.port": "3306",
  "include.schema.changes": "true",
  "key.converter.schemas.enable": "false",
  "tombstones.on.delete": "false",
  "database.hostname": "88.88.16.113",
  "database.connectionTimeZone" : "LOCAL",
  "database.password": "root",
  "snapshot.mode": "schema_only",
  "value.converter.schemas.enable": "false",
  "database.history.skip.unparseable.ddl" : "true",
  "table.include.list": "msx_online_bak.user_base_1025,mysql_cdc_test.debezium_signal,dba_test.test2",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "database.history.store.only.captured.tables.ddl": "true",
  "signal.data.collection":"mysql_cdc_test.debezium_signal"
}
}

```

## Create a signal table

Create the table referenced in the signal.data.collection in the cdc database.

In the MySQL env:

```
 CREATE TABLE `debezium_signal` (
  `id` varchar(256) NOT NULL,
  `type` varchar(256) DEFAULT NULL,
  `data` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`)
)
```

In the Oracle env:

```
create table debezium_signal(id varchar2(256), type varchar2(256),
data varchar2(2048), primary key(id));
```

## Issue an order to activate adhoc snapshots 

In the MySQL env:

```
insert into debezium_signal values('ad-hoc-2', 'execute-snapshot', '{"data-collections": ["dba_test.test2"],"type":"incremental"}');
```

In the Oracle env:

```
insert into debezium_signal values('ad-hoc-1', 'execute-snapshot', '{"data-collections": ["ORA11G.TFT_TSM.T_ACCOUNT_REFUNDS_INFO","ORA11G.TFT_TSM.T_BINDING_CREDIT_CARD","ORA11G.TFT_TSM.T_EINVOICE_INFO"],"type":"INCREMENTAL"}');
commit;
```

For additional filter predicates:
```
insert into debezium_signal (ID, TYPE, DATA)
values ('ad-hoc-3', 'execute-snapshot', '{"data-collections": ["TFT_CSM.TFT_UO.T_USER_EXTEND"],"type":"INCREMENTAL",
 "additional-condition":"create_time > to_date(''2023-10-01'', ''yyyy-mm-dd'') AND channel_id IN (''CH20181123093619Y1FU'', ''CH202009101627571MIJ'')"}');
COMMIT;
```
> Tested for single table in Debezium 2.3, insert into multiple rows if taking incremental snapshots for multiple tables. In Debezium 2.3 later, support incremental snapshot of multiple tables by virtue of inserting one row into the signal table. For more details , refer to https://debezium.io/documentation/reference/2.4/connectors/oracle.html#oracle-incremental-snapshots 

**Note: the data-collections section of oracle differs from mysql.**

**Ensure the debezium_signal table is captured by Xstream engine if using the Xstream engine, otherwise, dml statements on the signal table can not be listened by Logminer so that incremental snapshot can not be triggered**

**Make sure the debezium_signal table can be manipulated by `database.user`, such select, update, insert privileges**


## Stop adhoc snapshots

```
insert into tft_ups.debezium_signal (ID, TYPE, DATA)
values ('ad-hoc-2', 'stop-snapshot', '{"data-collections": ["TFTUPS.TFT_UPS.DC_USE_DISCOUNT_FLOW","TFTUPS.TFT_UPS.CP_COUPON_RECORD"],"type":"INCREMENTAL"}');
commit;
```