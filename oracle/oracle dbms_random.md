dbms_random是oracle提供的一个随机函数包,以下是它的一些常用的功能:

1、dbms_random.value

作用:生成一个大于等于0,大于等于1的随机的38位小数,代码如下:

select dbms_random.value random from dual

2、生成一个指定范围的随机数

select 
dbms_random.value(0,100) random
from dual

注:范围交换位置是可行的，返回的数字带小数点。

3、获取正态分布的随机数 

select dbms_random.normal from dual

4、获取随机的字符串

通过dbms.random.string(参数一,参数二),这个函数接受两个参数,第一个是随机字符串的类型,第二个是字符串的长度

字符串类型有以下几个:

(1)、'u','U' : upper case alpha characters only  大写字母

(2)、'L','l': lower case alpha characters only 小写字母

(3)、'a','A' : alpha characters only (mixed case) 大小写混合

(4)、'x','X' : any alpha-numeric characters (upper) 数字,大小写字母混合

(5)、'p','P' : any printable characters 数字、大小写字母、符号等混合

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