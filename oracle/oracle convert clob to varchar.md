```sql
select ui.table_name,
       ui.index_name,
       ui.index_type,
       ui.uniqueness,
       to_char(wm_concat(uic.column_name)),
       dbms_lob.substr(wm_concat(uic.column_name), 4000)
  from user_indexes ui, user_ind_columns uic
 where ui.index_name = uic.index_name
   and ui.table_name = uic.table_name
   and ui.uniqueness = 'UNIQUE'
 group by ui.table_name, ui.index_name, ui.index_type, ui.uniqueness
```

Value from `wm_concat` function is clob type, convert it to varchar type with `to_char` or  `dbms_lob.substr` function.

Note: the length must be less than 4000, otherwise exceptions are thrown.