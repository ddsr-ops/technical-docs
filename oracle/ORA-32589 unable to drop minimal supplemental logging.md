```
Cause: Minimal supplemental logging cannot be dropped until one of the PRIMARY KEY, FOREIGN KEY, UNIQUE or ALL COLUMN supplemental logging is enabled.

For example: You may have enabled the following supplemental logging:

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
And now trying to turn off supplemental logging like this:

ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
Action: Use the following query to determine which supplemental logging is turned on:

select supplemental_log_data_min
       ,supplemental_log_data_all
       ,supplemental_log_data_pk
       ,supplemental_log_data_ui
from v$database
For example: If the output is the following:

SUPPLEMENTAL_LOG_DATA_MIN SUPPLEMENTAL_LOG_DATA_ALL SUPPLEMENTAL_LOG_DATA_PK SUPPLEMENTAL_LOG_DATA_UI
------------------------- ------------------------ ------------------------ ------------------------
IMPLICIT                  NO                       YES                      NO
Do the following:

ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
And then:

ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;

```

```
-- supplemental_log_data_all
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS;

-- supplemental_log_data_min, minimal supplemnetal logging
alter database add supplemental log data;
ALTER DATABASE DROP SUPPLEMENTAL LOG DATA;
```

If both `supplemental_log_data_all` and `supplemental_log_data_min` are `YES`, before removing minimal supplemental logging
via `ALTER DATABASE DROP SUPPLEMENTAL LOG DATA`, you should issue `ALTER DATABASE DROP SUPPLEMENTAL LOG DATA (ALL) COLUMNS`
to remove all supplemental logging.