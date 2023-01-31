问题重现，输入命令

curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' -d "./acc.json"

报了如下的错误：
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

解决历程
1，按照报错更改json文件，在json文件最后加入了一个回车，增加了一个新行，执行命令，依然报相同错

2，尝试修改我的命令，修改后成为：

curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' --data-binary "./acc.json"

因为查到了，加载json文件时如果使用普通的-d方法加载文件会造成空行被忽略，也就是说我们加上去的新行并没有起作用，–data-binary数据二进制格式的加载方式，可以保证我们的空行还在，但是执行之后依然报错，相同的错

3，有点郁闷了，又查找一番，发现命令还存在错误，经修改如下：

`curl -XPOST -H 'Content-Type:application/json' 'xxxx:9200/bank/account/_bulk?pretty' --data-binary "@acc.json"`

发现，书写文件路径时，必须要以@开头，而不是平常的./或/等，至此文件成功加载，在head中也发现了数据，完美

注：命令中最后文件路径的双引号不必要，–data-binary @acc.json ，也一样可以成功执行命令