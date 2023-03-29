Question: I see that there is a new disable_archive_logging parameter for Data Pump 12c.

 

Answer:  

One nice Oracle12c feature is the ability to run in nologging mode, disabling archive logging during a large import.   In this example we suppress the use of redo logs during the import:

impdp scott/tiger parfile=mypar.par transform=disable_archive_logging:y

In this example, we only suppress the redo generation for indexes during the import.  In this case, an abort would require manual rebuilding of the indexes.

impdp scott/tiger parfile=mypar.par transform=disable_archive_logging:y:index

Note:  When running with transform=disable_archive_logging, an abort will not roll-back and you will need to restore the table.  Hence, always take a backup of the target table before using the transform=disable_archive_logging option.

Oracle experts have noted that using the disable_archive_logging option results in a measurable improvement in import load times, making this an important performance tip.

Also note that disable_archive_logging will have no effect if the database is running in force logging  mode.

Oracle offers disable_archive_logging in Data Pump to simply disable the writing on archived redo logs, and thereby speeding-up export operations.  You can set disable_archive_logging at several levels, globally and for specific tables and indexes:

transform=disable_archive_logging:Y
transform=disable_archive_logging:Y:tablename
transform=disable_archive_logging:Y:indexname
Here is a sample invocation of Data Pump, a schema import that disables arching logging:

 

/u01/app/oracle> impdp dumpfile=pythian.dmp table_exists_action=append schemas=scott transform=disable_archive_logging:Y

In most cases you would want to run the disable archive logging parameter at the schemas level.