Chinese content is abnormal in the flink log.

**Solution**
Add the entry `env.java.opts: "-Dfile.encoding=UTF-8"` in the flink config file(flink-conf.yaml)