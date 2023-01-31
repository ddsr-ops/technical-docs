[官方参考链接](https://spark.apache.org/docs/3.0.0-preview/sql-ref-syntax-aux-refresh-table.html)

# Description  
REFRESH TABLE statement invalidates the cached entries, which include data and metadata of the given table or view. The invalidated cache is populated in lazy manner when the cached table or the query associated with it is executed again.

# Syntax  
REFRESH [TABLE] tableIdentifier
# Parameters
tableIdentifier
Specifies a table name, which is either a qualified or unqualified name that designates a table/view. If no database identifier is provided, it refers to a temporary view or a table/view in the current database.

**Syntax**: [database_name.]table_name

# Examples
```sql
-- The cached entries of the table will be refreshed  
-- The table is resolved from the current database as the table name is unqualified.
REFRESH TABLE tbl1;
-- The cached entries of the view will be refreshed or invalidated
-- The view is resolved from tempDB database, as the view name is qualified.  
REFRESH TABLE tempDB.view1;   
```
