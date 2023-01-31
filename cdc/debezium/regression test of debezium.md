# Regression test

After merging codes, we should do a regression test suite.


## Case one: date column

Mainly change timezone in database oracle and mysql. 

* Oracle data type: `date`, `timestamp`, `timestamp with time zone`, `timestamp with local time`  
  dba_test.tb_test in 112 dev oracle env.
* MySQL data type: `date`, `datetime`, `timestamp`  
  mysql_cdc_test.cdc_test_gch in 113 dev mysql env

expectation:

above columns should be represented as `+8` timezone.

## Case two: oracle session pga spilling

When oracle session pga exceeds value specified in the config table `log_mining_config`, session would be restarted
to release memory.

expectation:

Oracle mining session should be restarted when session memory exceeds the threshold.

## Case three: only mine log from start position to end position

We can configure start position and end position in connector-json body, connector only mines log between start 
position and end position.

expectation:

Connector only mines log between start position and end position.

## Case four: whether connector is working correctly when table name was change to another and soon changed back to original table name

Assume table `A` is captured. When connector is running, table name `A` was changed into `B`, at the same time some dml statements
happened on table `B`. After that, table name `B` was changed into original table name `A`.

expectation:

In the period, dml events on table `A` and `B` should all be captured. The connector should be running correctly.  
Here, catalog must be specified using 'redo_log_catalog'.

Refer to doc <experiments about debezium when table was renamed> to look through the whole test.  
