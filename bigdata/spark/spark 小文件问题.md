һ��С�ļ�������ԭ��  
1����ʹ��spark sql�������ݵĹ����У������shuffle������������spark.sql.shuffle.partitions������Ϣ��Ĭ��Ϊ200����������������Ƚϴ�ʱ��ͨ����Ѹ�ֵ�����Ա��ⵥ���������������̫������쳣�����������������ִ��ʱ�䡣  
2�����û��shuffle�������ļ�����������������Դ���ļ������Լ��ļ��Ƿ���зֵ����Ծ�������Ĳ����ȼ�task����������ڽ���������ϴת�����ߵĹ�����ͨ�������漰shuffle����ʱ������ܶ�С�ļ��������Դ���˷ѣ���NameNode����ѹ����  
������ν��С�ļ�����  
1��������spark.sql.shuffle.partitions���õ�ֵ������Ӱ�촦��Ĳ�����  
2����ʹ��repartition��coalesce ���ݾ�������������Ĵ�С������̫�������ʹ��spark-sql cli��ʽ���ͺܲ�����  
3��������������ʱ��ʹ��distribute by �ֶλ���rand(),���Ǵ�ʱ���ֶε�ѡ�����Ҫ����  
4����spark sql adaptive ����Ӧ���  
����spark-sql adaptive��ܽ��С�ļ�����  
1��������Ӧ��ܵĿ���  

spark.sql.adaptive.enabled true

2������partition��������

spark.sql.adaptive.minNumPostShufflePartitions 10  
spark.sql.adaptive.maxNumPostShufflePartitions 2000

3�����õ�reduce task��������ݴ�С  

spark.sql.adaptive.shuffle.targetPostShuffleInputSize 134217728  
spark.sql.adaptive.shuffle.targetPostShuffleRowCount 10000000

4������Ҫ����shuffle�����������ֻ��map task����Ҫͨ��group by ����distribute ����shuffle��ִ�У�ֻ�д���shuffle������ʹ��adaptive���С�ļ�����