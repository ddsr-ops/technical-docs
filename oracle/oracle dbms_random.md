dbms_random��oracle�ṩ��һ�����������,����������һЩ���õĹ���:

1��dbms_random.value

����:����һ�����ڵ���0,���ڵ���1�������38λС��,��������:

select dbms_random.value random from dual

2������һ��ָ����Χ�������

select 
dbms_random.value(0,100) random
from dual

ע:��Χ����λ���ǿ��еģ����ص����ִ�С���㡣

3����ȡ��̬�ֲ�������� 

select dbms_random.normal from dual

4����ȡ������ַ���

ͨ��dbms.random.string(����һ,������),�������������������,��һ��������ַ���������,�ڶ������ַ����ĳ���

�ַ������������¼���:

(1)��'u','U' : upper case alpha characters only  ��д��ĸ

(2)��'L','l': lower case alpha characters only Сд��ĸ

(3)��'a','A' : alpha characters only (mixed case) ��Сд���

(4)��'x','X' : any alpha-numeric characters (upper) ����,��Сд��ĸ���

(5)��'p','P' : any printable characters ���֡���Сд��ĸ�����ŵȻ��

select 
dbms_random.string('u',10) 
from dual 
union all 
select 
dbms_random.string('l',10) 
from dual 
union all  
select 
dbms_random.string('a',10) 
from dual 
union all 
select 
dbms_random.string('x',10) 
from dual 
union all 
select 
dbms_random.string('P',10) 
from dual 