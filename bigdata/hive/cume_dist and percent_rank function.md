```text
CUME_DIST
�CCUME_DIST С�ڵ��ڵ�ǰֵ������/������������
�C���磬ͳ��С�ڵ��ڵ�ǰнˮ����������ռ�������ı���

SELECT 
dept,
userid,
sal,
CUME_DIST() OVER(ORDER BY sal) AS rn1,
CUME_DIST() OVER(PARTITION BY dept ORDER BY sal) AS rn2 
FROM lxw1234;
 
dept    userid   sal   rn1       rn2 
-------------------------------------------
d1      user1   1000    0.2     0.3333333333333333
d1      user2   2000    0.4     0.6666666666666666
d1      user3   3000    0.6     1.0
d2      user4   4000    0.8     0.5
d2      user5   5000    1.0     1.0
 
rn1: û��partition,�������ݾ�Ϊ1�飬������Ϊ5��
     ��һ�У�С�ڵ���1000������Ϊ1����ˣ�1/5=0.2
     �����У�С�ڵ���3000������Ϊ3����ˣ�3/5=0.6
rn2: ���ղ��ŷ��飬dpet=d1������Ϊ3,
     �ڶ��У�С�ڵ���2000������Ϊ2����ˣ�2/3=0.6666666666666666
     
     

PERCENT_RANK
�CPERCENT_RANK �����ڵ�ǰ�е�RANKֵ-1/������������-1
Ӧ�ó������˽⣬������һЩ�����㷨��ʵ���п����õ��ɡ�

SELECT 
dept,
userid,
sal,
PERCENT_RANK() OVER(ORDER BY sal) AS rn1,   --������
RANK() OVER(ORDER BY sal) AS rn11,          --������RANKֵ
SUM(1) OVER(PARTITION BY NULL) AS rn12,     --������������
PERCENT_RANK() OVER(PARTITION BY dept ORDER BY sal) AS rn2 
FROM lxw1234;
 
dept    userid   sal    rn1    rn11     rn12    rn2
---------------------------------------------------
d1      user1   1000    0.0     1       5       0.0
d1      user2   2000    0.25    2       5       0.5
d1      user3   3000    0.5     3       5       1.0
d2      user4   4000    0.75    4       5       0.0
d2      user5   5000    1.0     5       5       1.0
 
rn1: rn1 = (rn11-1) / (rn12-1) 
	   ��һ��,(1-1)/(5-1)=0/4=0
	   �ڶ���,(2-1)/(5-1)=1/4=0.25
	   ������,(4-1)/(5-1)=3/4=0.75
rn2: ����dept���飬
     dept=d1��������Ϊ3
     ��һ�У�(1-1)/(3-1)=0
     �����У�(3-1)/(3-1)=1

```