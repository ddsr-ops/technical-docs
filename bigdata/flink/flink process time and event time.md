```text
3.4.1 ����ʱ�䣨Processing Time��
����ʱ�������£�������������ݻ����ı���ʱ�����ɽ��������ʱ�����򵥸�����Ȳ���Ҫ��ȡʱ�����Ҳ����Ҫ����watermark��
���崦��ʱ�����������ַ�������DataStreamת��ʱֱ��ָ�����ڶ���Table Schemaʱָ�����ڴ������DDL��ָ����
1)DataStreamת����Tableʱָ��
��DataStreamת���ɱ�ʱ�������ں���ָ���ֶ���������Schema���ڶ���Schema�ڼ䣬����ʹ��.proctime�����崦��ʱ���ֶΡ�
ע�⣬���proctime����ֻ��ͨ�������߼��ֶΣ�����չ����schema����ˣ�ֻ����schema�����ĩβ��������

�������£�
// ����� DataStream
val inputStream: DataStream[String] = env.readTextFile("\\sensor.txt")
val dataStream: DataStream[SensorReading] = inputStream
  .map(data => {
    val dataArray = data.split(",")
    SensorReading(dataArray(0), dataArray(1).toLong, dataArray(2).toDouble)
  })

// �� DataStreamת��Ϊ Table����ָ��ʱ���ֶ�
val sensorTable = tableEnv.fromDataStream(dataStream, 'id, 'temperature, 'timestamp, 'pt.proctime)
2)����Table Schemaʱָ��
���ַ�����ʵҲ�ܼ򵥣�ֻҪ�ڶ���Schema��ʱ�򣬼���һ���µ��ֶΣ���ָ����proctime�Ϳ����ˡ�
�������£�
tableEnv.connect(
  new FileSystem().path("..\\sensor.txt"))
  .withFormat(new Csv())
  .withSchema(new Schema()
    .field("id", DataTypes.STRING())
    .field("timestamp", DataTypes.BIGINT())
    .field("temperature", DataTypes.DOUBLE())
    .field("pt", DataTypes.TIMESTAMP(3))
      .proctime()    // ָ�� pt�ֶ�Ϊ����ʱ��
  ) // �����ṹ
  .createTemporaryTable("inputTable") // ������ʱ��
3)�������DDL��ָ��
�ڴ������DDL�У�����һ���ֶβ�ָ����proctime��Ҳ����ָ����ǰ��ʱ���ֶΡ�
�������£�
val sinkDDL: String =
  """
    |create table dataTable (
    |  id varchar(20) not null,
    |  ts bigint,
    |  temperature double,
    |  pt AS PROCTIME()
    |) with (
    |  'connector.type' = 'filesystem',
    |  'connector.path' = 'file:///D:\\..\\sensor.txt',
    |  'format.type' = 'csv'
    |)
  """.stripMargin

tableEnv.sqlUpdate(sinkDDL) // ִ�� DDL

ע�⣺�������DDL������ʹ��Blink Planner��
3.4.2 �¼�ʱ�䣨Event Time��
�¼�ʱ�����壬�������������ÿ����¼�а�����ʱ�����ɽ����������ʹ���������¼������ӳ��¼�ʱ��Ҳ���Ի����ȷ�Ľ����
Ϊ�˴��������¼������������е�׼ʱ�ͳٵ��¼���Flink��Ҫ���¼������У���ȡʱ������������ƽ��¼�ʱ��Ľ�չ��watermark����
1)DataStreamת����Tableʱָ��
��DataStreamת����Table��schema�Ķ����ڼ䣬ʹ��.rowtime���Զ����¼�ʱ�����ԡ�ע�⣬������ת�����������з���ʱ�����watermark��
�ڽ�������ת��Ϊ��ʱ�������ֶ���ʱ�����Եķ���������ָ����.rowtime�ֶ����Ƿ�������������ļܹ��У�timestamp�ֶο��ԣ�
 ��Ϊ���ֶ�׷�ӵ�schema
 �滻�����ֶ�
������������£�������¼�ʱ����ֶΣ���������DataStream���¼�ʱ�����ֵ��

�������£�
val inputStream: DataStream[String] = env.readTextFile("\\sensor.txt")
val dataStream: DataStream[SensorReading] = inputStream
    .map(data => {
        val dataArray = data.split(",")
        SensorReading(dataArray(0), dataArray(1).toLong, dataArray(2).toDouble)
      })
    .assignAscendingTimestamps(_.timestamp * 1000L)

// �� DataStreamת��Ϊ Table����ָ��ʱ���ֶ�
val sensorTable = tableEnv.fromDataStream(dataStream, 'id, 'timestamp.rowtime, 'temperature)
// ���ߣ�ֱ��׷���ֶ�
val sensorTable2 = tableEnv.fromDataStream(dataStream, 'id, 'temperature, 'timestamp, 'rt.rowtime)

2)����Table Schemaʱָ��
���ַ���ֻҪ�ڶ���Schema��ʱ�򣬽��¼�ʱ���ֶΣ���ָ����rowtime�Ϳ����ˡ�

�������£�
tableEnv.connect(
  new FileSystem().path("sensor.txt"))
  .withFormat(new Csv())
  .withSchema(new Schema()
    .field("id", DataTypes.STRING())
    .field("timestamp", DataTypes.BIGINT())
      .rowtime(
        new Rowtime()
          .timestampsFromField("timestamp")    // ���ֶ�����ȡʱ���
          .watermarksPeriodicBounded(1000)    // watermark�ӳ�1��
      )
    .field("temperature", DataTypes.DOUBLE())
  ) // �����ṹ
  .createTemporaryTable("inputTable") // ������ʱ��
3)�������DDL��ָ��
�¼�ʱ�����ԣ���ʹ��CREATE TABLE DDL�е�WARDMARK��䶨��ġ�watermark��䣬���������¼�ʱ���ֶ��ϵ�watermark���ɱ��ʽ���ñ��ʽ���¼�ʱ���ֶα��Ϊ�¼�ʱ�����ԡ�

�������£�

val sinkDDL: String =
"""
|create table dataTable (
|  id varchar(20) not null,
|  ts bigint,
|  temperature double,
|  rt AS TO_TIMESTAMP( FROM_UNIXTIME(ts) ),
|  watermark for rt as rt - interval '1' second
|) with (
|  'connector.type' = 'filesystem',
|  'connector.path' = 'file:///D:\\..\\sensor.txt',
|  'format.type' = 'csv'
|)
""".stripMargin
tableEnv.sqlUpdate(sinkDDL) // ִ�� DDL

����FROM_UNIXTIME��ϵͳ���õ�ʱ�亯����������һ��������������ת���ɡ�YYYY-MM-DD hh:mm:ss����ʽ��Ĭ�ϣ�Ҳ������Ϊ�ڶ���String�������룩������ʱ���ַ�����date time string����Ȼ������TO_TIMESTAMP����ת����Timestamp��
```