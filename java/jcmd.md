# �鿴�������е� Java ����ID�����ƺ� main ��������
jcmd

# �鿴ĳ������֧�ֵ�����
��jcmd ����Ͻ��� ID��Ȼ����� help ��
$ jcmd 10614 help

#�鿴ĳ�����̵� JVM �汾
$ jcmd 10614 VM.version
10614:
Java HotSpot(TM) 64-Bit Server VM version 9.0.1+11
JDK 9.0.1

#�鿴 JVM ������Ϣ
$ jcmd 10614 VM.info

#������̽�����������
$ jcmd 10614 GC.run

#��ȡ���ͳ����Ϣ
$ jcmd 10614 GC.class_histogram | more
���Կ�������������������ռ�ÿռ�ȡ�

#��ȡ��������
$ jcmd 10614 VM.flags

#��ȡ���̵����������˶೤ʱ��
$ jcmd 10614 VM.uptime

#�鿴�߳���Ϣ
$ jcmd 10614 Thread.print

#��ȡ�����������
$ jcmd 10614 PerfCounter.print

#�����ѿ��յ���ǰĿ¼
$ jcmd 10614 GC.heap_dump $PWD/heap.dump