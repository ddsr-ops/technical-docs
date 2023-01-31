todo£ºconnector auto-recover when DML statements unparsed

data can be reachable, but dose not know which column refers to the value.
In case add columns, old columns are seen, new columns can not be human-readable.
In case modify columns, all columns are not human-readable.

DML --      DDL      -- DML
    \--    REDO  ---/

Auto-recovery action must be taken before DDL events occur.
Logminer session can not determine when DDL events comes . 
Yeah, triggers can handle the case. However, it may not conquer it correctly. 

Some questions: 
* How log to build dict, it can not be determined. In case DDL events may occur before ending dict building or before starting dict building. DDL events 
* DBAs can not be notified to when to issue DDL statements. 
* DDL triggers influence archive pipelines in which drop or truncate predicates are used.
* Even though DDL statements are issued and tracked correctly, when catalog mode was reverted to original mode?
In summary,  thinking of auto-recovery is a good idea, which can not be implemented gracefully.