Python：OSError: [WinError 123] 文件名、目录名或卷标语法不正确。错误解决方法。
我的错误代码：

```
folder = "D:\aatest"
files = os.listdir(folder)
```

正确代码

```
folder = r"D:\aatest"
# 或者 folder = "D:\\aatest"
# 或者 folder = "D:/aatest"
files = os.listdir(folder)
```

错误原因：

因为在python中\是转义字符，Windows 路径如果只有一个\，会把他识别为转义字符。

可以用r''把他转为原始字符，也可以用\\,也可以用Linux的路径字符/。
