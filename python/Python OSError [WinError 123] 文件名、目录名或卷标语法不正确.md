Python��OSError: [WinError 123] �ļ�����Ŀ¼�������﷨����ȷ��������������
�ҵĴ�����룺

```
folder = "D:\aatest"
files = os.listdir(folder)
```

��ȷ����

```
folder = r"D:\aatest"
# ���� folder = "D:\\aatest"
# ���� folder = "D:/aatest"
files = os.listdir(folder)
```

����ԭ��

��Ϊ��python��\��ת���ַ���Windows ·�����ֻ��һ��\�������ʶ��Ϊת���ַ���

������r''����תΪԭʼ�ַ���Ҳ������\\,Ҳ������Linux��·���ַ�/��
