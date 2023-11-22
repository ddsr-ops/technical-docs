# Standalone Resource Manager

## Prerequisites

A standalone Flink cluster was started, `$FLINK_HOME/bin/start-cluster.sh` start the cluster if not started.
These configuration files are respected by Flink:  `$FLINK_HOME/conf/flink-conf.yaml, masters, workers`.

Note: some parameters can not be specified in Flink interactive session, but they can be set in `flink-conf.yaml`,
such as `taskmanager.memory.managed.fraction=0.2`

## Start the sql-client

```shell
cd /opt/flink-1.16.1
bin/sql-client.sh
```

## Stop the cluster

`$FLINK_HOME/bin/stop-cluster.sh`


# Yarn Resource Manager

## Prerequisites

* Yarn service

## Start the Flink yarn application cluster

```shell
cd /opt/flink-1.16.1

bin/yarn-session.sh -d -s 1 -tm 20000 -D taskmanager.memory.managed.fraction=0.2 -D yarn.provided.usrlib.dir=hdfs:///tmp/gch/usrlib  # Directory name 'usrlib' is solid-writing, Using -D option can pass parameters configured in flink-conf.yaml, https://nightlies.apache.org/flink/flink-docs-release-1.16/docs/deployment/resource-providers/yarn/
```

Note: `bin/yarn-session.sh -h` can show the help information.

After the command finished, the application will be viewed in Yarn web UI.

## Start the sql-client to attach the Cluster above

Non-interactive session:
```shell
bin/sql-client.sh -s yarn-session -l ~/workspace/gch/flink-1.16.1/lib -f sql/user-system/20231108.sql
# set commands in sessions created by sql-client.sh can not set  taskmanager.memory.managed.fraction, https://nightlies.apache.org/flink/flink-docs-release-1.16/docs/dev/table/sqlclient/#sql-client-configuration
```

Interactive session:
```shell
bin/sql-client.sh -s yarn-session -l ~/workspace/gch/flink-1.16.1/lib
```

If setting `execution.target` to `yarn-application`, errors occur:
```text
Flink SQL> set 'execution.target' = 'yarn-application'
> ;
[INFO] Session property has been set.

Flink SQL> select * from (values (1)) as t(id);
[ERROR] Could not execute SQL statement. Reason:
java.lang.IllegalStateException: No ExecutorFactory found to execute the application.
```

Attention: taskmanager.memory.managed.fraction can not be specified in sql script used by sql-client.sh

Note: `bin/sql-client.sh -h` can show the help information.

## Stop the Flink yarn application cluster

```shell
# application id from /tmp/.yarn-properties-root
echo "stop"|bin/yarn-session.sh -id application_1687554986023_0026
```
