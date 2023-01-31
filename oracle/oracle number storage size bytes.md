39

The storage used depends on the actual numeric value, as well as the column precision and scale of the column.

The Oracle 11gR2 concepts guide says:

Oracle Database stores numeric data in variable-length format. Each value is stored in scientific notation, with 1 byte used to store the exponent. The database uses up to 20 bytes to store the mantissa, which is the part of a floating-point number that contains its significant digits. Oracle Database does not store leading and trailing zeros.

The 10gR2 guide goes further:

Taking this into account, the column size in bytes for a particular numeric data value NUMBER(p), where p is the precision of a given value, can be calculated using the following formula:

ROUND((length(p)+s)/2))+1
where s equals zero if the number is positive, and s equals 1 if the number is negative.

Zero and positive and negative infinity (only generated on import from Version 5 Oracle databases) are stored using unique representations. Zero and negative infinity each require 1 byte; positive infinity requires 2 bytes.

If you have access to My Oracle Support, there is more information in note 1031902.6.

You can see the actual storage used with vsize or dump.

create table t42 (n number(10));

insert into t42 values (0);
insert into t42 values (1);
insert into t42 values (-1);
insert into t42 values (100);
insert into t42 values (999);
insert into t42 values (65535);
insert into t42 values (1234567890);

select n, vsize(n), dump(n)
from t42
order by n;

          N   VSIZE(N)                           DUMP(N) 
------------ ---------- ---------------------------------
         -1          3           Typ=2 Len=3: 62,100,102 
          0          1                  Typ=2 Len=1: 128 
          1          2                Typ=2 Len=2: 193,2 
        100          2                Typ=2 Len=2: 194,2 
        999          3           Typ=2 Len=3: 194,10,100 
      65535          4          Typ=2 Len=4: 195,7,56,36 
 1234567890          6   Typ=2 Len=6: 197,13,35,57,79,91 
Notice that the storage varies depending on the value, even though they are all in a number(10) column, and that two 3-digit numbers can need different amounts of storage.