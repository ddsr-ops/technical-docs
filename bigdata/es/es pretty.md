pretty
在任意的查询字符串中增加pretty参数，会让Elasticsearch美化输出(pretty-print)JSON响应以便更加容易阅读。

_source字段不会被美化，它的样子与我们输入的一致。


curl -X GET localhost:9200/cba/_mapping?pretty