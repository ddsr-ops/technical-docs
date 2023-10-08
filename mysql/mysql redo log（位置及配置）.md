# What's the redo log

The redo log in MySQL is stored in a circular buffer in memory and is periodically flushed to disk. It is not stored in a specific file on disk like the binary log.

The redo log in MySQL is stored in multiple files on disk called "redo log files". These files are typically named ib_logfile0, ib_logfile1, and so on. The exact naming convention and location of these files can vary depending on the MySQL configuration.

The names and locations of the redo log files in MySQL can be configured using the `innodb_log_group_home_dir` and `innodb_log_files_in_group` parameters in the MySQL configuration file (my.cnf or my.ini).

The `innodb_log_group_home_dir` parameter specifies the directory where the redo log files are stored. By default, it is set to the MySQL data directory.

The `innodb_log_files_in_group` parameter specifies the number of redo log files to use. By default, it is set to 2.

To change the names and locations of the redo log files, you can modify these parameters in the MySQL configuration file and restart the MySQL server for the changes to take effect.