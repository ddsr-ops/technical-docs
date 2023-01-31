# to_unix_timestamp
to_unix_timestamp(timeExp[, fmt]) - Returns the UNIX timestamp of the given time.

Arguments:

timeExp - A date/timestamp or string which is returned as a UNIX timestamp.
fmt - Date/time format pattern to follow. Ignored if timeExp is not a string. Default value is "yyyy-MM-dd HH:mm:ss". See Datetime Patterns for valid date and time format patterns.
Examples:

> SELECT to_unix_timestamp('2016-04-08', 'yyyy-MM-dd');
 1460098800
Since: 1.6.0


# to_utc_timestamp
to_utc_timestamp(timestamp, timezone) - Given a timestamp like '2017-07-14 02:40:00.0', interprets it as a time in the given time zone, and renders that time as a timestamp in UTC. For example, 'GMT+1' would yield '2017-07-14 01:40:00.0'.

Examples:

> SELECT to_utc_timestamp('2016-08-31', 'Asia/Seoul');
 2016-08-30 15:00:00
Since: 1.5.0


# to_timestamp
to_timestamp(timestamp_str[, fmt]) - Parses the timestamp_str expression with the fmt expression to a timestamp. Returns null with invalid input. By default, it follows casting rules to a timestamp if the fmt is omitted. The result data type is consistent with the value of configuration spark.sql.timestampType.

Arguments:

timestamp_str - A string to be parsed to timestamp.
fmt - Timestamp format pattern to follow. See Datetime Patterns for valid date and time format patterns.
Examples:

> SELECT to_timestamp('2016-12-31 00:12:00');
 2016-12-31 00:12:00
> SELECT to_timestamp('2016-12-31', 'yyyy-MM-dd');
 2016-12-31 00:00:00
Since: 2.2.0


# unix_timestamp
unix_timestamp([timeExp[, fmt]]) - Returns the UNIX timestamp of current or specified time.

Arguments:

timeExp - A date/timestamp or string. If not provided, this defaults to current time.
fmt - Date/time format pattern to follow. Ignored if timeExp is not a string. Default value is "yyyy-MM-dd HH:mm:ss". See Datetime Patterns for valid date and time format patterns.
Examples:

> SELECT unix_timestamp();
 1476884637
> SELECT unix_timestamp('2016-04-08', 'yyyy-MM-dd');
 1460041200
Since: 1.5.0


# from_unixtime
from_unixtime(unix_time[, fmt]) - Returns unix_time in the specified fmt.

Arguments:

unix_time - UNIX Timestamp to be converted to the provided format.
fmt - Date/time format pattern to follow. See Datetime Patterns for valid date and time format patterns. The 'yyyy-MM-dd HH:mm:ss' pattern is used if omitted.
Examples:

> SELECT from_unixtime(0, 'yyyy-MM-dd HH:mm:ss');
 1969-12-31 16:00:00

> SELECT from_unixtime(0);
 1969-12-31 16:00:00
Since: 1.5.0