Convert TIMESTAMP to SCN and SCN to TIMESTAMP in Oracle
In many recovery scenario we need to know our SCN and timestamps.
We can convert this by using the following function
SCN_TO_TIMESTAMP
TIMESTAMP_TO_SCN

We can use this function with help of dual functions.

Example of using this function as follows:

1. Convert the SCN to Timestamp

SQL> select scn_to_timestamp(2011955) from dual;

SCN_TO_TIMESTAMP(2011955)
-----------------------------------------------------
05-SEP-18 12.46.20.000000000 PM

2. Convert the Timestamp to SCN

SQL> select timestamp_to_scn(to_timestamp('05-09-2018 12:46:21','dd-mm-yyyy hh24:mi:ss')) scn from dual;

SCN
----------
2011955