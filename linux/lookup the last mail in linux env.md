Background

There may be plenty of mails in the mail box of linux. We aim at looking up the last mail.

```
& file <=============================================
"/var/spool/mail/root": 2064 messages 2050 unread
& 2064 <=============================================
Message 2064:
From root@namenode2.localdomain  Wed Jun  8 15:10:01 2022
Return-Path: <root@namenode2.localdomain>
......

& 2050 <=============================================
Message 2050:
From root@namenode2.localdomain  Wed Jun  8 14:00:01 2022
Return-Path: <root@namenode2.localdomain>
......

```

There are 2064 mails in total, 2050 of all are unread. We input 2064 to lookup the last mail, input 2050 to read the last unread mail.