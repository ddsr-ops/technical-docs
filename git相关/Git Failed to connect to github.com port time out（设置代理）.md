# 症状

当提交`Git`并`Push`时，发生连接超时，通常来说和网络直接相关。
一般来说，多次尝试，你可能会成功；但是，如果`Push`列表中含大文件，例如`Pdf`，通常会失败。

# 解决

设置代理。

## 前置条件
能够FQ的代理

## 设置步骤
```
git bash here（如果使用Idea，在Terminal窗口）
git config --global http.proxy 127.0.0.1:1080为全局的 git 项目都设置代理
git config --local http.proxy 127.0.0.1:1080 为某个 git 项目单独设置代理
```

查看代理
```
git config --global http.proxy
```

取消代理
```
git config --global --unset http.proxy
```

若出现 OpenSSL SSL_read: Connection was reset, errno 10054的问题
打开Git命令页面，执行git命令脚本：修改设置，解除ssl验证
```
git config --global http.sslVerify "false"
```

[加速地址](https://github.com/fhefh2015/Fast-GitHub/issues/44)中记录的地址，只能用于加速`Clone`，不能用于`Push`