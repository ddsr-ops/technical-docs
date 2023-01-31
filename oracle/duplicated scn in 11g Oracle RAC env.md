For single node Oracle RDBMS installations, an SCN is never duplicated.

With older versions of Oracle RAC, Oracle 9i for example, it was possible that two transactions, running on separate RAC nodes, could end up with the same SCN. Duplicates happened only in rare situations where high transaction rates on the RAC nodes was coupled with a large value for MAX_COMMIT_PROPAGATION_DELAY.

In Oracle RAC installations of version 11gR2 and later, RAC nodes coordinate changes to the SCN via a broadcast mechanism by default, essentially eliminating the possibility of a duplicate SCN.