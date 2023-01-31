*好记性不如烂笔头*

When virtual machine in vmware can not ping host, we should check step by step.

1. Disable selinux, `SELINUX=disabled` in `/etc/selinux/config`

2. Shutdown firewalld via `systemctl stop firewalld`, then disable automatic-starting by using `systemctl disable firewalld`

3. At last, we would ensure firewalld in the host must be closed