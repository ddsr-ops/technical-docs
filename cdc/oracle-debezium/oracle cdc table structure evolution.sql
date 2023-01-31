SELECT COUNT(*) FROM DBA_TEST.TB_TEST;

TRUNCATE TABLE DBA_TEST.TB_TEST;

-- Note: log_mining_strategy is used in conjunction with need_restart_mining_session
-- Note: log_mining_strategy is used in conjunction with need_restart_mining_session
-- Note: log_mining_strategy is used in conjunction with need_restart_mining_session

-- pga_limit is dynamically controlled whenever you update it.


/* 1. Before table structure evolution, Needs to restart mining session in redo_log_catalog mode manually. */
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
		TS = SYSDATE;
COMMIT;

/* 2. Make sure mining session has been restarted. 
 * Check connect.log in KAFKA_HOME/logs, information like 'Closed the switch of manual restarting mining.' arising 
 * indicates mining session has been restarted successfully.
 * Simultaneously, Lookup logminer.log_mining_config, need_restart_mining_session value has turned into 'no'.
 */
SELECT NEED_RESTART_MINING_SESSION FROM LOGMINER.LOG_MINING_CONFIG;

/**
 * 3. Mock table structure changes, and some dml statements.
 */
ALTER TABLE DBA_TEST.TB_TEST ADD REMARK VARCHAR2(32);
INSERT INTO DBA_TEST.TB_TEST(REMARK) VALUES('DDL FROM MOCK');
COMMIT;
ALTER TABLE DBA_TEST.TB_TEST DROP COLUMN REMARK;


/* 4. Commonly, need to revert strategy to online_catalog after table structure evolution.
   If you do not set log_mining_strategy to online_catalog, connector will generate more redo log files(archive log files)*/
UPDATE LOGMINER.LOG_MINING_CONFIG T
SET T.LOG_MINING_STRATEGY = 'ONLINE_CATALOG',
    T.NEED_RESTART_MINING_SESSION = 'YES',
		TS = SYSDATE;
COMMIT;



/**
SELECT * FROM LOG_MINING_CONFIG;

UPDATE LOG_MINING_CONFIG T SET T.NEED_RESTART_MINING_SESSION = 'YES', TS = SYSDATE;
COMMIT;

UPDATE LOG_MINING_CONFIG T SET T.PGA_LIMIT = 100, TS = SYSDATE;
COMMIT;

UPDATE LOG_MINING_CONFIG T SET T.LOG_MINING_STRATEGY = 'ONLINE_CATALOG', TS = SYSDATE;
COMMIT;

UPDATE LOG_MINING_CONFIG T SET T.LOG_MINING_STRATEGY = 'REDO_LOG_CATALOG', TS = SYSDATE;
COMMIT;
*/
