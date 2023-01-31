Native Memory Tracking
java8��HotSpot VM������Native Memory Tracking (NMT)���ԣ���������׷��JVM���ڲ��ڴ�ʹ��


# ����
-XX:NativeMemoryTracking=summary  
ʹ��-XX:NativeMemoryTracking=summary�������ڿ���NMT�����и�ֵĬ��Ϊoff����������Ϊsummary����detail�������������Ļ�����Ż�����5%-10%����������

# �鿴
/ # jcmd 1 VM.native_memory summary  
/ # jcmd 1 VM.native_memory summary scale=MB  
����"1"��ʾΪ����id  
ʹ��jcmd pid VM.native_memory���Բ鿴��������Լ�summary����detail������ǿ���summary�ģ���ֻ��ʹ��summary������scale��������ָ��չʾ�ĵ�λ������ΪKB����MB����GB

# ����baseline
/ # jcmd 1 VM.native_memory baseline    
Baseline succeeded

<u>����baseline֮�������summary.diff���Ա�</u>

# �鿴diff
/ # jcmd 1 VM.native_memory summary.diff

ʹ��summary.diff���鿴��baseline�Աȵ�ͳ����Ϣ

# shutdownʱ���
-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics

ʹ���������������jvm shutdown��ʱ����������native memoryͳ��

# �ر�
/ # jcmd 1 VM.native_memory shutdown  
Native memory tracking has been turned off

ʹ��jcmd pid VM.native_memory shutdown�������ڹر�NMT��ע��ʹ��jcmd�ر�֮��ò��û�ж�Ӧjcmd����������

#ʵ��
/ # jcmd 1 VM.native_memory summary scale=MB
```
Native Memory Tracking:

Total: reserved=2175MB, committed=682MB
-                 Java Heap (reserved=501MB, committed=463MB)
                            (mmap: reserved=501MB, committed=463MB)

-                     Class (reserved=1070MB, committed=50MB)
                            (classes #8801)
                            (  instance classes #8204, array classes #597)
                            (malloc=2MB #24660)
                            (mmap: reserved=1068MB, committed=49MB)
                            (  Metadata:   )
                            (    reserved=44MB, committed=43MB)
                            (    used=42MB)
                            (    free=1MB)
                            (    waste=0MB =0.00%)
                            (  Class space:)
                            (    reserved=1024MB, committed=6MB)
                            (    used=5MB)
                            (    free=0MB)
                            (    waste=0MB =0.00%)

-                    Thread (reserved=228MB, committed=27MB)
                            (thread #226)
                            (stack: reserved=227MB, committed=26MB)
                            (malloc=1MB #1139)

-                      Code (reserved=243MB, committed=17MB)
                            (malloc=1MB #5509)
                            (mmap: reserved=242MB, committed=16MB)

-                        GC (reserved=23MB, committed=15MB)
                            (malloc=8MB #11446)
                            (mmap: reserved=16MB, committed=7MB)

-                  Compiler (reserved=26MB, committed=26MB)
                            (malloc=2MB #1951)
                            (arena=24MB #13)

-                  Internal (reserved=5MB, committed=5MB)
                            (malloc=3MB #9745)
                            (mmap: reserved=2MB, committed=2MB)

-                     Other (reserved=2MB, committed=2MB)
                            (malloc=2MB #202)

-                    Symbol (reserved=10MB, committed=10MB)
                            (malloc=8MB #233939)
                            (arena=3MB #1)

-    Native Memory Tracking (reserved=5MB, committed=5MB)
                            (tracking overhead=5MB)

-               Arena Chunk (reserved=63MB, committed=63MB)
                            (malloc=63MB)
```

���Կ�������memory��Ҫ������Java Heap��Class��Thread��Code��GC��Compiler��Internal��Other��Symbol��Native Memory Tracking��
Arena Chunk�⼸���֣�����reserved��ʾӦ�ÿ��õ��ڴ��С��committed��ʾӦ������ʹ�õ��ڴ��С
Java Heap���ֱ�ʾheap�ڴ�Ŀǰռ����463MB��Class���ֱ�ʾ�Ѿ����ص�classes����Ϊ8801����metadataռ����50MB��
Thread���ֱ�ʾĿǰ��225���̣߳�ռ����27MB��Code���ֱ�ʾJIT���ɵĻ��߻����instructionsռ����17MB��
GC���ֱ�ʾĿǰ�Ѿ�ռ����15MB���ڴ�ռ����ڰ���GC��Code���ֱ�ʾcompiler����code��ʱ��ռ����26MB��Internal���ֱ�ʾ�����н�����
JVMTI��ռ����5MB��Other���ֱ�ʾ��δ�����ռ����2MB��Symbol���ֱ�ʾ����string table��constant pool��symbolռ����10MB��
Native Memory Tracking���ֱ�ʾ�ù�������ռ����5MB��Arena Chunk���ֱ�ʾarena chunkռ����63MB
һ��arena��ʾʹ��malloc�����һ��memory chunk����Щchunks���Ա�����subsystems��Ϊ��ʱ�ڴ�ʹ�ã�
����pre-thread���ڴ���䣬�����ڴ��ͷ��ǳ�bulk��

# С��
java8��HotSpot VM������Native Memory Tracking (NMT)���ԣ���������׷��JVM���ڲ��ڴ�ʹ��
ʹ��-XX:NativeMemoryTracking=summary�������ڿ���NMT�����и�ֵĬ��Ϊoff����������summary��detail��������
�����Ļ�����Ż�����5%-10%���������ģ�ʹ��-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics������jvm shutdown��ʱ����������native memoryͳ�ƣ�
�����Ŀ���ʹ��jcmd pid VM.native_memory���������в鿴��diff��shutdown��
����memory��Ҫ������Java Heap��Class��Thread��Code��GC��Compiler��Internal��Other��Symbol��Native Memory Tracking��Arena Chunk�⼸���֣�
����reserved��ʾӦ�ÿ��õ��ڴ��С��committed��ʾӦ������ʹ�õ��ڴ��С