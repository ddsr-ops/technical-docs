curl结合python -c使用时，出现信息头部：
```text
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   169  100   169    0     0  20487      0 --:--:-- --:--:-- --:--:-- 21125
```

```text
[root@hadoop189 dev_oracle0]# curl -X GET http://localhost:8083/connectors/devdbora0/status|python -c "import sys, json; print json.load(sys.stdin)"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   169  100   169    0     0  20487      0 --:--:-- --:--:-- --:--:-- 21125
{u'connector': {u'state': u'RUNNING', u'worker_id': u'88.88.16.189:8083'}, u'tasks': [{u'state': u'RUNNING', u'worker_id': u'88.88.16.189:8083', u'id': 0}], u'type': u'source', u'name': u'devdbora0'}
```

```shell
-S, --show-error    Show error. With -s, make curl show errors when they occur
 -s, --silent        Silent mode. Don't output anything
     --socks4 HOST[:PORT]  SOCKS4 proxy on given host + port
     --socks4a HOST[:PORT]  SOCKS4a proxy on given host + port
     --socks5 HOST[:PORT]  SOCKS5 proxy on given host + port
     --socks5-basic  Enable username/password auth for SOCKS5 proxies
     --socks5-gssapi Enable GSS-API auth for SOCKS5 proxies
     --socks5-hostname HOST[:PORT] SOCKS5 proxy, pass host name to proxy
     --socks5-gssapi-service NAME  SOCKS5 proxy service name for gssapi
     --socks5-gssapi-nec  Compatibility with NEC SOCKS5 serve
```

```shell
[root@hadoop189 dev_oracle0]# curl -Ss -X GET http://localhost:8083/connectors/devdbora0/status|python -c "import sys, json; print json.load(sys.stdin)"
{u'connector': {u'state': u'RUNNING', u'worker_id': u'88.88.16.189:8083'}, u'tasks': [{u'state': u'RUNNING', u'worker_id': u'88.88.16.189:8083', u'id': 0}], u'type': u'source', u'name': u'devdbora0'}
```