# Error log

```
2023-02-27T06:30:12.252069Z 62 [Note] InnoDB: Uncompressed page, stored checksum in field1 4061189368, calculated checksums for field1: crc32 1251409263/2865533183, innodb 2127272071, none 3735928559, stored checksum in field2 4061189368, calculated checksums for field2: crc32 1251409263/2865533183, innodb 1245538177, none 3735928559,  page LSN 24 218397265, low 4 bytes of LSN at page end 218397265, page number (if stored to page already) 55310, space id (if created with >= MySQL-4.1.1 and stored already) 152
InnoDB: Page may be an index page where index id is 278
2023-02-27T06:30:12.252082Z 62 [Note] InnoDB: Index 278 is `PRIMARY` in table `frms-xxl-job`.`xxl_job_log`
2023-02-27T06:30:12.252088Z 62 [Note] InnoDB: It is also possible that your operating system has corrupted its own file cache and rebooting your computer removes the error. If the corrupt page is an index page. You can also try to fix the corruption by dumping, dropping, and reimporting the corrupt table. You can use CHECK TABLE to scan your table for corruption. Please refer to http://dev.mysql.com/doc/refman/5.7/en/forcing-innodb-recovery.html for information about forcing recovery.
2023-02-27T06:30:12.252162Z 62 [ERROR] InnoDB: Database page corruption on disk or a failed file read of page [page id: space=152, page number=55310]. You may have to recover from a backup.
2023-02-27T06:30:12.252167Z 62 [Note] InnoDB: Page dump in ascii and hex (16384 bytes):
```

# Solution

drop table `frms-xxl-job`.`xxl_job_log`; 