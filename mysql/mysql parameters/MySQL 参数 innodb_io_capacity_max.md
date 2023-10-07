### innodb_io_capacity_max

* Variable Scope: Global
* Dynamic Variable: Yes
* Type: integer , Default Value: see the following description, Minimum Value: 100, Maximum: 2**32-1

If flushing activity falls behind, InnoDB can flush more aggressively than the limit imposed by
innodb_io_capacity. innodb_io_capacity_max defines an upper limit for I/O capacity in
such situations.

The innodb_io_capacity_max setting is a total limit for all buffer pool instances.
If you specify an innodb_io_capacity setting at startup but *do not specify a value for
innodb_io_capacity_max, innodb_io_capacity_max defaults to twice the value of
innodb_io_capacity, with a minimum value of 2000*.

When configuring innodb_io_capacity_max, twice the innodb_io_capacity is often a good
starting point. The default value of 2000 is intended for workloads that use a solid-state disk (SSD)
or more than one regular disk drive. A setting of 2000 is likely too high for workloads that do not
use SSD or multiple disk drives, and could allow too much flushing. For a single regular disk drive,
a setting between 200 and 400 is recommended. For a high-end, bus-attached SSD, consider a
higher setting such as 2500. As with the innodb_io_capacity setting, keep the setting as low as
practical, but not so low that InnoDB cannot sufficiently extend beyond the innodb_io_capacity
limit, if necessary.

Consider write workload when tuning innodb_io_capacity_max. Systems with large write
workloads may benefit from a higher setting. A lower setting may be sufficient for systems with a
small write workload.

innodb_io_capacity_max cannot be set to a value lower than the innodb_io_capacity value.
Setting innodb_io_capacity_max to DEFAULT using a SET statement (SET GLOBAL
innodb_io_capacity_max=DEFAULT) sets innodb_io_capacity_max to the maximum value.