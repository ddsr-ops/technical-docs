Oracle 9i����pga_aggregate_target��ֵΪ0�����Զ���PGA���е�����

Oracle 10g����sga_target��ֵΪ0�����Զ���SGA���е�����

Oracle 11g����������ֽ����ۺϣ�����memory_target�������Զ��������е��ڴ棬�������������Զ��ڴ�������ԡ�

�Զ��ڴ��������������ʼ�������������õģ�

MEMORY_TARGET����̬����SGA��PGAʱ��Oracle�ܹ�����ʹ�õĹ����ڴ��С����������Ƕ�̬�ģ�����ṩ��Oracle���ڴ������ǿ��Զ�̬����Ҳ���Զ�̬��С�ġ�
�����ܳ���MEMORY_MAX_TARGET�������õĴ�С��Ĭ��ֵ��0��    
MEMORY_MAX_TARGET���������������MEMORY_TARGET�����Դﵽ����������ʵ����ֵ�����û������MEMORY_MAX_TARGETֵ��Ĭ�ϵ���MEMORY_TARGET��ֵ��
ʹ�ö�̬�ڴ����ʱ��SGA_TARGET��PGA_AGGREGATE_TARGET�������Ǹ����ڴ��������С���ã�*Ҫ��Oracle��ȫ�����ڴ��������������Ӧ������Ϊ0*��

MEMORY_MAX_TARGET��һ���Ƕ�̬������������memory��Χ��̬�ı䣬ֻ��ͨ��ָ�� scope=spfile����������ﵽ���ݿ����´��������øı���Ч��Ŀ�ġ�
����MEMORY_TARGET��������ǿ��Զ�̬���ڵ�...Ҳ����˵����Ҫ��������DB���Ϳ���������Ч��

MEMORY_MAX_TARGET ���趨Oracle��ռOS�����ڴ�ռ䣬SGA_MAX_SIZE��Oracle SGA �������ռ����ڴ�ռ�.
10g ��SGA_MAX_SIZE �Ƕ�̬���� Shared Pool Size,database buffer cache,large pool,javapool��redo log buffer ��С������ֵ���Ǹ���Oracle ����״�������·���SGA���ڴ��Ĵ�С��
PGA��10g����Ҫ�����趨�� 11g MEMORY_MAX_TARGET ��������SGA��PGA�����֡�

MEMORY_MAX_TARGET : oracle�ڴ�����ֵ�ܴﵽ�����ޡ��Ƕ�̬�ɵ������û��ָ����Ĭ�Ϻ�MEMORY_TARGET��ͬ��

���ֶ��������ݿ�ʱ��ֻ��Ҫ�ڴ������ݿ�֮ǰ���ú��ʵ�MEMORY_TARGET��MEMORY_MAX_TARGET��ʼ��������


������������11G��MEMORY_TARGET���úͲ����ö�SGA/PGA ��Ӱ�죺

## ��� MEMORY_TARGET ����Ϊ�� 0 ֵ

1. ��� ORACLE ���Ѿ������˲��� SGA_TARGET �� PGA_AGGREGATE_TARGET ��������������������granule���Ա�����Ϊ��СֵΪ���ǵ�Ŀ��ֵ��
����`alter system set sga_target = 500M scope=spfile;`���ú��SGA_TARGETֵΪ512M��

2. SGA_TARGET �� PGA_AGGREGATE_TARGET ��û�����ô�С ORACLE 11G�ж����� SGA_TARGET �� PGA_AGGREGATE_TARGET ��û���趨��С������£�
   ORACLE ����������ֵû����Сֵ��Ĭ��ֵ�� ORACLE ���������ݿ�����״�����з����С�� �������ݿ������ǻ���һ���̶����������䣺
   > SGA_TARGET =MEMORY_TARGET *60%  
   > PGA_AGGREGATE_TARGET=MEMORY_TARGET *40%



## ��� MEMORY_TARGETû�����û� =0

  11G��Ĭ��Ϊ 0 ���ʼ״̬��ȡ���� MEMORY_TARGET �����ã���ȫ�� 10G ���ڴ������һ�£���ȫ���¼��ݡ�

1. SGA_TARGET ����ֵ�����Զ����� SGA �е� SHARED POOL,BUFFER CACHE,REDO LOG BUFFER,JAVA POOL,LARGER POOL���ڴ�ռ�Ĵ�С��
 PGA ������ PGA_AGGREGATE_TARGET �Ĵ�С�� SGA �� PGA �����Զ��������Զ���С��

2. SGA_TARGET �� PGA_AGGREGATE_TARGET ��û�����ã�����MEMORY_TARGET��MEMORY_MAX_TARGET��û���ã�ʵ�����޷���������������ORA-00849
SGA �еĸ������С��Ҫ��ȷ�趨�������Զ��������齨��С�� PGA �����Զ�������������

3. MEMORY_MAX_TARGET ���� �� MEMORY_TARGET =0��Ҳ����������ʾ����SGA_TARGET=0, PGA_AGGREGATE_TARGE=16M��


��11g �п���ʹ�����濴�������ֵ

SQL> show parameter target

�����Ҫ���� Memory_target ��״�������ʹ������������̬��ͼ��

* V$MEMORY_DYNAMIC_COMPONENTS

* V$MEMORY_RESIZE_OPS

* V$MEMORY_TARGET_ADVICE



ʹ������ Command �����ڴ�С��

SQL>ALTER SYSTEM SET MEMORY_MAX_TARGET = 1024M SCOPE = SPFILE;

SQL>ALTER SYSTEM SET MEMORY_TARGET = 1024M SCOPE = SPFILE;

SQL>ALTER SYSTEM SET SGA_TARGET =0 SCOPE = SPFILE;

SQL>ALTER SYSTEM SET PGA_AGGREGATE_TARGET = 0 SCOPE = SPFILE ;


# �����ͼ��ѯSQL
```
select m.COMPONENT,m.OPER_TYPE,m.OPER_MODE,m.PARAMETER,m.INITIAL_SIZE/1024/1024/1024 ��ʼֵGB,
M.TARGET_SIZE/1024/1024/1024 Ŀ��ֵGB,m.FINAL_SIZE/1024/1024/1024 ����ֵGB,
TO_CHAR(M.START_TIME,'YYYY-MM-DD HH24:MI:SS') ��ʼʱ��,
TO_CHAR(M.END_TIME,'YYYY-MM-DD HH24:MI:SS') ����ʱ��
from V$MEMORY_RESIZE_OPS m
where m.COMPONENT in ('PGA Target','SGA Target');--���������ɵ�800  ���ڴ��С���������ѭ����ʷ��¼������

select MDC.COMPONENT,
mdc.CURRENT_SIZE/1024/1024/1024 ��ǰ��СGB,
MDC.MIN_SIZE/1024/1024/1024 ��СֵGB,
MDC.MAX_SIZE/1024/1024/1024 ���ֵGB,
MDC.OPER_COUNT,
MDC.LAST_OPER_TYPE,
MDC.LAST_OPER_MODE,
to_char(MDC.LAST_OPER_TIME,'yyyy-mm-dd hh24:mi:ss') ������ʱ��,
MDC.GRANULE_SIZE/1024/1024 ��������MB
FROM V$MEMORY_DYNAMIC_COMPONENTS MDC;--���������ڴ�����ĵ�ǰ״̬

select * from  V$MEMORY_TARGET_ADVICE;--�ṩ���MEMORY_TARGET ��ʼ���������Ż�����
```

# SGA PGA˵��

sga������ʵ�������ݺͿ�����Ϣ�����������ڴ�ṹ��  
	1��Database buffer cache�������˴Ӵ����ϼ��������ݿ顣  
	2��Redo log buffer��������д������֮ǰ��������Ϣ��  
	3��Shared pool�������˸��û���ɹ���ĸ��ֽṹ��  
	4��Large pool��һ����ѡ����������������I/O������֧�ֲ��в�ѯ�����������ģʽ�Լ�ĳЩ���ݲ�����  
	5��Java pool������java��������ض��Ự��������java���롣  
	6��Streams pool����Oracle streamsʹ�á�  
	7��Keep buffer cache������buffer cache�д洢�����ݣ�ʹ�価ʱ����ܳ���  
	8��Recycle buffer cache������buffer cache�м������ڵ����ݡ�  
	9��nK block size buffer��Ϊ�����ݿ�Ĭ�����ݿ��С��ͬ�����ݿ��ṩ���档����֧�ֱ�ռ䴫�䡣
	
	database buffer cache, shared pool, large pool, streams pool��Java pool���ݵ�ǰ���ݿ�״̬���Զ�������
	keep buffer cache,recycle buffer cache,nK block size buffer�����ڲ��ر�ʵ������£���̬�޸ġ�
PGA     ÿ���������˽�е��ڴ����򣬰������½ṹ��  
	1��Private SQL area����������Ϣ������ʱ���ڴ�ṹ��ÿ������sql���ĻỰ������һ��private SQL area��˽��SQL����  
	2��Session memory��Ϊ����Ự�еı����Լ�������Ự��ص���Ϣ����������ڴ�����



�ǽ��ҵ���������ȷ����������kettle������ɵģ�ռ���˽϶��PGA,��oracle��ҪSGA ��ʱ����Щtargetֵ�ı�����ȫ���Զ������ĸ澯��

������

�޸�ΪASMM����ģʽ����AMMģʽ�£��ڴ�Ķ���һֱ�Ǹ����⣬������ĳЩҵ����˵������������Ľ�ͼ���Ѿ��е��ռȵ���ˡ���Ȼoracle19c��ʼ�Ѿ��Ƴ�ȫ���������ݿ⣬������11g�£�������Ծ����ҵ����������

ASMM��Automatic Shared Memory Management����ʽ������memory�Ĳ���ȫ��Ϊ0������sga��pag�Ĵ�Сֵ��

���ʽ��

alter system set memory_target=0 scope=both;

alter system set memory_max_target=0 scope=spfile;

alter system set sga_target = 0 scope=both;

alter system set pga_aggregate_target = 0 scope=both;

