Spark streaming consumption Kafka error Kafka ConsumerRecord is not serializable.Use .map to extract fields before


```
2020-04-15 15:56:50,026  ERROR --- [                          streaming-job-executor-0]  org.apache.spark.streaming.kafka010.KafkaRDD                                    (line:   70)  :  Kafka ConsumerRecord is not serializable. Use .map to extract fields before calling .persist or .window
2020-04-15 15:57:00,052  ERROR --- [                          streaming-job-executor-0]  org.apache.spark.streaming.kafka010.KafkaRDD                                    (line:   70)  :  Kafka ConsumerRecord is not serializable. Use .map to extract fields before calling .persist or .window
2020-04-15 15:57:10,012  ERROR --- [                          streaming-job-executor-0]  org.apache.spark.streaming.kafka010.KafkaRDD                                    (line:   70)  :  Kafka ConsumerRecord is not serializable. Use .map to extract fields before calling .persist or .window
2020-04-15 15:57:20,130  ERROR --- [                          streaming-job-executor-0]  org.apache.spark.streaming.kafka010.KafkaRDD                                    (line:   70)  :  Kafka ConsumerRecord is not serializable. Use .map to extract fields before calling .persist or .window
2020-04-15 15:57:30,077  ERROR --- [                          streaming-job-executor-0]  org.apache.spark.streaming.kafka010.KafkaRDD                                    (line:   70)  :  Kafka ConsumerRecord is not serializable. Use .map to extract fields before calling .persist or .window
```
The error message is as above,

2. It is found through the code that the dataframe generated by rdd has no cache, just add cache to the dataframe

The original code is as follows:

     val user_visit_history = rdd
          .map{ record =>
          val event = JSON.parseObject(record.value().toString)
          val uid = event.getString("uid")
          val cid = event.getString("cid")
          val optType = event.getInteger("optType")
          val optValue = event.getInteger("optValue")
          user_visit_his(uid,cid,optType,optValue)
        }
        .filter{ record =>
           if( record.optType == 4 && record.optValue>= 0){
             true
           }else{
             false
           }
        }
        .toDF("user_id","video_id","optType","optValue")


3. By adding a line of code to user_visit_history, the problem is fixed:

user_visit_history.cache()
