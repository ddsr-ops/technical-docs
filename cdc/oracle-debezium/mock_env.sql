SELECT * FROM dba_test.tb_test;
SELECT COUNT(*) FROM dba_test.tb_test;



TRUNCATE TABLE dba_test.tb_test;

SELECT * FROM v$session WHERE SID=1190 ;
SELECT spid FROM v$process WHERE addr='00000002DF6A4988';

SELECT * FROM v$flash_recovery_area_usage;

TRUNCATE TABLE dba_test.tb_test;
INSERT INTO dba_test.tb_test VALUES (1, '天府通1');
INSERT INTO dba_test.tb_test VALUES (2, '天府通2');
COMMIT;
UPDATE dba_test.tb_test SET NAME = 'tianfuton2' WHERE ID = 2;
COMMIT;
DELETE FROM dba_test.tb_test WHERE ID = 2;
COMMIT;
