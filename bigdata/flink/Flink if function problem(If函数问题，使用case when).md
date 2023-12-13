```text
Flink SQL> select if(1=2, 'ALIPAY', 'UNIONPAY') as client_code, case when 1=2 then 'ALIPAY' else 'UNIONPAY' end as client_code1, if(1=1, 'ALIPAY', 'UNIONPAY') as client_code2, case when 1=1 then 'ALIPAY' else '
UNIONPAY' end as client_code3;
2023-12-13 15:03:11,218 INFO  org.apache.flink.yarn.YarnClusterDescriptor                  [] - No path for the flink jar passed. Using the location of class org.apache.flink.yarn.YarnClusterDescriptor to locate the jar
2023-12-13 15:03:11,219 INFO  org.apache.hadoop.yarn.client.ConfiguredRMFailoverProxyProvider [] - Failing over to rm167
2023-12-13 15:03:11,225 INFO  org.apache.flink.yarn.YarnClusterDescriptor                  [] - Found Web Interface flink2:28080 of application 'application_1687554986023_0066'.
+-------------+--------------+--------------+--------------+
| client_code | client_code1 | client_code2 | client_code3 |
+-------------+--------------+--------------+--------------+
|      UNIONP |     UNIONPAY |       ALIPAY |       ALIPAY |
+-------------+--------------+--------------+--------------+
```

The `client_code` should be `UNIONPAY`, but 'UNIONP'. Use `case when` conditional expression to substitute `if` expression

[Reference](https://www.jianshu.com/p/8613d04cf2a3)