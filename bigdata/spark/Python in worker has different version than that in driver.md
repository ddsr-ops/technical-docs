Python in worker has different version 2.7 than that in driver 3.6



```python
from pyspark import SparkContext
 
# ��������Ϊ��������
import os
os.environ["PYSPARK_PYTHON"]="/usr/bin/python3" # ����ʵ��λ��ָ��
os.environ["PYSPARK_DRIVER_PYTHON"]="/usr/bin/python3"
```