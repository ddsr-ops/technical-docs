**Symptom**

Error response from daemon: oci runtime error: container_linux.go:235: starting container process

container_linux.go:235: starting container process caused “process_linux.go:258: applying cgroup configuration for process caused “Cannot set property TasksAccounting, or unknown property.””
/usr/bin/docker-current: Error response from daemon: oci runtime error: container_linux.go:235: starting container process caused "process_linux.go:258: applying cgroup configuration for process caused "Cannot set property TasksAccounting, or unknown prop

解决：
yum update && docker start container-name