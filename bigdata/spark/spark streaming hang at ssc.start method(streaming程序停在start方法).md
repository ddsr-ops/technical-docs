```
    val conf = new SparkConf().setAppName("stream-test-job")
    val ssc = new StreamingContext(conf, Seconds(3))
    val spark = SparkSession.builder().config(ssc.sparkContext.getConf).getOrCreate()
    import spark.implicits._

    val lines = ssc.socketTextStream("88.88.16.189", 8888)
    // Split each line into words
    val words = lines.flatMap(_.split(" "))
    // Count each word in each batch
    val pairs = words.map(word => (word, 1))
    val wordCounts = pairs.reduceByKey(_ + _)
    wordCounts.print()
```

When launch the above job via the following command, batch jobs are being processed.
However,  the first batch job would be not finished, following batch jobs are queued.
`/opt/spark3/spark_3.0.1/bin/spark-submit --driver-memory 1g --executor-memory 1g --driver-cores 1 --total-executor-cores 1 --master spark://88.88.16.189:7077 --conf "spark.executor.extraJavaOptions=-XX:NativeMemoryTracking=detail" --class com.tft.test.StreamingTestJob spark-cache-test*.jar`

One cpu core is engaged to receive socket data,  leaving no thread for processing the received data.
Specify `total-executor-cores` to 2 to make it work. 

[Reference](https://stackoverflow.com/questions/37116079/why-does-spark-streaming-stop-working-when-i-send-two-input-streams)

Points to remember

When running a Spark Streaming program locally, do not use ¡°local¡± or ¡°local1¡± as the master URL. 
Either of these means that only one thread will be used for running tasks locally. 
If you are using a input DStream based on a receiver (e.g. sockets, Kafka, Flume, etc.), 
then the single thread will be used to run the receiver, leaving no thread for processing the received data. 
Hence, when running locally, always use ¡°local[n]¡± as the master URL, where n > number of receivers to run (see Spark Properties for information on how to set the master).

Extending the logic to running on a cluster, the number of cores allocated to the Spark Streaming application must be more than the number of receivers. 
Otherwise the system will receive data, but not be able to process it.