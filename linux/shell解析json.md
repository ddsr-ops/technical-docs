**����**  
shell�н���json

**���**  
ͨ��python��ý����

`curl -Ss -X GET ${CONNECTOR_DOMAIN}/connectors|python -c "import sys, json; res = 'YES' if '${CONNECTOR_NAME}' in json.load(sys.stdin) else 'NO'; print res"`

*ָ��Ssȥ������ͷ��*