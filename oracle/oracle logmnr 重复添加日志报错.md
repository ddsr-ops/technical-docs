begin
   DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+FLASH_DG/tftups/archivelog/2022_03_24/thread_1_seq_9443.1823.1100188581',OPTIONS => DBMS_LOGMNR.NEW);
end;
/
-- 后续日志文件添加，则使用ADDFILE
begin
   DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+FLASH_DG/tftups/archivelog/2022_03_25/thread_2_seq_7988.2948.1100266735',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/
-- thread_2_seq_7988.2948.1100266735 and group_4.270.1034813965 are the same log file, failed to add it.
begin
   DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+DATA_DG/tftups/onlinelog/group_4.270.1034813965',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/

-- Can not add duplicated log file entry
begin
   DBMS_LOGMNR.ADD_LOGFILE(LOGFILENAME =>'+FLASH_DG/tftups/archivelog/2022_03_24/thread_2_seq_7954.1799.1100188457',OPTIONS => DBMS_LOGMNR.ADDFILE);
end;
/

begin
   DBMS_LOGMNR.end_logmnr();
end;
/

select * from v$logmnr_logs;