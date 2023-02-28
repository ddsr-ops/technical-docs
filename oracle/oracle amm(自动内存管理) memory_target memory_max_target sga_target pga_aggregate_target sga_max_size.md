Oracle 9i引入pga_aggregate_target，值为0可以自动对PGA进行调整；

Oracle 10g引入sga_target，值为0可以自动对SGA进行调整；

Oracle 11g则对这两部分进行综合，引入memory_target，可以自动调整所有的内存，这就是新引入的自动内存管理特性。

自动内存管理是用两个初始化参数进行配置的：

MEMORY_TARGET：动态控制SGA和PGA时，Oracle总共可以使用的共享内存大小，这个参数是动态的，因此提供给Oracle的内存总量是可以动态增大，也可以动态减小的。
它不能超过MEMORY_MAX_TARGET参数设置的大小。默认值是0。    
MEMORY_MAX_TARGET：这个参数定义了MEMORY_TARGET最大可以达到而不用重启实例的值，如果没有设置MEMORY_MAX_TARGET值，默认等于MEMORY_TARGET的值。
使用动态内存管理时，SGA_TARGET和PGA_AGGREGATE_TARGET代表它们各自内存区域的最小设置，*要让Oracle完全控制内存管理，这两个参数应该设置为0*。

MEMORY_MAX_TARGET是一个非动态参数，不能在memory范围动态改变，只能通过指明 scope=spfile这个条件来达到数据库在下次启动后让改变生效的目的。
但是MEMORY_TARGET这个参数是可以动态调节的...也就是说不需要重新启动DB，就可以让其生效。

MEMORY_MAX_TARGET 是设定Oracle能占OS多大的内存空间，SGA_MAX_SIZE是Oracle SGA 区最大能占多大内存空间.
10g 的SGA_MAX_SIZE 是动态分配 Shared Pool Size,database buffer cache,large pool,javapool，redo log buffer 大小的上限值，是根据Oracle 运行状况来重新分配SGA各内存块的大小。
PGA在10g中需要单独设定。 11g MEMORY_MAX_TARGET 参数包含SGA和PGA两部分。

MEMORY_MAX_TARGET : oracle内存的最大值能达到的上限。非动态可调。如果没有指定，默认和MEMORY_TARGET等同。

在手动创建数据库时，只需要在创建数据库之前设置合适的MEMORY_TARGET和MEMORY_MAX_TARGET初始化参数。


下面来看看在11G中MEMORY_TARGET设置和不设置对SGA/PGA 的影响：

## 如果 MEMORY_TARGET 设置为非 0 值

1. 如果 ORACLE 中已经设置了参数 SGA_TARGET 和 PGA_AGGREGATE_TARGET ，则这两个参数将按照granule各自被分配为最小值为它们的目标值。
例如`alter system set sga_target = 500M scope=spfile;`设置后的SGA_TARGET值为512M。

2. SGA_TARGET 和 PGA_AGGREGATE_TARGET 都没有设置大小 ORACLE 11G中对这种 SGA_TARGET 和 PGA_AGGREGATE_TARGET 都没有设定大小的情况下，
   ORACLE 将对这两个值没有最小值和默认值。 ORACLE 将根据数据库运行状况进行分配大小。 但在数据库启动是会有一个固定比例来分配：
   > SGA_TARGET =MEMORY_TARGET *60%  
   > PGA_AGGREGATE_TARGET=MEMORY_TARGET *40%



## 如果 MEMORY_TARGET没有设置或 =0

  11G中默认为 0 则初始状态下取消了 MEMORY_TARGET 的作用，完全和 10G 在内存管理上一致，完全向下兼容。

1. SGA_TARGET 设置值，则自动调节 SGA 中的 SHARED POOL,BUFFER CACHE,REDO LOG BUFFER,JAVA POOL,LARGER POOL等内存空间的大小。
 PGA 则依赖 PGA_AGGREGATE_TARGET 的大小。 SGA 和 PGA 不能自动增长和自动缩小。

2. SGA_TARGET 和 PGA_AGGREGATE_TARGET 都没有设置，并且MEMORY_TARGET和MEMORY_MAX_TARGET均没设置，实例则无法启动，报错误码ORA-00849
SGA 中的各组件大小都要明确设定，不能自动调整各组建大小。 PGA 不能自动增长和收缩。

3. MEMORY_MAX_TARGET 设置 而 MEMORY_TARGET =0，也能正常启动示例，SGA_TARGET=0, PGA_AGGREGATE_TARGE=16M。


在11g 中可以使用下面看各组件的值

SQL> show parameter target

如果需要监视 Memory_target 的状况则可以使用下面三个动态试图：

* V$MEMORY_DYNAMIC_COMPONENTS

* V$MEMORY_RESIZE_OPS

* V$MEMORY_TARGET_ADVICE



使用下面 Command 来调节大小：

SQL>ALTER SYSTEM SET MEMORY_MAX_TARGET = 1024M SCOPE = SPFILE;

SQL>ALTER SYSTEM SET MEMORY_TARGET = 1024M SCOPE = SPFILE;

SQL>ALTER SYSTEM SET SGA_TARGET =0 SCOPE = SPFILE;

SQL>ALTER SYSTEM SET PGA_AGGREGATE_TARGET = 0 SCOPE = SPFILE ;


# 相关视图查询SQL
```
select m.COMPONENT,m.OPER_TYPE,m.OPER_MODE,m.PARAMETER,m.INITIAL_SIZE/1024/1024/1024 初始值GB,
M.TARGET_SIZE/1024/1024/1024 目标值GB,m.FINAL_SIZE/1024/1024/1024 最终值GB,
TO_CHAR(M.START_TIME,'YYYY-MM-DD HH24:MI:SS') 开始时间,
TO_CHAR(M.END_TIME,'YYYY-MM-DD HH24:MI:SS') 结束时间
from V$MEMORY_RESIZE_OPS m
where m.COMPONENT in ('PGA Target','SGA Target');--包含最近完成的800  个内存大小调整请求的循环历史记录缓冲区

select MDC.COMPONENT,
mdc.CURRENT_SIZE/1024/1024/1024 当前大小GB,
MDC.MIN_SIZE/1024/1024/1024 最小值GB,
MDC.MAX_SIZE/1024/1024/1024 最大值GB,
MDC.OPER_COUNT,
MDC.LAST_OPER_TYPE,
MDC.LAST_OPER_MODE,
to_char(MDC.LAST_OPER_TIME,'yyyy-mm-dd hh24:mi:ss') 最后操作时间,
MDC.GRANULE_SIZE/1024/1024 调整颗粒MB
FROM V$MEMORY_DYNAMIC_COMPONENTS MDC;--包含所有内存组件的当前状态

select * from  V$MEMORY_TARGET_ADVICE;--提供针对MEMORY_TARGET 初始化参数的优化建议
```

# SGA PGA说明

sga：包含实例的数据和控制信息，包含如下内存结构：  
	1）Database buffer cache：缓存了从磁盘上检索的数据块。  
	2）Redo log buffer：缓存了写到磁盘之前的重做信息。  
	3）Shared pool：缓存了各用户间可共享的各种结构。  
	4）Large pool：一个可选的区域，用来缓存大的I/O请求，以支持并行查询、共享服务器模式以及某些备份操作。  
	5）Java pool：保存java虚拟机中特定会话的数据与java代码。  
	6）Streams pool：由Oracle streams使用。  
	7）Keep buffer cache：保存buffer cache中存储的数据，使其尽时间可能长。  
	8）Recycle buffer cache：保存buffer cache中即将过期的数据。  
	9）nK block size buffer：为与数据库默认数据块大小不同的数据块提供缓存。用来支持表空间传输。
	
	database buffer cache, shared pool, large pool, streams pool与Java pool根据当前数据库状态，自动调整；
	keep buffer cache,recycle buffer cache,nK block size buffer可以在不关闭实例情况下，动态修改。
PGA     每个服务进程私有的内存区域，包含如下结构：  
	1）Private SQL area：包含绑定信息、运行时的内存结构。每个发出sql语句的会话，都有一个private SQL area（私有SQL区）  
	2）Session memory：为保存会话中的变量以及其他与会话相关的信息，而分配的内存区。



那结合业务，问题基本确定，可能是kettle抽数造成的，占用了较多的PGA,当oracle需要SGA 的时候，这些target值的比例完全不对而产生的告警。

调整：

修改为ASMM管理模式，在AMM模式下，内存的抖动一直是个问题，而对于某些业务来说，就像我上面的截图，已经有点鸠占鹊巢了。虽然oracle19c开始已经推出全自愈的数据库，至少在11g下，建议针对具体的业务具体调整。

ASMM（Automatic Shared Memory Management）方式：设置memory的参数全部为0；设置sga和pag的大小值。

命令方式：

alter system set memory_target=0 scope=both;

alter system set memory_max_target=0 scope=spfile;

alter system set sga_target = 0 scope=both;

alter system set pga_aggregate_target = 0 scope=both;

