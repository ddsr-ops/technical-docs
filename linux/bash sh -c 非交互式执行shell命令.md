```
-c string If the -c option is present, then commands are read from string.  
If there are arguments after the string, they are assigned to the positional parameters, starting with $0.
```

`-c` demonstrates the invocation is non-interactive.

```shell
/bin/bash -c "/opt/spark3/spark_3.0.1/bin/spark-submit --deploy-mode cluster  --driver-memory 1G  --total-executor-cores 1 --executor-memory 3G --executor-cores 1  --class org.apache.spark.examples.streaming.NetworkWordCount /opt/spark3/spark_3.0.1/examples/jars/spark-examples_2.12-3.0.1.jar hadoop189 9991"
```

When invoking the shell command in the java program via the library hutool.RuntimeUtl, using the way like the above the example
is recommended.