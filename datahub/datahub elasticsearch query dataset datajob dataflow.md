curl -X GET localhost:9200/_cat/indices?v

curl -X GET localhost:9200/datasetindex_v2?pretty

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/datasetindex_v2/_search?pretty -d '{"query":{"match_all":{}}, "from":0, "size":100}'

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/dataflowindex_v2/_search?pretty -d '{"query":{"match_all":{}}, "from":0, "size":10000}'

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/datasetindex_v2/_search?pretty -d '{"query":{"match":{"name":"TB_TEST"}}, "from":0, "size":10}'

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/datasetindex_v2/_search?pretty -d '{"query":{"match":{ "platform": "urn:li:dataPlatform:kafka-connect"}}}'

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/dataflowindex_v2/_search?pretty -d '{"query":{"match":{ "platform": "urn:li:dataPlatform:kafka-connect"}}}'

curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' localhost:9200/datajobindex_v2/_search?pretty -d '{"query":{"match":{ "platform": "urn:li:dataPlatform:kafka-connect"}}}'