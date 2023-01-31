```
Requested 'INCREMENTAL' snapshot of data collections '[TFTONG.TFT_TSM.T_TRIP_ORDER_EXP_CANCEL_RECORD]' (io.debezium.pipeline.signal.ExecuteSnapshot:53)
[2022-09-01 15:09:58,579] WARN Schema not found for table 'TFTONG.TFT_TSM.T_TRIP_ORDER_EXP_CANCEL_RECORD', known tables [TFTONG.TFT_TSM.T_ACCOUNT_REFUNDS_INFO, TFTONG.LOGMINER.DEBEZIUM_SIGNAL, TFTONG.TFT_TSM.EIV_INVOICE_EMAIL, TFTONG.TFT_TSM.T_CARD_TOPUP_COUNT_INFO, TFTONG.TFT_TSM.T_TRIP_ORDER_EXPORT_EMAIL, TFTONG.TFT_TSM.T_BINDING_CREDIT_CARD, TFTONG.TFT_TSM.T_OPENID_ALIUSER, TFTONG.TFT_TSM.T_CREDIT_REMOVE_RECORD, TFTONG.TFT_TSM.T_REAL_AUTH, TFTONG.TFT_TSM.T_TRIP_ORDER_EXPORT_RECORD, TFTONG.TFT_TSM.T_EINVOICE_INFO, TFTONG.TFT_TSM.EIV_INVOICE_EMAIL_PUSHRECORD] (io.debezium.pipeline.source.snapshot.incremental.AbstractIncrementalSnapshotChangeEventSource:326)
```

Because no data updating(or any dml statements) happened , the connector can not known the schema
of the destination table. 

For easy, we can mock an update statement on the destination table to ensure the connector acquire
the schema structure . 

```sql
update T_TRIP_ORDER_EXP_CANCEL_RECORD set cancel_reason = '≤‚ ‘' where id = 'a99d953ec8424167bfbc4f9cf122681c';
commit;
```
The values of cancel_reason is the same after it was updated.