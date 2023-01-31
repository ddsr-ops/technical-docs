# Reference
https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_logmnr.htm#i77269
https://docs.oracle.com/cd/B19306_01/server.102/b14215/logminer.htm


EXECUTE DBMS_LOGMNR_D.BUILD(OPTIONS=> DBMS_LOGMNR_D.STORE_IN_REDO_LOGS);

miningStrategy = "DBMS_LOGMNR.DICT_FROM_REDO_LOGS + DBMS_LOGMNR.DDL_DICT_TRACKING "
miningStrategy = "DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG "
miningStrategy += " + DBMS_LOGMNR.CONTINUOUS_MINE "

BEGIN sys.dbms_logmnr.start_logmnr(
                startScn => startScn,
                endScn => endScn,
                OPTIONS => miningStrategy + DBMS_LOGMNR.NO_ROWID_IN_STMT); END;

BEGIN sys.dbms_logmnr.start_logmnr(startTime => to_date('2022-08-17 15:00:00', 'yyyy-mm-dd hh24:mi:ss'),
    endTime => to_date('2022-08-17 15:20:00', 'yyyy-mm-dd hh24:mi:ss'),
	options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG + DBMS_LOGMNR.CONTINUOUS_MINE); end;   

BEGIN SYS.DBMS_LOGMNR.END_LOGMNR(); END;