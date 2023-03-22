```javascript
public
static
void main(String[]
args
)
{
    Properties
    kafkaProperties = new Properties();
    kafkaProperties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer");
    kafkaProperties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.ByteArrayDeserializer");
    kafkaProperties.put("bootstrap.servers", "localhost:9092");
    KafkaConsumer
    consumer = new KafkaConsumer < > (kafkaProperties);
    List
    partitions = new ArrayList < > ();
    partitions.add(new TopicPartition("test_topic", 0));
    partitions.add(new TopicPartition("test_topic", 1));
    consumer.assign(partitions);
    while (true) {
        ConsumerRecords
        records = consumer.poll(Duration.ofMillis(3000));
        for (ConsumerRecord record : records
    )
        {
            System.out.printf("topic:%s, partition:%s%n", record.topic(), record.partition());
        }
    }
}
```