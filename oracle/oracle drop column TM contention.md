Oracle drop column ����ɱ����TM-contention, **�����ñ��DML����**

���ڴ��Ĳ���ɾ���ֶΣ���ؽ���С�ģ��ܲ�ɾ������ɾ��


## ����һ��ֱ��drop column
����ҵ��ģ����򣬿�ʼ����������־��Ȼ��ɾ�������ֶΡ�

```sql
alter table t_test_col drop column vard;
```

Ӱ�췶Χ��

1. drop column������ʱ30���롣

2. <u>insert �����drop column���֮ǰ�޷�ִ�У��ȴ��¼�Ϊenq:TM-contention��</u>

3. select����Ӱ�졣


## ����������set unusedȻ����drop

```sql
alter table t_test_col set unused column vard;
alter table t_test_col drop unused columns;
```

set unused�����±�������ֵ䣬�Ƚ��ֶ���Ϊ������״̬��drop unused����ʱ�Ÿ����������ݡ�

Ӱ�췶Χ��

�볡��һ��ȫ��ͬ��

ע���������ַ�ʽ��������һ���ǳ��鷳�����⣬��ִ��drop column�Ĺ����У���Ҫ�޸�ÿһ�����ݣ�����ʱ�������ر𳤣�������Ĵ�����undo��ռ䣬
������ر�󣬲���ʱ���㹻����undo��ռ��ȫ���ľ���Ϊ�˽��������⣬���˵����ֳ�����


## ����������set unusedȻ����drop column checkpoint
```sql
alter table t_test_col set unused column vard;
alter table t_test_col drop unused columns checkpoint 1000;
```

drop unused columns checkpoint������ÿɾ����������¼����һ���ύ������UNDO������
����һ���õĽ��˼·�������������ķ���Ҳ�Ƿǳ���ġ���������ڼ��(interval)������ִ�л�����
BUG��20598042��ALTER TABLE DROP COLUMN �� CHECKPOINT on an INTERVAL PARTITIONED table fails with ORA-600 [17016]��

ִ�н���ǣ�

1. drop column checkpoint�����ᱨORA-600[17016]����

2. ����Ͳ�ѯ��������drop�����Լ�drop����֮�󣬾��׳�ORA-12986�쳣��

3. �ڴ򲹶��޸�bug֮ǰ��������޷�����ʹ�á�

������ͨ��������set unusedȻ����drop column checkpoint��

```sql
alter table t_test_col_2 set unused column vard;
alter table t_test_col_2 drop unused columns checkpoint 1000;
```

Ӱ�췶Χ��

1. <u>insert ��select��drop column�������֮ǰ���޷�ִ�С�</u>

2. �ȴ��¼�Ϊlibrary cache lock��


## ������: ʹ��DBMS_REDEFINITION��ɾ���ֶ�
```sql
create table T_TEST_COL_3
as select ids,dates,vara,varb,varc,vard  from t_test_col_2;

create table T_TEST_COL_mid
(
  ids   NUMBER,
  dates DATE,
  vara  VARCHAR2(2000),
  varb  VARCHAR2(2000),
  varc  VARCHAR2(2000)
);

BEGIN
   DBMS_REDEFINITION.CAN_REDEF_TABLE('ENMOTEST','T_TEST_COL_3', DBMS_REDEFINITION.CONS_USE_ROWID);
END;
/
BEGIN
   DBMS_REDEFINITION.START_REDEF_TABLE(
         uname => 'ENMOTEST',
         orig_table => 'T_TEST_COL_3',
         int_table => 'T_TEST_COL_MID',
         col_mapping => 'IDS IDS, DATES DATES, VARA VARA,VARB VARB,VARC VARC',
         options_flag => DBMS_REDEFINITION.CONS_USE_ROWID);
END;
/

DECLARE
    error_count pls_integer := 0;
BEGIN
DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS('ENMOTEST',
                   'T_TEST_COL_3',
                   'T_TEST_COL_MID',
                    dbms_redefinition.cons_orig_params ,
                   TRUE,
                   TRUE,
                   TRUE,
                   FALSE,
                   error_count);
    DBMS_OUTPUT.PUT_LINE('errors := ' || TO_CHAR(error_count));
END;
/
BEGIN dbms_redefinition.finish_redef_table('ENMOTEST','T_TEST_COL_3','T_TEST_COL_MID');  END;
DROP TABLE T_TEST_COL_MID;
```

Ӱ�췶Χ��

1. <u>�м��Ĵ�С��ԭ���൱(��Ҫ�ķѺܴ�Ŀռ估���������鵵��־)��</u>

2. ������insert��������select��ʱ��һ��࣬�ȴ��¼����ܿ���ֻ�зǳ����ݵ�TM���������


## ������: �жϲ���
�ڳ���һ����������ִ�й����У�ͻȻ�жϻỰ���۲��жϺ�����.

1. ֱ��drop column���жϺ�������ʹ�ã��ֶ���Ȼ����

2. ��set unused����drop unused columns���ֶ�set֮��Ͳ鲻���ˣ��жϺ󣬱������ʹ��

3. *��set unused����drop unused columns checkpoint���жϺ�insert��select����ORA-12986������ʾ����ִ��alter table drop columns continue��������������������*


## �����ܽ�:
1. ����������ִ��drop column�Ǻ�Σ�յģ��������Ҫ�Ļ��������ܴ�ı��������ƻ�ͣ��ʱ�䴰�ڽ���ά����

2. drop unused columns checkpoint��Ȼ�ܽ���ع���ռ�ù��ߵ����⣬���ǻ�������ɻ��˵ķ��ա�
   ����Ƿǳ���ı�ֻ���������꣬�����ܵĹ����У����в����޷����У��⽫����ɷǳ���ʱ���ҵ���жϡ�

3. ҵ��ѹ�������ϵͳ�ɲ���dbms_redefinition�����ض��������ֻ����finish��һ�����ֺܶ�ʱ���������
������ײ����õ��ﻯ��ͼ����������ˢ�£��ǳ��������ܣ�Ҳ���Ƽ����ַ�ʽ��

4. ���������ִ��drop unused columns checkpoint����bug��һ��������ͬ��������ǳ����ͣ�����ա�


## ���ۣ�
��ȻOracle�ܺܿ���������ֶΣ�ȴ�޷��������ɾ���ֶΡ�����4�ַ�ʽ��ɾ���ֶξ������˷ǳ����Ӱ�죬�Ҳ��ɿأ�