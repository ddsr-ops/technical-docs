**背景**  
shell中解析json

**解决**  
通过python最好解决，

`curl -Ss -X GET ${CONNECTOR_DOMAIN}/connectors|python -c "import sys, json; res = 'YES' if '${CONNECTOR_NAME}' in json.load(sys.stdin) else 'NO'; print res"`

*指定Ss去掉请求头部*