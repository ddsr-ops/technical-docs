SELECT * FROM dba_test.tb_test;



TRUNCATE TABLE dba_test.tb_test;

SELECT * FROM v$session WHERE SID=1181 ;
SELECT spid FROM v$process WHERE addr='00000002DF6D6C08';

SELECT * FROM v$flash_recovery_area_usage;



