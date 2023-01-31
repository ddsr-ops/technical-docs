Python in worker has different version 2.7 than that in driver 3.6



```python
from pyspark import SparkContext
 
# 以下三行为新增内容
import os
os.environ["PYSPARK_PYTHON"]="/usr/bin/python3" # 根据实际位置指定
os.environ["PYSPARK_DRIVER_PYTHON"]="/usr/bin/python3"
```