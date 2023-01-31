**This issue is not fixed.**

Scene description:

1. Same DB and sub-table  
2. Set the value of maxConnectionsSizePerQuery greater than 1
3. Assuming that a logical SQL will be split into two physical SQLs, in the scenario where maxConnectionsSizePerQuery is greater than 1, 
   two database connections will be created at this time. Two physical SQLs will eventually be executed in two database connections  
4. Assuming that there is a query statement next, it is possible that the latest data cannot be obtained 
   because of the wrong connection.

The core code is as follows:
ResourceManagedExecuteGroupEngine#generateSQLExecuteGroups

this is a demo:

```
conn.setAutocommit(false);
Statement stmt = conn.createStatement();

╱**
* 制造两个connection
* 1.connection1 update test_0 set name = 2 where id in (1,2);
* 2.connection2 update test_1 set name = 1 where id in (1,2);
*/
stmt.execute(  "UPDATE test set name=id WHERE id in (1,2) ");

/**
* 默认获取第一个connection:使用connection1查询connection1更新过的数据
*/
ResultSet rs = stmt.executeQuery("SELECT * FROM test WHERE id = 2");
while (rs.next()) {
  // id = 2, name=2
  System .out.println("id =" + ns.getString( columnLabel: "id"")+ "，name="+ ns.getString( columnLabel."name");

/**
* 默认获取第一个connection:使用connection1查询connection2更新过的数据
*/
rs = stmt.executeQuery("SELECT * FROM test WHERE id = 1"); 
while (rs.next()) {
  // id = 1, name=我是11
  Systen.out. pritin( id a" + 1s.getString(columnlsbelk "id )+ ", nane="+ 4s.getstring(icolmtLabel " nene" ));rs:“cou .uesql.oj .jitc .resol1 .ResultSe tl
}
```