[Reference](https://stonedb.io/zh/docs/performance-tuning/os-tuning)

# ����ϵͳ�Ż�
����ϵͳ�Ż�������Linux��**ʾ������������� CentOS 7.x**��

## �ر�SElinux�ͷ���ǽ
�ر�SElinux�ͷ���ǽ��Ŀ���Ǵ򿪲�������ͨ�ţ�ʹ��һЩ����˿�Ĭ���ǿ����ġ�
```shell
systemctl stop firewalld 
systemctl disable firewalld
vi /etc/selinux/config
#�޸�SELINUX��ֵ
SELINUX = disabled
```

## I/O����ģʽ
����ǻ�е�̣�����ΪDeadline��Ŀ�������I/O������������ǹ�̬�̣�����Ϊnoop��
```shell
dmesg | grep -i scheduler
grubby --update-kernel=ALL --args="elevator=noop"
```

## ������ʹ��swap
��������ڴ治�㣬������ʹ��swap��Ϊ����������Ϊ��swap��ʹ�ã�˵������ϵͳ�Ѿ����������ص��������⣬������vm.swappiness������Сֵ��
```shell
vi /etc/sysctl.conf
#����vm.swappiness = 0
vm.swappiness = 0
```

## �ر�NUMA
���NUMA node�����ڴ�ʹ�ò����⣬��ʹ�����ڴ��ܵĿ��������ܶ࣬����ϵͳҲҪ���ڴ���գ����յĹ��̶Բ���ϵͳ����Ӱ��ġ��ر�NUMA��Ҫ��Ϊ�˸��õķ����ʹ���ڴ档
```shell
grubby --update-kernel=ALL --args="numa=off"
```

## �ر�͸����ҳ
͸����ҳ�Ƕ�̬����ģ������ݿ���ڴ����ģʽ��ϡ��ģ����������������ڴ���Ƭ���Ƚ�����ʱ����̬����͸����ҳ����ֽϴ���ӳ٣�CPUʹ���ʻ���ּ���Լ�����������˽���ر�͸����ҳ��
```shell
cat /sys/kernel/mm/transparent_hugepage/enabled
vi /etc/default/grub
GRUB_CMDLINE_LINUX="xxx transparent_hugepage=never"
grub2-mkconfig -o /boot/grub2/grub.cfg
```