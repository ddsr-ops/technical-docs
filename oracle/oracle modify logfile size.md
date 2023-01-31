alter database add logfile group 7 '/u01/app/oracle/oradata/ora11g/redo07.log' size 2G;
alter database add logfile group 8 '/u01/app/oracle/oradata/ora11g/redo08.log' size 2G;
alter database add logfile group 9 '/u01/app/oracle/oradata/ora11g/redo09.log' size 2G;
alter database add logfile group 10 '/u01/app/oracle/oradata/ora11g/redo10.log' size 2G;
alter database add logfile group 11 '/u01/app/oracle/oradata/ora11g/redo11.log' size 2G;

alter system switch logfile;
alter system checkpoint;

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;
alter database drop logfile group 4;
alter database drop logfile group 5;
alter database drop logfile group 6;