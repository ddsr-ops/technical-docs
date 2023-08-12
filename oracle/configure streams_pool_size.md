[Doc](https://docs.oracle.com/en/database/oracle/oracle-database/19/xstrm/configuring-xstream-out.html#GUID-E24B40DF-D1C4-4FCC-8C62-28AAEC2AE972)
[Parameter STREAMS_POOL_SIZE](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/STREAMS_POOL_SIZE.html#GUID-3FFF66CB-5A1E-43AF-B30A-A8E189BFF3FF)
Configure the Streams pool
The Streams pool is a portion of memory in the System Global Area (SGA) that is used by both Oracle Replication and XStream components.

The Streams pool stores buffered queue LCRs in memory, and it provides memory for capture processes and outbound servers.

The following are considerations for configuring the Streams pool:

At least 300 MB of memory is required for the Streams pool.

After XStream Out is configured, you can use the max_sga_size capture process parameter to control the amount of system global area (SGA) memory allocated specifically to a capture process.

The sum of system global area (SGA) memory allocated for all components on a database must be less than the value set for the STREAMS_POOL_SIZE initialization parameter.

After XStream Out is configured, you can use the max_sga_size apply parameter to control the amount of SGA memory allocated specifically to an outbound server.

Ensure that there is enough space in the Streams pool at each database to run XStream components and to store LCRs and run the components properly.

The Streams pool is initialized the first time an outbound server is started.

The best practice is to set the STREAMS_POOL_SIZE initialization parameter explicitly to the desired Streams pool size.

The Automatic Shared Memory Management feature automatically manages the size of the Streams pool when the following conditions are met:

The MEMORY_TARGET and MEMORY_MAX_TARGET initialization parameters are both set to 0 (zero).

The SGA_TARGET initialization parameter is set to a nonzero value.

The Streams pool size is the value specified by the STREAMS_POOL_SIZE parameter, in bytes, if the following conditions are met:

The MEMORY_TARGET, MEMORY_MAX_TARGET, and SGA_TARGET initialization parameters are all set to 0 (zero).

The STREAMS_POOL_SIZE initialization parameter is set to a nonzero value.

If you are using Automatic Shared Memory Management, and if the STREAMS_POOL_SIZE initialization parameter also is set to a nonzero value, then Automatic Shared Memory Management uses this value as a minimum for the Oracle Replication pool. If your environment needs a minimum amount of memory in the Oracle Replication pool to function properly, then you can set a minimum size. To view the current memory allocated to Oracle Replication pool by Automatic Shared Memory Management, query the V$SGA_DYNAMIC_COMPONENTS view. In addition, you can query the V$STREAMS_POOL_STATISTICS view to view the current usage of the Oracle Replication pool.

