dm-* devices are made by LVM.

It's part of the device mapper in the kernel, used by LVM. Use dmsetup ls to see what is behind it.

```shell
[root@namenode1 ~]# dmsetup ls
centos-home	(253:2)
centos-swap	(253:1)
centos-root	(253:0)
[root@namenode1 ~]# sudo lvdisplay|awk  '/LV Name/{n=$3} /Block device/{d=$3; sub(".*:","dm-",d); print d,n;}'
dm-0 root
dm-2 home
dm-1 swap
```