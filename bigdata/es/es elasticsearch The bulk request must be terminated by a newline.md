�������֣���������

curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' -d "./acc.json"

�������µĴ���
```text

{
  "error" : {
    "root_cause" : [
      {
        "type" : "illegal_argument_exception",
        "reason" : "The bulk request must be terminated by a newline [\n]"
      }
    ],
    "type" : "illegal_argument_exception",
    "reason" : "The bulk request must be terminated by a newline [\n]"
  },
  "status" : 400
}
```

�������
1�����ձ������json�ļ�����json�ļ���������һ���س���������һ�����У�ִ�������Ȼ����ͬ��

2�������޸��ҵ�����޸ĺ��Ϊ��

curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' --data-binary "./acc.json"

��Ϊ�鵽�ˣ�����json�ļ�ʱ���ʹ����ͨ��-d���������ļ�����ɿ��б����ԣ�Ҳ����˵���Ǽ���ȥ�����в�û�������ã��Cdata-binary���ݶ����Ƹ�ʽ�ļ��ط�ʽ�����Ա�֤���ǵĿ��л��ڣ�����ִ��֮����Ȼ������ͬ�Ĵ�

3���е������ˣ��ֲ���һ��������������ڴ��󣬾��޸����£�

`curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' --data-binary "@acc.json"`

���֣���д�ļ�·��ʱ������Ҫ��@��ͷ��������ƽ����./��/�ȣ������ļ��ɹ����أ���head��Ҳ���������ݣ�����

ע������������ļ�·����˫���Ų���Ҫ���Cdata-binary @acc.json ��Ҳһ�����Գɹ�ִ������