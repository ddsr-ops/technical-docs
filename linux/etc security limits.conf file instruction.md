```text
/etc/security/limits.conf ���������
һ�� /etc/security/limits.conf ���
/etc/security/limits.conf �ļ�ʵ���� Linux PAM������ʽ��֤ģ�飬Pluggable Authentication Modules���� pam_limits.so �������ļ�������ֻ����ڵ����Ự�� �����ò���Ӱ��ϵͳ�������Դ���ơ���Ҫע�� /etc/security/limits.d/ �����Ŀ¼��

/etc/security/limits.conf ���ý���
# /etc/security/limits.conf
#
#This file sets the resource limits for the users logged in via PAM.
���ļ�Ϊͨ��PAM��¼���û�������Դ���ơ�
#It does not affect resource limits of the system services.
#����Ӱ��ϵͳ�������Դ���ơ�
#Also note that configuration files in /etc/security/limits.d directory,
#which are read in alphabetical order, override the settings in this
#file in case the domain is the same or more specific.
��ע��/etc/security/limits.d�°�����ĸ˳�����е������ļ��Ḳ�� /etc/security/limits.conf�е�
domain��ͬ�ĵ�����
#That means for example that setting a limit for wildcard domain here
#can be overriden with a wildcard setting in a config file in the
#subdirectory, but a user specific setting here can be overriden only
#with a user specific setting in the subdirectory.
����ζ�ţ�����ʹ��ͨ�����domain�ᱻ��Ŀ¼����ͬ��ͨ������������ǣ�����ĳһ�û����ض�����
ֻ�ܱ���ĸ·���û������������ǡ���ʵ����ĳһ�û�A�����/etc/security/limits.conf�����ã���
/etc/security/limits.d��Ŀ¼�������ļ�Ҳ���û�A������ʱ����ôA��ĳЩ���ûᱻ���ǡ�����ȡ��ֵ�� /etc/security/limits.d �µ������ļ������á�

#
#Each line describes a limit for a user in the form:
#ÿһ������һ���û�����
#<domain> <type> <item> <value>

#Where:
#<domain> can be:
# - a user name    һ���û���
# - a group name, with @group syntax    �û����ʽΪ@GROUP_NAME
# - the wildcard *, for default entry    Ĭ������Ϊ*�����������û�
# - the wildcard %, can be also used with %group syntax,
# for maxlogin limit 
#
#<type> can have the two values:
# - "soft" for enforcing the soft limits 
# - "hard" for enforcing hard limits
��soft��hard��-��softָ���ǵ�ǰϵͳ��Ч������ֵ��������Ҳ�������Ϊ����ֵ��
hard����ϵͳ�������趨�����ֵ��soft�����Ʋ��ܱ�hard���Ƹߣ���-����ͬʱ������soft��hard��ֵ��
#<item> can be one of the following:    <item>����ʹ����ѡ���е�һ��
# - core - limits the core file size (KB)    �����ں��ļ��Ĵ�С��
# - data - max data size (KB)    ������ݴ�С
# - fsize - maximum filesize (KB)    ����ļ���С
# - memlock - max locked-in-memory address space (KB)    ��������ڴ��ַ�ռ�
# - nofile - max number of open file descriptors ���򿪵��ļ���(���ļ��������file descripter����) 
# - rss - max resident set size (KB) ���־����ô�С
# - stack - max stack size (KB) ���ջ��С
# - cpu - max CPU time (MIN)    ���CPUռ��ʱ�䣬��λΪMIN����
# - nproc - max number of processes ���̵������Ŀ
# - as - address space limit (KB) ��ַ�ռ����� 
# - maxlogins - max number of logins for this user    ���û������¼�������Ŀ
# - maxsyslogins - max number of logins on the system    ϵͳ���ͬʱ�����û���
# - priority - the priority to run user process with    �����û����̵����ȼ�
# - locks - max number of file locks the user can hold    �û����Գ��е��ļ������������
# - sigpending - max number of pending signals
# - msgqueue - max memory used by POSIX message queues (bytes)
# - nice - max nice priority allowed to raise to values: [-20, 19] max nice���ȼ�����������ֵ
# - rtprio - max realtime pr iority
#
#<domain> <type> <item> <value>
#

#* soft core 0
#* hard rss 10000
#@student hard nproc 20
#@faculty soft nproc 20
#@faculty hard nproc 50
#ftp hard nproc 0
#@st

/etc/security/limits.d/Ŀ¼
/etc/security/limits.d/ Ŀ¼
��Ŀ¼��Ĭ���� *-nproc.conf �ļ������ļ������������û����߳����ơ�����Ҳ�����ڸ�Ŀ¼���������ļ��� /etc/security/limits.d/ �£��� .conf ��β��
centos 7

��CentOS 7�汾��Ϊ/etc/security/limits.d/20-nproc.conf��

# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

*          soft    nproc     4096 # ���е��û�Ĭ�Ͽ��Դ����Ľ�����Ϊ 4096
root       soft    nproc     unlimited # root �û�Ĭ�Ͽ��Դ����Ľ����� �����Ƶġ�

CentOS 6

��CentOS 6�汾��Ϊ/etc/security/limits.d/90-nproc.conf

���� ulimit �������
����ע������
ע�ⲻ������ nofile�������� unlimited��noproc����.
������������ nofile�������� unlimited �����ǽ��� ssh ��¼���ǵ�¼���˵ģ����ұ�����������ݡ�

Dec  1 14:57:57 localhost sshd[1543]: pam_limits(sshd:session): Could not set limit for 'nofile': Operation not permitted

���������õ� nofile ��ֵ�������õ����ֵΪ 1048576(2**20)�����õ�ֵ���ڸ������ͻ���е�¼���ˡ�Ҳ����ʾ����ĵ�¼����(�ײ�)

��������
���ǲ������е�����������/etc/security/limits.conf ���ǽ����÷��� /etc/security/limits.d/ �¡�
�������ǽ� nofile�����÷��� /etc/security/limits.d/20-nofile.conf ��nproc �����÷��� /etc/security/limits.d/20-nproc.conf.

һ��������Ҫ���õ� /etc/security/limits.d/20-nofile.conf Ϊ��

root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
/etc/security/limits.d/20-nproc.conf ����Ϊ

*    -     nproc   65535
root soft  nproc  unlimited
root hard  nproc  unlimited
ע�⸲�ǵ�����⡣
ʾ��һ��
�� /etc/security/limits.conf ������:

root soft nofile 65538
root hard nofile 65538
* soft nofile 65539
* hard nofile 65539
���root �û��� Ĭ��ȡֵ�� 65538 ��* ͳ�����Ȼ�� root ���ú��棬���� root ������ֻ�ܱ� root ���и��ǡ�

���ǿ���������ã����������õ�ʱ��

root soft nofile 65538
root hard nofile 65538
* soft nofile 65539
* hard nofile 65539
root soft nofile 65539
����� root �û���ȡֵ���� 65538 ����Ϊ��Ȼ root soft nofile 65539 �Ḳ������֮ǰ�����ã�������������ǲ���Ч�ġ���Ϊ root soft nofile 65539 ���õ�ֵ����root hard nofile 65538 , soft ���õ�ֵ���ܴ��� hard.

ʾ������
�������� /etc/security/limits.conf ������:

root soft nofile 65538
root hard nofile 65538
* soft nofile 65539
* hard nofile 65539
Ȼ�������� /etc/security/limits.d/20-nofile.conf �����ˣ�

root soft nofile 65536
root hard nofile 65536
* soft nofile 65540
* hard nofile 65540
����ȡֵ�ǻ�ȡ /etc/security/limits.d/20-nofile.conf �����ֵ��

���ã�ֻ�ܱ��ض����ǡ�
/etc/security/limits.d/ ���ļ�����ͬ���ÿ��Ը��� /etc/security/limits.conf
soft��hard��Ҫ����������,������Ч��
nofile�������� unlimited
nofile�������õ����ֵΪ 1048576(2**20)�����õ�ֵ���ڸ������ͻ���е�¼���ˡ�
soft ���õ�ֵ һ��ҪС�ڻ���� hard ��ֵ��
������ϸ���ø���Ӧ������������á�

����ulimit ���ú���Ч
��ʱ����
���ÿ��Դ��ļ��������Ϊ 65536

ulimit  -SHn  65536
������ʧЧ��

��������
���õ������ļ�/etc/security/limits.conf���� /etc/security/limits.d/ �С�
Ȼ���˳���ǰ�Ự�����µ�¼�� ������Ч����������Ҳ�ᱣ����

���ò���Ч������
2020��3�·ݲ���
SSH ��½ limits ���ò���Ч����취

�ġ�ulimit ��������
      -S	use the `soft' resource limit # ����������
      -H	use the `hard' resource limit # ����Ӳ����
      -a	all current limits are reported# ��ʾ���е����á�
      -b	the socket buffer size # ����socket buffer �����ֵ��
      -c	the maximum size of core files created # ����core�ļ������ֵ.
      -d	the maximum size of a process's data segment  # �����߳����ݶε����ֵ
      -e	the maximum scheduling priority (`nice') # �������������ȼ�
      -f	the maximum size of files written by the shell and its children # �����ļ������ֵ��
      -i	the maximum number of pending signals # �������ĵȴ��ź�
      -l	the maximum size a process may lock into memory #�������ڴ����������̵����ֵ
      -m	the maximum resident set size 
      -n	the maximum number of open file descriptors # ���������ԵĴ��ļ���������
      -p	the pipe buffer size
      -q	the maximum number of bytes in POSIX message queues
      -r	the maximum real-time scheduling priority
      -s	the maximum stack size
      -t	the maximum amount of cpu time in seconds
      -u	the maximum number of user processes  # �����û����Դ���������������
      -v	the size of virtual memory  # ���������ڴ�����ֵ
      -x	the maximum number of file locks

�鿴����
�鿴���е�����

ulimit  -a
�鿴���õ������ļ���

ulimit  -n

��������

ulimit  -SHn  65536

```