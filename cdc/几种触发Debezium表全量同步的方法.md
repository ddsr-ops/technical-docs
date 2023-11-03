[伪更新触发记录更新](伪更新触发日志记录Oracle,MySQL.md)
[ad-hoc incremental snapshot](debezium/ad-hoc%20incremental%20snapshot%20of%20debezium%20in%20oracle%20and%20mysql%20env.md)

# Dummy DML

Issuing dummy update statements in database produce dml events which can be captured by Debezium Plugin.

## Advantages

* Filter rows you want by virtue of updating specific rows
* Update rate you can control

## Disadvantages

* Produce unnecessary dml log events
* Some tables do not support this way due to no suitable columns for dummy update especially in MySQL scope, because any columns updated incur side-effect on applications  
* Intrusiveness to database


# Ad-hoc incremental snapshot

As I know, from Debezium 2.3, Debezium supports adding additional `where` predicates to the tables on which you issue incremental snapshots.

For example, I want to snapshot one table with additional filter conditions.

```sql
insert into debezium_signal (ID, TYPE, DATA)
values ('ad-hoc-3', 'execute-snapshot', '{"data-collections": ["TFT_CSM.TFT_UO.T_USER_EXTEND"],"type":"INCREMENTAL",
 "additional-condition":"create_time > to_date(''2023-10-01'', ''yyyy-mm-dd'') AND channel_id IN (''CH20181123093619Y1FU'', ''CH202009101627571MIJ'')"}');
```

# Advantages

* Fetch rate you can control, refer to the official docs for more details
* Read the snapshot table chunk by chunk, resolving the conflicts between read events and  streaming events corresponding to the table

# Disadvantages

* More configuration: Another signal table or signal kafka topic is needed to populate the signal event


# Summarization

In summary, recommend to engage the second method to perform the incremental snapshot.