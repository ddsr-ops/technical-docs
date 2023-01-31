https://docs.oracle.com/database/121/SUTIL/GUID-48D9DB83-BBC0-45EE-A81E-7CD047C908C1.htm#SUTIL1596

Querying Views for Supplemental Logging Settings
You can query several views to determine the current settings for supplemental logging, as described in the following list:

V$DATABASE view

SUPPLEMENTAL_LOG_DATA_FK column

This column contains one of the following values:

NO - if database-level identification key logging with the FOREIGN KEY option is not enabled

YES - if database-level identification key logging with the FOREIGN KEY option is enabled

SUPPLEMENTAL_LOG_DATA_ALL column

This column contains one of the following values:

NO - if database-level identification key logging with the ALL option is not enabled

YES - if database-level identification key logging with the ALL option is enabled

SUPPLEMENTAL_LOG_DATA_UI column

NO - if database-level identification key logging with the UNIQUE option is not enabled

YES - if database-level identification key logging with the UNIQUE option is enabled

SUPPLEMENTAL_LOG_DATA_MIN column

This column contains one of the following values:

NO - if no database-level supplemental logging is enabled

IMPLICIT - if minimal supplemental logging is enabled because database-level identification key logging options is enabled

YES - if minimal supplemental logging is enabled because the SQL ALTER DATABASE ADD SUPPLEMENTAL LOG DATA statement was issued
***
DBA_LOG_GROUPS, ALL_LOG_GROUPS, and USER_LOG_GROUPS views

ALWAYS column

This column contains one of the following values:

ALWAYS - indicates that the columns in this log group will be supplementally logged if any column in the associated row is updated

CONDITIONAL - indicates that the columns in this group will be supplementally logged only if a column in the log group is updated

GENERATED column

This column contains one of the following values:

GENERATED NAME - if the LOG_GROUP name was system-generated

USER NAME - if the LOG_GROUP name was user-defined

LOG_GROUP_TYPE column

This column contains one of the following values to indicate the type of logging defined for this log group. USER LOG GROUP indicates that the log group was user-defined (as opposed to system-generated).

ALL COLUMN LOGGING

FOREIGN KEY LOGGING

PRIMARY KEY LOGGING

UNIQUE KEY LOGGING

USER LOG GROUP
***
DBA_LOG_GROUP_COLUMNS, ALL_LOG_GROUP_COLUMNS, and USER_LOG_GROUP_COLUMNS views

The LOGGING_PROPERTY column

This column contains one of the following values:

LOG - indicates that this column in the log group will be supplementally logged

NO LOG - indicates that this column in the log group will not be supplementally logged