Ideally, the LogMiner dictionary file will be created after all database dictionary changes have been made and prior to the creation of any redo log files that are to be
analyzed. As of Oracle9i release 1 (9.0.1), you can use LogMiner to dump the LogMiner dictionary to the redo log files or a flat file, perform DDL operations, and
dynamically apply the DDL changes to the LogMiner dictionary.

So, when using dictionary from redo logs, only logs after the dictionary finished being built can be analyzed.
Additionally, DDL tracking capability takes effect after building dict. That`s why logfiles switch occur when building dict.

Moreover, do not run the DBMS_LOGMNR_D.BUILD procedure if there are any ongoing DDL operations.

LogMiner can mine online redo logs. However, if the CONTINUOUS_MINE option is not specified, it is possible that the database is writing to the online redo log file at the same time that LogMiner is reading the online redo log file. If a log switch occurs while LogMiner is reading an online redo log file, the database will
overwrite what LogMiner is attempting to read. The data that LogMiner returns if the file it is trying to read gets overwritten by the database is unpredictable.

Whenever dict from online_catalog(DICT_FROM_ONLINE_CATALOG) or redo_log_catalog(DICT_FROM_REDO_LOGS),
CONTINUOUS_MINE option is recommended to be specified.

| MODE                | DDL tracking  | Data Omit(MAYBE) |
| :----------------:  | :-----------: | :--------------: |
| REDO + CONTINUOUS   | YES           | NO               |
| REDO                | YES           | YES              |
| ONLINE + CONTINUOUS | NO            | NO               |
| ONLINE              | NO            | YES              |