```

curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"appName":"������","msg":"������"}' http://10.50.253.6:18888/sms/send


[root@hadoop189 connector-json]# more create_connector_from_json.sh 
#!/bin/bash

curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d@$1 http://localhost:8084/connectors
[root@hadoop189 connector-json]# more devdbora1.json   # json��ʽ
{
     "name": "devdboragch18",
     "config": {
         "connector.class" : "io.debezium.connector.oracle.OracleConnector",
         ....
     }
  }
[root@hadoop189 connector-json]# ./create_connector_from_json.sh devdbora1.json

```