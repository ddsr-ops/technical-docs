```sql
with t as
 (select ui.table_name,
         ui.index_name,
         ui.index_type,
         ui.uniqueness,
         to_char(wm_concat(uic.column_name)) as uq_col_name
    from user_indexes ui, user_ind_columns uic
   where ui.index_name = uic.index_name
     and ui.table_name = uic.table_name
     and uic.table_name in
         ('T_ACCOUNT_BANK_REFUND_RELATION',
          'T_ACCOUNT_ORDER_INFO',
          'T_ACCOUNT_REFUNDS_INFO',
          'T_BASE_CARD_DATA',
          'T_BINDING_CREDIT_CARD',
          'T_BLACK_CRYSTAL_CARD_DATA',
          'T_CARD_ACCOUNT_CANCEL',
          'T_CARD_TOPUP_INFO',
          'T_CHANGE_PHONE_INFO',
          'T_CLIENT_USER_INFO',
          'T_CONSUME_INFO',
          'T_DELETE_CARD_DATA',
          'T_DIGICCY_BILLS',
          'T_DIGICCY_SUB_WALLET_BILLS',
          'T_EINVOICE_INFO',
          'T_EINVOICE_ORDER_INFO',
          'T_HUAWEI_ESE_INFO',
          'T_LIFT_PAYCOST_ORDER_INFO',
          'T_PBOC_TOPUP_LOG',
          'T_QRCODE_APPLY_INFO',
          'T_REAL_AUTH',
          'T_SCAN_INFO',
          'T_SITE_INFO',
          'T_SP_OPEN_CARD_INFO',
          'T_SUBWALLET_BIND_RECORD',
          'T_SUBWALLET_UNBIND_RECORD',
          'T_TRADE',
          'T_TRADE_DETAILS',
          'T_TRADE_EXTEND',
          'T_TRADE_INFO',
          'T_TRADE_PAY_CHANNEL_INFO',
          'T_TRIP_REFUND_INFO',
          'T_USER_APP_HISTORY_INFO',
          'T_USER_LOGIN_LOG',
          'TACCT_BANK_REFUND_RELATION_LOG')
     and ui.uniqueness = 'UNIQUE'
   group by ui.table_name, ui.index_name, ui.index_type, ui.uniqueness)
select listagg('tft_tsm.' || lower(table_name) || ':' || lower(uq_col_name),
               ';') within group(order by table_name)
  from t;

select listagg('tft_tsm.' || lower(table_name), ',') within group(order by table_name)
  from (select table_name
          from user_tables
         where table_name in
               ('T_ACCOUNT_BANK_REFUND_RELATION',
                'T_ACCOUNT_ORDER_INFO',
                'T_ACCOUNT_REFUNDS_INFO',
                'T_BASE_CARD_DATA',
                'T_BINDING_CREDIT_CARD',
                'T_BLACK_CRYSTAL_CARD_DATA',
                'T_CARD_ACCOUNT_CANCEL',
                'T_CARD_TOPUP_INFO',
                'T_CHANGE_PHONE_INFO',
                'T_CLIENT_USER_INFO',
                'T_CONSUME_INFO',
                'T_DELETE_CARD_DATA',
                'T_DIGICCY_BILLS',
                'T_DIGICCY_SUB_WALLET_BILLS',
                'T_EINVOICE_INFO',
                'T_EINVOICE_ORDER_INFO',
                'T_HUAWEI_ESE_INFO',
                'T_LIFT_PAYCOST_ORDER_INFO',
                'T_PBOC_TOPUP_LOG',
                'T_QRCODE_APPLY_INFO',
                'T_REAL_AUTH',
                'T_SCAN_INFO',
                'T_SITE_INFO',
                'T_SP_OPEN_CARD_INFO',
                'T_SUBWALLET_BIND_RECORD',
                'T_SUBWALLET_UNBIND_RECORD',
                'T_TRADE',
                'T_TRADE_DETAILS',
                'T_TRADE_EXTEND',
                'T_TRADE_INFO',
                'T_TRADE_PAY_CHANNEL_INFO',
                'T_TRIP_REFUND_INFO',
                'T_USER_APP_HISTORY_INFO',
                'T_USER_LOGIN_LOG',
                'TACCT_BANK_REFUND_RELATION_LOG'))
```