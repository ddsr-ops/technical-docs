# 表现
```text
Error response from daemon: error creating overlay mount to /var/lib/docker/overlay2/67fc837e52765051b9f1559ac561a6f196aa0e88521909dc3352c7409d2e0236/merged: invalid argument
Error: failed to start containers: jieba
```

# 解决
这个问题的是由于selinux造成的

CentOS的selinux是关闭的，而docker上的selinux却是开启的，因此docker运行时会产生如上错误。

解决方案无非是要么都关闭，要么都开启。参看https://github.com/coreos/bugs/issues/2340， 推荐修改crntOS下的/etc/selinux/config 将SELINUX=disabled 改成 SELINUX=permissive，至少腾讯云的CoreOs就是这样子的。

另外docker 18.09已经废弃使用overlay了，overlay2存储才是今后所支持的.