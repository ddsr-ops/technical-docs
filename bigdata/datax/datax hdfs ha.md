Config:

```text
......
"reader": {
          "name": "hdfsreader",
          "parameter": {
            "path": "/user/hive/warehouse/ads.db/my_test_table/dt=${date}/*",
            "hadoopConfig":{
              "dfs.nameservices": "${nameServices}",
              "dfs.ha.namenodes.${nameServices}": "namenode1,namenode2",
              "dfs.namenode.rpc-address.${nameServices}.namenode1": "${FS}",
              "dfs.namenode.rpc-address.${nameServices}.namenode2": "${FSBac}",
              "dfs.client.failover.proxy.provider.${nameServices}": "org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
            },
            "defaultFS": "hdfs://${nameServices}",
            "column": [
              {
                "index": 0,
                "type": "String"
              },
              {
                "index": 1,
                "type": "Long"
              }
            ],
......
```

1. Download config file: core-site.xml, hdfs-site.xml, hive-site.xml
2. Zip the above files into hdfsreader-0.0.1-SNAPSHOT.jar or hdfswriter-0.0.1-SNAPSHOT.jar


Reference: https://github.com/alibaba/DataX/issues/197
https://www.jianshu.com/p/e00bf5c89bfe