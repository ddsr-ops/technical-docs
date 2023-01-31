# How to understand open_cursors

You have to consider all cursors -- cursors you open, cursors your application framework will open on your behalf, cursors the database must open to perform recursive SQL.

For example, if you are in forms and have a default block and nothing else and run that form, you'll find (before doing ANYTHING) you have some cursors open. Forms (your application framework) has done some sql and cached the cursors on your behalf.

As you do more work in forms (eg: query up a row, update a field in the row) you'll see more and more cursors appear. Some you opened (by doing the query). Others were opened on your behalf (eg: forms locking the record for us when we updated the field).

You might also see some cursors come and go that reference SYS tables. These would be recursive queries and would happen when the optimizer parses your query, needs to allocate space for your query and so on.

You might also see other cursor come into play when triggers fire, stored procedures run and so on.


It is not possible for 2 sessions to share the same exact cursor but it is highly probable that 2 sessions will share the same "shared_pool" entry for the underlying query (see SHARED SQL in the concepts guide). A cursor is in your space, the parse tree, optimization, security and such is in a shared space.

It should be noted that OPEN_CURSORS simply allocates a fixed number of slots but does not allocate memory for these slots for a client (eg: it sets an array up to have 1,000 cursors for example but does not allocate 1,000 cursors). Rather, we will allocate 64 cursor contexts at a time, as needed (so the first cursor will allocate 64 contexts, the 65'th will get 64 more and so on). So, setting open-cursors to 1,000 or so it not harmful (but don't go overboard and set it to 1,000,000 or something ;)

# Demonstrations from official doc 


Property	Description
Parameter type	Integer
Default value	50
Modifiable	ALTER SYSTEM
Range of values	0 to 65535
Basic	Yes

OPEN_CURSORS specifies the maximum number of open cursors (handles to private SQL areas) a session can have at once. You can use this parameter to prevent a session from opening an excessive number of cursors.

It is important to set the value of OPEN_CURSORS high enough to prevent your application from running out of open cursors. The number will vary from one application to another. Assuming that a session does not open the number of cursors specified by OPEN_CURSORS, there is no added overhead to setting this value higher than actually needed.