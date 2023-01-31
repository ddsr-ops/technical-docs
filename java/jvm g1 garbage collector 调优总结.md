Java�����������õıȽ϶��CMS��G1,Ϊʲôѡ��G1�����������ء��ڶദ�����ʹ������ڴ滷���У���ʵ�ָ���������ͬʱ�������ܵ����������ռ���ͣʱ���Ҫ�󡣹ٷ���������

The Garbage-First (G1) collector is a server-style garbage collector, targeted for multi-processor machines with large memories. It meets garbage collection (GC) pause time goals with a high probability, while achieving high throughput. The G1 garbage collector is fully supported in Oracle JDK 7 update 4 and later releases. The G1 collector is designed for applications that:

* Can operate concurrently with applications threads like the CMS collector.

* Compact free space without lengthy GC induced pause times.

* Need more predictable GC pause durations.

* Do not want to sacrifice a lot of throughput performance.

* Do not require a much larger Java heap.

���������������:

��CMS�ռ���һ��������Ӧ�ó����̲߳���ִ�С�

������пռ���졣

��ҪGCͣ��ʱ�����Ԥ�⡣

��ϣ�������������������ܡ�

����Ҫ�����Java Heap��

��Ŀ��ѹ��5000�������˵�ʱ���ջռ�ô����5G������java���ܶ�ջ���ó�20G���������GC�����ᵼ��STW�ϳ�ʱ��ͱȽ�Ƶ�������Զ�GC���е��Ŵ���������һЩ����ϸ�ڣ�

**-XX:G1HeapRegionSize=n**

���õ� G1 ����Ĵ�С��ֵ�� 2 ���ݣ���Χ�� 1 MB �� 32 MB ֮�䡣Ŀ���Ǹ�����С�� Java �Ѵ�С���ֳ�Լ 2048 ������Ŀǰ����Ϸ��Ŀ22G�ڴ棬�������ֵ�趨��16��Ҳ����һ���ڴ�����16M��22G��ŷֳ���1408������

-XX:MaxGCPauseMillis=200

Ϊ��������ͣʱ������Ŀ��ֵ��Ĭ��ֵ�� 200 ���롣�����ֵ��һ����Ŀ�꣬Ҳ����˵JVM�ᾡһ���������������ͣҪ�󣬵��ǲ��ܱ�֤ÿ����ͣһ�������Ҫ��֮�ڡ����ݲ��Է��֣�������ǽ����ֵ�趨��50������߸��͵Ļ���JVMΪ�˴ﵽ���Ҫ��Ὣ������ڴ�ռ��趨�ķǳ�С���Ӷ�����youngGC��Ƶ�ʴ�����ߡ��������ǲ����趨���������

**-XX:InitiatingHeapOccupancyPercent=45**

���ô���������ڵ� Java ��ռ������ֵ��Ĭ��ռ���������� Java �ѵ� 45%������˵��ʹ���ڴ�ռ�����ܴ�С��45%��ʱ��G1����ʼ������ǽ׶Ρ�Ϊ���GC��׼���������ֵ�ڲ��Ե�ʱ�������û��GC��һЩ���������趨����70%�������۲췢����������ֵ�趨����ᵼ��JVM�޷�����������ǣ�ֱ�ӽ���FullGC����G1��FullGC�ǵ��̣߳�һ��22G�Ķ�GC�����Ҫ8S��ʱ�䣬�������ֵ�ڵ��ŵ�ʱ��д��45%

-Xmn

�ٷ��ĵ�˵ʹ��G1��������ʱ��Ҫָ���������С��ʹ��MaxGCPauseMillis������JVM���о�����С��֮ǰҲ˵�������MaxGCPauseMillisʱ���С�Ļ������younggcƵ�ʸߣ�������������ڵ��ŵ�ʱ���趨��4g

**-XX:ReservedCodeCacheSize=256m**

��������ر����׺��ԣ��������JDK8Ĭ����48M�������ǵ�JIT���й����н�JAVA������еײ������룬�ó���ӽ�������ģʽ������ܸ��ߵı�������ģʽ�����cache���������������������ڴ棬֮ǰ�����˳���ѹ��30Сʱ֮��CPU100%�����⣬�����Ų������Ϊ���cache��������Ż����رա�Jvm��־������������CodeCache is full. Compiler has been disabled��
G1�����������Ĳ����������£�

JDK7����

```-Xms22g -Xmx22g -Xmn4g -XX:+UseG1GC -XX:G1HeapRegionSize=16m -XX:InitiatingHeapOccupancyPercent=45 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:PermSize=256M -XX:MaxPermSize=256M -XX:MaxDirectMemorySize=512m```

�����JDK8�Ļ����£���Ҫ��������

```-Xms22g -Xmx22g -Xmn4g -XX:+UseG1GC -XX:-TieredCompilation -XX:G1HeapRegionSize=16m -XX:InitiatingHeapOccupancyPercent=45 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:-UseCompressedClassPointers -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m -XX:ReservedCodeCacheSize=256m -XX:+UseCodeCacheFlushing -XX��ParallelGCThreads= 16 -XX��ConcGCThreads= 16```

���Թ�����ÿ��GC���3-5�룬GCͣ��30-150���룬����2Сʱδ��ѡFullGc�����GC������ڴ�45%��ʱ�򴥷�������5-7��150�������е�GC����������ڴ档GC���ֲ���.