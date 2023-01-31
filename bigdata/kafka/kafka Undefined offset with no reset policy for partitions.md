```
Caused by: org.apache.kafka.clients.consumer.NoOffsetForPartitionException: Undefined offset with no reset policy for partitions: [test-topic-1]
```

������Ϊ���õ�auto.offset.resetΪnone����ʾ�����kafka broker���Ҳ�����ǰ���������offsetʱ�����׳��쳣��

������Դ���еĽ��ͣ�

```
/**
     * <code>auto.offset.reset</code>
     */
    public static final String AUTO_OFFSET_RESET_CONFIG = "auto.offset.reset";
    public static final String AUTO_OFFSET_RESET_DOC = "What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted): <ul><li>earliest: automatically reset the offset to the earliest offset<li>latest: automatically reset the offset to the latest offset</li><li>none: throw exception to the consumer if no previous offset is found for the consumer's group</li><li>anything else: throw exception to the consumer.</li></ul>";
```

��ˣ����Ը����������ó�earliest��latest��