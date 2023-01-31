打开Preferences–>Editor–>Inspections，然后在右侧输入UID进行搜索(搜索方式比较快，也可以在java–>Serialization issues里找)。然后勾选Serializable class without 'serialVersionUID'后面的复选框。右侧Severity默认Warning即可


为什么需要serialVersionUID, 可以参考[serialVersionUID的作用](https://developer.aliyun.com/article/6770)