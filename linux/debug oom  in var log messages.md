log info in /var/log/messages

```
Jul 28 05:01:01 datanode1 systemd: Starting Session 18107 of user root.
Jul 28 05:06:23 datanode1 kernel: java invoked oom-killer: gfp_mask=0x280da, order=0, oom_score_adj=0
Jul 28 05:06:23 datanode1 kernel: java cpuset=/ mems_allowed=0-1
Jul 28 05:06:23 datanode1 kernel: CPU: 62 PID: 249358 Comm: java Kdump: loaded Not tainted 3.10.0-862.el7.x86_64 #1
Jul 28 05:06:23 datanode1 kernel: Hardware name: Dell Inc. PowerEdge R740/04FC42, BIOS 2.7.7 05/04/2020
Jul 28 05:06:23 datanode1 kernel: Call Trace:
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98d0d768>] dump_stack+0x19/0x1b
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98d090ea>] dump_header+0x90/0x229
Jul 28 05:06:23 datanode1 kernel: [<ffffffff986f76e2>] ? ktime_get_ts64+0x52/0xf0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98797904>] oom_kill_process+0x254/0x3d0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff987973ad>] ? oom_unkillable_task+0xcd/0x120
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98797456>] ? find_lock_task_mm+0x56/0xc0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98798146>] out_of_memory+0x4b6/0x4f0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff9879ea64>] __alloc_pages_nodemask+0xaa4/0xbb0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff987ebd65>] alloc_pages_vma+0xb5/0x200
Jul 28 05:06:23 datanode1 kernel: [<ffffffff987c57ec>] handle_pte_fault+0x7ec/0xc30
Jul 28 05:06:23 datanode1 kernel: [<ffffffff987c747d>] handle_mm_fault+0x39d/0x9b0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98d1a597>] __do_page_fault+0x197/0x4f0
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98d1a925>] do_page_fault+0x35/0x90
Jul 28 05:06:23 datanode1 kernel: [<ffffffff98d16768>] page_fault+0x28/0x30
Jul 28 05:06:23 datanode1 kernel: Mem-Info:
Jul 28 05:06:23 datanode1 kernel: active_anon:30401367 inactive_anon:1337226 isolated_anon:0#012 active_file:2966 inactive_file:1959 isolated_file:182#012 unevictable:0 dirty:140 writeback:85 unstable:0#012 slab_reclaimable:407195 slab_unreclaimable:95916#012 mapped:1006 shmem:15671 pagetables:103807 bounce:0#012 free:89421 free_pcp:907 free_cma:0
Jul 28 05:06:23 datanode1 kernel: Node 0 DMA free:14724kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:36kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Jul 28 05:06:23 datanode1 kernel: lowmem_reserve[]: 0 1416 63853 63853
Jul 28 05:06:23 datanode1 kernel: Node 0 DMA32 free:250840kB min:992kB low:1240kB high:1488kB active_anon:245332kB inactive_anon:245436kB active_file:256kB inactive_file:276kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1690624kB managed:1450588kB mlocked:0kB dirty:0kB writeback:0kB mapped:8kB shmem:0kB slab_reclaimable:602432kB slab_unreclaimable:51808kB kernel_stack:21616kB pagetables:2732kB unstable:0kB bounce:0kB free_pcp:552kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:56 all_unreclaimable? no
Jul 28 05:06:23 datanode1 kernel: lowmem_reserve[]: 0 0 62436 62436
Jul 28 05:06:23 datanode1 kernel: Node 0 Normal free:44308kB min:43840kB low:54800kB high:65760kB active_anon:59839348kB inactive_anon:2493108kB active_file:4188kB inactive_file:1064kB unevictable:0kB isolated(anon):0kB isolated(file):216kB present:65011712kB managed:63935376kB mlocked:0kB dirty:4kB writeback:0kB mapped:0kB shmem:4644kB slab_reclaimable:473364kB slab_unreclaimable:135276kB kernel_stack:57232kB pagetables:171836kB unstable:0kB bounce:0kB free_pcp:920kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:474 all_unreclaimable? no
Jul 28 05:06:23 datanode1 kernel: lowmem_reserve[]: 0 0 0 0
Jul 28 05:06:23 datanode1 kernel: Node 1 Normal free:47812kB min:45264kB low:56580kB high:67896kB active_anon:61520788kB inactive_anon:2610360kB active_file:7420kB inactive_file:6308kB unevictable:0kB isolated(anon):0kB isolated(file):512kB present:67108864kB managed:66012892kB mlocked:0kB dirty:556kB writeback:340kB mapped:4896kB shmem:58040kB slab_reclaimable:552984kB slab_unreclaimable:196544kB kernel_stack:73488kB pagetables:240660kB unstable:0kB bounce:0kB free_pcp:2056kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:3390 all_unreclaimable? no
Jul 28 05:06:23 datanode1 kernel: lowmem_reserve[]: 0 0 0 0
Jul 28 05:06:23 datanode1 kernel: Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 1*2048kB (M) 3*4096kB (UM) = 14724kB
Jul 28 05:06:23 datanode1 kernel: Node 0 DMA32: 3931*4kB (UE) 1701*8kB (UEM) 2963*16kB (EM) 3314*32kB (UEM) 1004*64kB (UEM) 30*128kB (UEM) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 250884kB
Jul 28 05:06:23 datanode1 kernel: Node 0 Normal: 11912*4kB (UEM) 13*8kB (UM) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 47752kB
Jul 28 05:06:23 datanode1 kernel: Node 1 Normal: 12024*4kB (UEM) 397*8kB (UEM) 2*16kB (U) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 51304kB
Jul 28 05:06:23 datanode1 kernel: Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
Jul 28 05:06:23 datanode1 kernel: Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Jul 28 05:06:23 datanode1 kernel: Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
Jul 28 05:06:23 datanode1 kernel: Node 1 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Jul 28 05:06:23 datanode1 kernel: 227965 total pagecache pages
Jul 28 05:06:23 datanode1 kernel: 205753 pages in swap cache
Jul 28 05:06:23 datanode1 kernel: Swap cache stats: add 722115745, delete 721290388, find 651560362/729841956
Jul 28 05:06:23 datanode1 kernel: Free swap  = 0kB
Jul 28 05:06:23 datanode1 kernel: Total swap = 33554428kB
Jul 28 05:06:23 datanode1 kernel: 33456799 pages RAM
Jul 28 05:06:23 datanode1 kernel: 0 pages HighMem/MovableOnly
Jul 28 05:06:23 datanode1 kernel: 603108 pages reserved
Jul 28 05:06:23 datanode1 kernel: [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
Jul 28 05:06:23 datanode1 kernel: [ 1066]     0  1066     9865     1341      24       40             0 systemd-journal
Jul 28 05:06:23 datanode1 kernel: [ 1090]     0  1090    49631       54      30       57             0 lvmetad
Jul 28 05:06:23 datanode1 kernel: [322843]   984 322843     2924       64      11        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [322845]   984 322845     2924       65      11        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [322919]   984 322919   680061   122733     518       39             0 java
Jul 28 05:06:23 datanode1 kernel: [323425]   984 323425     2922       56      10        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [323428]   984 323428     2922       61      11        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [323500]   984 323500   540875    93765     381       94             0 java
Jul 28 05:06:23 datanode1 kernel: [53549]     0 53549 14994038 10068578   27987     8552             0 palo_be  <============
Jul 28 05:06:23 datanode1 kernel: [169339]    89 169339    22437      251      45        0             0 pickup
Jul 28 05:06:23 datanode1 kernel: [208046]   984 208046     2923       58      11        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [208048]   984 208048     2923       57      11        0             0 bash
Jul 28 05:06:23 datanode1 kernel: [269425]     0 269425  9220372     2430     103        0             0 java
Jul 28 05:06:23 datanode1 kernel: [269475]   981 269475    32450     3631      18       42             0 hbase.sh
Jul 28 05:06:23 datanode1 kernel: Out of memory: Kill process 53549 (palo_be) score 237 or sacrifice child <============
Jul 28 05:06:23 datanode1 kernel: Killed process 53549 (palo_be) total-vm:59976152kB, anon-rss:40274312kB, file-rss:0kB, shmem-rss:0kB <============
Jul 28 05:06:30 datanode1 systemd-logind: Removed session 18076.
Jul 28 05:10:05 datanode1 systemd-logind: New session 18108 of user root.
Jul 28 05:10:05 datanode1 systemd: Started Session 18108 of user root.
Jul 28 05:10:05 datanode1 systemd: Starting Session 18108 of user root.
```

Usually, Os would kill the process which consumes the most resource.
Again, this probably won't do much more than illuminate the obvious: the system ran out of memory and mysqld was choosen to die because killing it would release the most resources.

* pid The process ID.
* uid User ID.
* tgid Thread group ID.
* total_vm Virtual memory use (in 4 kB pages)
* rss Resident memory use (in 4 kB pages)
* nr_ptes Page table entries
* swapents Swap entries
* oom_score_adj Usually 0; a lower number indicates the process will be less likely to die when the OOM killer is invoked.

[reference](https://unix.stackexchange.com/questions/128642/debug-out-of-memory-with-var-log-messages)