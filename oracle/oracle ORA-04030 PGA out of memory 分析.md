oracle alert��־����ORA-04030����
```text
LOGMINER: StartScn: 252802096053 (0x003a.dc2ddbb5)
LOGMINER: EndScn: 252802096984 (0x003a.dc2ddf58)
LOGMINER: HighConsumedScn: 0
LOGMINER: session_flag: 0x0
LOGMINER: Read buffers: 8
LOGMINER: Memory LWM: limit 10M, LWM 8M, 80%
LOGMINER: Memory Release Limit: 0M
Errors in file /u01/app/oracle/diag/rdbms/tftups/tftups1/trace/tftups1_ora_110924.trc  (incident=105586):
ORA-04030: out of process memory when trying to allocate 8392728 bytes (krvxdups: priv,redo read buffer)
Incident details in: /u01/app/oracle/diag/rdbms/tftups/tftups1/incident/incdir_105586/tftups1_ora_110924_i105586.trc
Use ADRCI or Support Workbench to package the incident.
See Note 411.1 at My Oracle Support for error and packaging details.
Sat Aug 21 08:41:58 2021
Errors in file /u01/app/oracle/diag/rdbms/tftups/tftups1/trace/tftups1_ora_110924.trc  (incident=105587):
ORA-04030: out of process memory when trying to allocate 169040 bytes (pga heap,kgh stack)
ORA-04030: out of process memory when trying to allocate 8392728 bytes (krvxdups: priv,redo read buffer)
Incident details in: /u01/app/oracle/diag/rdbms/tftups/tftups1/incident/incdir_105587/tftups1_ora_110924_i105587.trc
Use ADRCI or Support Workbench to package the incident.
See Note 411.1 at My Oracle Support for error and packaging details.
Sat Aug 21 08:41:59 2021
Dumping diagnostic data in directory=[cdmp_20210821084159], requested by (instance=1, osid=110924), summary=[incident=105587].
Errors in file /u01/app/oracle/diag/rdbms/tftups/tftups1/incident/incdir_105586/tftups1_ora_110924_i105586.trc:
ORA-04030: out of process memory when trying to allocate 169040 bytes (pga heap,kgh stack)
ORA-04030: out of process memory when trying to allocate 8392728 bytes (krvxdups: priv,redo read buffer)
Errors in file /u01/app/oracle/diag/rdbms/tftups/tftups1/trace/tftups1_ora_110924.trc  (incident=105588):
ORA-04030: out of process memory when trying to allocate 82456 bytes (pga heap,control file i/o buffer)
ORA-04030: out of process memory when trying to allocate 8392728 bytes (krvxdups: priv,redo read buffer)
Incident details in: /u01/app/oracle/diag/rdbms/tftups/tftups1/incident/incdir_105588/tftups1_ora_110924_i105588.trc
Use ADRCI or Support Workbench to package the incident.
See Note 411.1 at My Oracle Support for error and packaging details.
Sat Aug 21 08:42:00 2021
Sweep [inc][105588]: completed
Sweep [inc][105587]: completed
Sweep [inc][105586]: completed
Sweep [inc2][105587]: completed
```

�鿴trace�ļ���ͬʱ��ע������Ҫ��Ϣ��
```text
*** 2021-08-20 10:29:34.227
*** SESSION ID:(4343.40633) 2021-08-20 10:29:34.227
*** CLIENT ID:() 2021-08-20 10:29:34.227
*** SERVICE NAME:(tftups) 2021-08-20 10:29:34.227
*** MODULE NAME:(JDBC Thin Client) 2021-08-20 10:29:34.227
*** ACTION NAME:() 2021-08-20 10:29:34.227
```
������Բ鿴�����漰�Ĳ�������

Investigation for mmap() syscall shows that ENOMEM stands for ��No memory is available, or the process��s maximum number of mappings would have been exceeded.��
In Linux apparently there seems to be max_map_count limit defined as follows:

The max_map_count file allows for the restriction of the number of VMAs (Virtual Memory Areas) that a particular process can own. A Virtual Memory Area is a contiguous area of virtual address space. These areas are created during the life of the process when the program attempts to memory map a file, links to a shared memory segment, or allocates heap space. Tuning this value limits the amount of these VMAs that a process can own. Limiting the amount of VMAs a process can own can lead to problematic application behavior because the system will return out of memory errors when a process reaches its VMA limit but can free up lowmem for other kernel uses. If your system is running low on memory in the NORMAL zone, then lowering this value will help free up memory for kernel use.
```text
Dumping Work Area Table (level=1)
=====================================
 
  Global SGA Info
  ---------------
 
    global target:    20096 MB
    auto target:      13577 MB
    max pga:           2048 MB
    pga limit:         4096 MB
    pga limit known:  0
    pga limit errors:     0
 
    pga inuse:         5009 MB
    pga alloc:         9071 MB
    pga freeable:       185 MB
    pga freed:        5220430 MB
    pga to free:          0 %
    broker request:       0
 
    pga auto:             0 MB
    pga manual:           0 MB
 
    pga alloc  (max):  9105 MB
    pga auto   (max):    58 MB
    pga manual (max):     0 MB
 
    # workareas     :     0
    # workareas(max):    18
```
���Կ���pga����Ϊ4096M��

��Ӧ����־�п�����ȷʵ����pga�ڴ治�㣺
```text
[2021-08-21 08:40:40,625] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3630.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:40:44,775] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3631.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:40:49,168] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3632.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:40:53,349] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3633.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:40:57,777] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3634.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:01,940] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3635.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:06,322] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3636.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:10,500] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3637.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:14,942] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3638.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:19,157] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3639.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:23,557] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3640.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:27,792] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3641.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:32,203] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3642.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:36,402] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3643.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:40,819] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3644.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:45,020] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3645.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:49,442] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3646.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
[2021-08-21 08:41:53,687] INFO Oracle Session UGA 43.51MB (max = 54.03MB), PGA 3647.13MB (max = 4095.94MB) (io.debezium.connector.oracle.logminer.LogMinerStreamingChangeEventSource:176)
```


***********************************************
***�����ǲο����˵İ�������***

����MOS�ĵ�PLSQL Procedure Causing ORA-04030: (pga heap,control file i/o buffer) And 
ORA-04030: (koh-kghu sessi,pmuccst: adt/record) or ORA-04030: (koh-kghucall ,pmucalm coll) Errors 
(�ĵ� ID 1325100.1)��˵����������Ϊ����ϵͳĬ�ϵ����������ֻ�ܴ�65530���ڴ�ӳ����Ŀ���Ƶġ�

```shell
[root@SL010A-NCDB1 ~]# cat /proc/sys/vm/max_map_count
65530
```

���ݿ�Ҳ�к�������Ӧ����������_realfree_heap_pagesize_hint��Ĭ����65536��

```text

col NAME for a30

col VALUE for a20

col DESCRIB for a45

set lines 200

SELECT x.ksppinm NAME, y.ksppstvl VALUE,x.ksppdesc describ
FROM SYS.x$ksppi x, SYS.x$ksppcv y
WHERE x.indx = y.indx AND x.ksppinm LIKE '%realfree%';
NAME                           VALUE                DESCRIB
10
------------------------------ -------------------- ---------------------------------------------
11
_realfree_heap_max_size        32768                minimum max total heap size, in Kbytes
12
_realfree_heap_pagesize_hint   65536                hint for real-free page size in bytes
13
_realfree_heap_mode            0                    mode flags for real-free heap
14
_use_realfree_heap             TRUE                 use real-free based allocator for PGA memory
```
_realfree_heap_pagesize_hin������������˼��realfree��ǰ�ķ����С��65536 bytes��Ҳ����64K��Ҳ�Ͷ�Ӧ����ϵͳ��ÿ���ڴ�ӳ����Ŀ���ڴ��С��64K��������ϵͳ��������ÿ����������ܴ�65530���ڴ�ӳ����Ŀ����ˣ�ÿ������ʹ��PGA�Ͳ��ܳ���4G��
```text
select 65536*65530/1024/1024/1024 GB  from dual;
 GB
3.99963379
```

��ô��Ӧ�ľ������ֽ��������һ���ǵ�������ϵͳ�������̴��ڴ�ӳ����Ŀ�Ĵ�С����һ�־��������ݿ������Ӧ�ķ��䵥Ԫ��С��

����ϵͳ�����������̴��ڴ�ӳ����Ŀ��С����Ҫ�޸�sysctl.conf�ļ���������������������һ�м��ɡ�


[root@SL010A-NCDB1 ~]# vi /etc/sysctl.conf

--��������������������

vm.max_map_count=262144
Ȼ��ͨ��sysctl �Cp����ʹ֮��Ч������ÿ��ӳ����Ŀ��С64K��262144����Ŀ����16G��Ӧ���㹻���ˡ�

���������ݿ����realfree�ķ��䵥Ԫ�Ĵ�С������������������Ǿ�̬��������Ҫ�������ݿ������Ч��

SQL> alter system set "_realfree_heap_pagesize_hint"=262144 scope=spfile;

System altered.
Ȼ���������ݿ⣬ʹ֮��Ч��

�������ַ������������޸Ĳ���ϵͳ�����ƻ����޸����ݿ�Ĳ�����ֻ�޸�һ���Ϳ��ã�������ַ������޸ģ���Ҫ���ú����ֵ�����ⵥ������ʹ�õ��ڴ����ƹ�����һ�и����̳������⣬����ֱ�ӾͰ��ڴ�ľ��ˡ�

�Ա���������������һ�ֽ����������Ȼֻ�Ա�������Ч����Ϊ������ORA-04030����������AUTO SQL TUNING���µģ���AUTO SQL TUNING����������ûɶ�ã���ȫ����ͨ������AUTO SQL TUNING�����������⡣����ͨ������ķ����ر�AUTO SQL TUNING��


BEGIN

dbms_auto_task_admin.disable(

client_name => 'sql tuning advisor',

operation => NULL,

window_name => NULL);

END;

/
�����Ҫ����AUTO SQL TUNING������ͨ������ķ�����������


BEGIN

dbms_auto_task_admin.enable(

client_name => 'sql tuning advisor',

operation => NULL,

window_name => NULL);

END;

/
��Ե�������ֻ��ʹ��4G��PGA���µ�ORA-04030��������⣬���廹Ҫ����ʲôԭ���µģ����������⣬������AUTO SQL TUNING�����ģ���AUTO SQL TUNING�����������ݿ�������ûʲô�ã����Կ���ͨ������AUTO SQL TUNING�ķ�ʽ������������ҵ�����Ĵ洢���̵�PL/SQL���µ�������󣬾Ͳ�����������ˣ�ֻ�ܴ�������޸Ĳ���ϵͳ�������̴��ڴ�ӳ����Ŀ�������޸����ݿ��Ӧ��ÿ��ӳ����Ŀ�ڴ�����С������ˡ�

http://blog.itpub.net/30317998/viewspace-2654931/