Like Oracle function wm_concat and MySQL function group_concat.

```
df=spark.createDataFrame([(1,5,"This"),(2,10,"is"),(3,12,"a"),(1,7,"string"),(2,4,"oreo")],["usr","sec","scrpt"])

df.show()
#+---+---+------+
#|usr|sec| scrpt|
#+---+---+------+
#|  1|  5|  This|
#|  2| 10|    is|
#|  3| 12|     a|
#|  1|  7|string|
#|  2|  4|  oreo|
#+---+---+------+

df.groupBy("usr").agg(array_join(expr("""transform(sort_array(collect_list(struct(sec,scrpt)),True), x -> x.scrpt)""")," ").alias("concated")).orderBy("usr").show(10,False)

df.groupBy("usr").agg(concat_ws(" ",expr("""transform(sort_array(collect_list(struct(sec,scrpt)),True), x -> x.scrpt)""")).alias("concated")).orderBy("usr").show(10,False)
#+---+-----------+
#|usr|concated   |
#+---+-----------+
#|1  |This string|
#|2  |oreo is    |
#|3  |a          |
#+---+-----------+

#lower case
df.groupBy("usr").agg(lower(array_join(expr("""transform(sort_array(collect_list(struct(sec,scrpt)),True), x -> x.scrpt)""")," ")).alias("concated")).orderBy("usr").show(10,False)
#+---+-----------+
#|usr|concated   |
#+---+-----------+
#|1  |this string|
#|2  |oreo is    |
#|3  |a          |
#+---+-----------+
```

```
SELECT collect_set(col1), collect_list(col2) FROM VALUES (1, 1), (2, 4), (3, 3) AS tab(col1, col2);
[1,2]	[1,2,3]

select usr, transform(sort_array(collect_list(struct(sec, scrpt)), True), x -> x.scrpt) from VALUES (1, 5, "This"), (2, 10, "is"), (3, 12, "a"), (1, 7, "string"), (2, 4, "oreo") AS tab(usr, sec, scrpt) group by usr;
1	["This","string"]
3	["a"]
2	["oreo","is"]

select usr, concat_ws(", ", transform(sort_array(collect_list(struct(sec, scrpt)), True), x -> x.scrpt))
  from VALUES (1, 5, "This"), (2, 10, "is"), (3, 12, "a"), (1, 7, "string"), (2, 4, "oreo") AS tab(usr, sec, scrpt)
 group by usr;
1	This, string
3	a
2	oreo, is

select transform(sort_array(collect_list(struct(sec, scrpt)), True), x -> x.scrpt) from VALUES (1, 5, "This"), (2, 10, "is"), (3, 12, "a"), (1, 7, "string"), (2, 4, "oreo") AS tab(usr, sec, scrpt);
["oreo","This","string","is","a"]
```

```sql
select distinct order_status
from (select card_no,
             concat_ws(", ", transform(sort_array(collect_list(struct(update_time, order_status)), True),
                                       x-> x.order_status)) as order_status
      from (select *
            from (select card_no,
                         update_time,
                         order_status,
                         row_number() over(partition by card_no, order_status order by update_time desc) as rk
                  from hadoop_catalog.stg.t_tft_tsm_t_user_app_history_info) i
            where rk = 1) ii
      group by card_no) t
```