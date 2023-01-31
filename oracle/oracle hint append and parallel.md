```sql
insert /*+ parallel(t,8) append */into tft_ups.dc_trip_order_new t
select  * from tft_ups.dc_trip_order where update_time >= to_date('2022-03-10', 'yyyy-mm-dd') and update_time < to_date('2022-03-16', 'yyyy-mm-dd') ; 
```