[reference](https://stackoverflow.com/questions/61528619/caused-by-java-lang-illegalargumentexception-cant-get-jdbc-type-for-null)

```text
val df1 =spark.sql(" select 1 as column1 , 2 column2 ,  NULL   as column3 from table  ")
  df1.show
df1.printSchema()
+-------+-------+-------+
|column1|column2|column3|
+-------+-------+-------+
|      1|      2|   null|
+-------+-------+-------+

root
 |-- column1: integer (nullable = false)
 |-- column2: integer (nullable = false)
 |-- column3: null (nullable = true)
```

Yeah, column3 jdbc type can not be gotten.

Solutions
```text
val df1 =spark.sql(
     " select 1 as column1 , 2 column2 , cast(NULL as smallint) as column3 from table  ")
  df1.show
df1.printSchema()
Result :

+-------+-------+-------+
|column1|column2|column3|
+-------+-------+-------+
|      1|      2|   null|
+-------+-------+-------+

root
 |-- column1: integer (nullable = false)
 |-- column2: integer (nullable = false)
 |-- column3: short (nullable = true)
```