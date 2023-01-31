[reference](https://www.cnblogs.com/lijiaman/p/11872845.html)

```oraclesqlplus

-- 按天（日）创建分区
CREATE TABLE interval_day_table01
(
  employee_id         NUMBER,
  employee_name       VARCHAR2(20),
  birthday            DATE    
)
PARTITION BY RANGE(birthday)
INTERVAL (NUMTODSINTERVAL(1,'day')) STORE IN (tbs01,tbs02,tbs03)
(
  PARTITION partition20140101 VALUES LESS THAN(to_date('2014-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss'))
);


-- 创建按月分区表

CREATE TABLE interval_month_table01
(
  employee_id         NUMBER,
  employee_name       VARCHAR2(20),
  birthday            DATE    
)
PARTITION BY RANGE(birthday)
INTERVAL (NUMTOYMINTERVAL(1,'month')) STORE IN (tbs01,tbs02,tbs03)
(
  PARTITION partition201401 VALUES LESS THAN(to_date('2014-02-01:00:00:00','yyyy-mm-dd hh24:mi:ss'))
);
```