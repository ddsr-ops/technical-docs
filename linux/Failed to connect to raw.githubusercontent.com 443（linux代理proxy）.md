��������

```curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused```

443 �˿����ӱ���һ������Ϊǽ��ԭ���������Կ�ѧ������Virtual Private Network���Ļ����������м���������ִ�У�

```
# 7890 �� 789 ��Ҫ�������Լ��Ķ˿�
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7891

export https_proxy=http://192.168.15.1:7890 http_proxy=http://192.168.15.1:7890 all_proxy=socks5://192.168.15.1:7891
```

�ٴ�ִ��֮ǰ���� http://raw.githubusercontent.com:443 ���ܾ�������Ӧ�þͳɹ��ˡ�

ע�⣬ȷ�������������������ǳ�ͨ�� �������ʣ����ѯ�����ĵ���vmware virtual machine can not ping host��������޷�pingͨ������.md��

�ر�ע�⣺���ʹ�õ�clashR for wins����������������
