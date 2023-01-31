# 问题
> Error response from daemon: oci runtime error: container_linux.go:235: starting container process caused "container init exited prematurely"
Error: failed to start containers: e79

# 解决
因为原来映射（-v）的文件夹不存在了，重新创建即可