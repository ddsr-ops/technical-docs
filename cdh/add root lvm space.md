In production env, LVM `/dev/centos/root` space is all allocated.
So use the following commands to extend path `/` space

```vgdisplay -v
lvextend -L +300G /dev/centos/root
xfs_growfs  /dev/centos/root

lvextend -L +300G /dev/centos00/root
xfs_growfs  /dev/centos00/root```