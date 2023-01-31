As for catalog, it is logminer dictionary catalog, refer to Constants for START_LOGMNR Options Flag: DICT_FROM_REDO_LOGS, DICT_FROM_ONLINE_CATALOG

As to continuous, it is also Constants for START_LOGMNR Options Flag: CONTINUOUS_MINE

Catalog options: redo, online  
continuous options: yes, no  
Compatibility matrix between catalog and continuous option  
```
| redo   | yes   | ¡Á    | ORA-01371 (Complete LogMiner dictionary not found)  |
¢Ú| online | yes   | ¡Ì    | No DDL tracking ability                             | Daily running mode
¢Û| redo   | no    | ¡Ì    | DDL tracking, data omitting may occur               | When structure of captured tables need to be changed
| online | no    | ¡Ì    | No DDL tracking ability, data omitting may occur    |
```
The combination of redo catalog and continuous option, and the combination of online catalog and no continuous option are allowed to use.

Note:  
After finished ddl tracking, switch running mode from mode ¢Û to mode ¢Ú, refer to the local doc "oracle cdc table structure evolution.sql"
for more details.


References:
[V$ARCHIVED_LOG](https://docs.oracle.com/cd/E18283_01/server.112/e17110/dynviews_1016.htm)  
[DBMS_LOGMNR_D.BUILD](https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_logmnrd.htm#i77008)  
[DBMS_LOGMNR](https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_logmnr.htm#BHJHFAHC)

