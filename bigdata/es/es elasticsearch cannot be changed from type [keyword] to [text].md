Json data:
```text
{"index":{"_index":"test","_type":"doc"}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Trying out Elasticsearch", "k4": "Trying out Elasticsearch", "k5": 10.0}
{"index":{"_index":"test","_type":"doc"}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Trying out Doris", "k4": "Trying out Doris", "k5": 10.0}
{"index":{"_index":"test","_type":"doc"}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Doris On ES", "k4": "Doris On ES", "k5": 10.0}
{"index":{"_index":"test","_type":"doc"}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Doris", "k4": "Doris", "k5": 10.0}
{"index":{"_index":"test","_type":"doc"}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "ES", "k4": "ES", "k5": 10.0}

```

Insert data into index.
```
curl -XPOST -H 'Content-Type:application/json' 'localhost:9200/_bulk?pretty' --data-binary @data.json
```

Response, 
```text
{
  "took" : 15,
  "errors" : true,
  "items" : [
    {
      "index" : {
        "_index" : "test",
        "_type" : "doc",
        "_id" : "xcjzCH0BuwiZ4fWoG2_x",
        "status" : 400,
        "error" : {
          "type" : "illegal_argument_exception",
          "reason" : "mapper [k3] cannot be changed from type [keyword] to [text]"
        }
      }
    },
......
```

Reason:  
In es 7+, type is not supported.
但是对于ElasticSearch 6.x执行时没有问题的，elasticsearch7默认不在支持指定索引类型，默认索引类型是_doc。 官方文档：
https://www.elastic.co/guide/en/elasticsearch/reference/current/removal-of-types.html

所以在ElasticSearch 7.x中不指定索引类型，创建索引是成功的：

**Solution**

Remove type in json data file.
```text
{"index":{"_index":"test",}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Trying out Elasticsearch", "k4": "Trying out Elasticsearch", "k5": 10.0}
{"index":{"_index":"test",}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Trying out Doris", "k4": "Trying out Doris", "k5": 10.0}
{"index":{"_index":"test",}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Doris On ES", "k4": "Doris On ES", "k5": 10.0}
{"index":{"_index":"test",}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "Doris", "k4": "Doris", "k5": 10.0}
{"index":{"_index":"test",}}
{ "k1" : 100, "k2": "2020-01-01", "k3": "ES", "k4": "ES", "k5": 10.0}
```

```shell
curl -XPOST -H 'Content-Type:application/json' 'localhost:9200/_bulk?pretty' --data-binary @data.json
```

Query index
```shell
[root@hadoop-193 elasticsearch]# more data.json 
{
	"query":{
		"match_all":{}
	},
	"from": 0, 
	"size": 100 
}
[root@hadoop-193 elasticsearch]# curl -X GET localhost:9200/test/_search?pretty -H "Accept: application/json" -H "Content-type: application/json" -d@data.json
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "test",
        "_type" : "_doc",
        "_id" : "ysj0CH0BuwiZ4fWoJG_e",
        "_score" : 1.0,
        "_source" : {
          "k1" : 100,
          "k2" : "2020-01-01",
          "k3" : "Trying out Elasticsearch",
          "k4" : "Trying out Elasticsearch",
          "k5" : 10.0
        }

```