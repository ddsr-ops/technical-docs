Question:  What is the difference between logical standby and physical standby in Oracle Data Guard?

Answer: In  Oracle Data Guard you, Oracle transfers data from the main database to a standby database, and in case of failures, Oracle will switch over to the standby database.  We have two ways to create a standby database, logical standby and physical standby:

#### Physical standby differs from logical standby:

* Physical standby schema matches exactly the source database.

* Archived redo logs and FTP'ed directly to the standby database which is always running in "recover" mode.  Upon arrival, the archived redo logs are applied directly to the standby database.

#### Logical standby is different from physical standby:

* Logical standby database does not have to match the schema structure of the source database.

* Logical standby uses LogMiner techniques to transform the archived redo logs into native DML statements (insert, update, delete).  This DML is transported and applied to the standby database.

* Logical standby tables can be open for SQL queries (read only), and all other standby tables can be open for updates.

* Logical standby database can have additional materialized views and indexes added for faster performance.

#### Installing Physical standbys offers these benefits:

* An identical physical copy of the primary database

* Disaster recovery and high availability

* High Data protection

* Reduction in primary database workload

* Performance Faster

#### Installing Logical standbys offer:

* Simultaneous use for reporting, summations and queries

* Efficient use of standby hardware resources

* Reduction in primary database workload

* Some limitations on the use of certain datatypes