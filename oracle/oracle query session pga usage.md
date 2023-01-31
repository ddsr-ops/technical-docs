select s.osuser osuser,s.serial# serial,se.sid,n.name, s.username,
max(se.value) maxmem
from v$sesstat se,
v$statname n
,v$session s
where n.statistic# = se.statistic#
and n.name in ('session pga memory','session pga memory max',
'session uga memory','session uga memory max')
and s.sid=se.sid and s.username = 'LOGMINER'
group by n.name,se.sid,s.osuser,s.serial#, s.username
order by 2;