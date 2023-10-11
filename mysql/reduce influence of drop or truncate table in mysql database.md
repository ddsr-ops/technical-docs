# һ������

DBA�������truncate/dropʱż���ᵼ�����ݿ⺻ס�������Ǻ���ҵ��ϵͳ��һ����ס���������һ�ι��ϣ�����Ϊʲô�أ���ʲô�취�����أ�

# ����ԭ��

���truncate/dropʱ�������̻߳����ɴγ���buffer pool mutex��flush list mutex�����������̱߳�������

Ӱ����truncate/drop��ʱ�估��Χ��Ҫ�����¼���ԭ�򣨴�buffer pool + innodb_adaptive_hash_index����

1����������buffer pool����ҳ����

2������buffer pool��ҳ����(�ǲ�����)

3��������ibd�ļ���С

# �������ⷽʽ

�������ԭ������ִ��truncate/drop������������ԭ��

���Ƽ���1�������ȱ�����renameΪ backup_ ��ͬʱ����һ���±���һ�ܺ��ٲ��� backup_ �����Ծ��������ñ����ҳ������Ӱ�죨������÷�����һ�������ݶ�������ķ����������������ݵķ�����Ӱ���С����

2�������ڸñ��ҵ��ͷ��ڲ��������Ծ������͸ñ���buffer pool�е���ҳ������Ӱ�졣

3��������ҵ��ϵͳ�ĵͷ��ڲ��������Ծ�������������buffer pool����ҳ������Ӱ��

4������С��buffer poolԽС����ҳԽ�٣�����Խƽ�ȣ�����ʱ��Խ�̣������Ӱ��ԽС��

5����5.7�汾��drop+create����truncate�����ٷ��ĵ�truncate table Statementһ�ڣ���

ע����buffer pool �� innodb_adaptive_hash_index=onʱ��TRUNCATE TABLE����InnoDB�������Ӧ��ϣ������Ŀ��һ��bug(drop table�����Ѿ������bug)��(Bug #68184)

On a system with a large InnoDB buffer pool and innodb_adaptive_hash_index enabled,
TRUNCATE TABLE operations may cause a temporary drop in system performance due to an LRU
scan that occurs when removing an InnoDB table's adaptive hash index entries. The problem was
addressed for DROP TABLE in MySQL 5.5.23 (Bug #13704145, Bug #64284) but remains a known
issue for TRUNCATE TABLE (Bug #68184).

# �ġ��滻��ʽ��û������������֤����

�����ǲ���Ӳ���ӵ�һ�ַ�ʽ�������ɾ��ʱͻ����IO������Ӱ�죨ʵ�����������ô����󣩣�

1�����ļ�����ֱ��ɾ����˲ʱռ�ô���IO�����IO������ʹ��Ӳ���ӷ�ʽ�Ż���

2��ɾ��ϵͳ�������Ĵ��ļ���ʹ��seq��truncate�������ֱ��rm ɾ����ɵ�IO˲ʱ�߷塣

3�����slave�ϲ��ṩ����������Ĳ���ֻ��master�ϲ�����

```
shell# cd /opt/mysql3306/data/test && ll -th test*
-rw-r----- 1 mysql mysql 107G Mar 16 16:37 test.ibd
-rw-r----- 1 mysql mysql 8.5K Oct 16 21:59 test.frm
shell# ln test.ibd test.ibd.hdlk
shell# ll -th test*
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd.hdlk
-rw-r----- 1 mysql mysql 8.5K Oct 16 21:59 test.frm
mysql> drop table test;
shell# ll -th test*
-rw-r----- 2 mysql mysql 107G Mar 16 16:42 test.ibd.hdlk
shell# for i in `seq 107 -1 1`;do sleep 2;truncate -s ${i}G /opt/mysql3306/data/test/test.ibd.hdlk;done
```

ע�⣺��Ȼ��Щ��ʽ�ܽ��ʹ��truncate��drop��ҵ���Ӱ�죬����ǿ�ҽ���MySQL�ı�Ҫ����������������ݱ������ã����϶��޷����⣬�Ǹ�ʱ���������ת��������һ���ȽϷ��������飬��������ݼܹ���滮�ñ�������������ڣ������α��ķ�����