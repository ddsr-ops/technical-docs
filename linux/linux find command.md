Linuxϵͳ����find�����������޸Ĺ����ļ�

���Linux���ն��ϣ�û��windows�������������õ�ͼ�ν��湤�ߣ���find����ȷ�Ǻ�ǿ��ġ���ʱ�����Ҳ�в��� -atime ����ʱ�� -ctime �ı�״̬��ʱ�� -mtime�޸ĵ�ʱ�䡣��Ҫע�⣬�����ʱ������24СʱΪ��λ�ġ�

�������24Сʱ���޸Ĺ����ļ���

find ./ -mtime 0

����ǰ48~24Сʱ�޸Ĺ����ļ���������48Сʱ�����޸Ĺ����ļ���

find ./ -mtime 1

�������30�����޸ĵĵ�ǰĿ¼�µ�.php�ļ�

find . -name ��*.php�� -mmin -30

�������24Сʱ�޸ĵĵ�ǰĿ¼�µ�.php�ļ�

find . -name ��*.php�� -mtime 0

�������24Сʱ�޸ĵĵ�ǰĿ¼�µ�.php�ļ������г���ϸ��Ϣ

find . -name ��*.inc�� -mtime 0 -ls

���ҵ�ǰĿ¼�£����24-48Сʱ�޸Ĺ��ĳ����ļ���

find . -type f -mtime 1

���ҵ�ǰĿ¼�£����1��ǰ�޸Ĺ��ĳ����ļ���

find . -type f -mtime +1

���Ӽ���find����ʹ��ʵ��

find -name april* #�ڵ�ǰĿ¼�²�����april��ʼ���ļ�

find -name april* fprint file #�ڵ�ǰĿ¼�²�����april��ʼ���ļ������ѽ�������file��

find -name ap* -o -name may* #������ap��may��ͷ���ļ�

find /mnt -name tom.txt -ftype vfat #��/mnt�²�������Ϊtom.txt���ļ�ϵͳ����Ϊvfat���ļ�

find /mnt -name t.txt ! -ftype vfat #��/mnt�²�������Ϊtom.txt���ļ�ϵͳ���Ͳ�Ϊvfat���ļ�

find /tmp -name wa* -type l #��/tmp�²�����Ϊwa��ͷ������Ϊ�������ӵ��ļ�

find /home -mtime -2 #��/home�²���������ڸĶ������ļ�

find /home -atime -1 #��1��֮�ڱ���ȡ�����ļ�

find /home -mmin +60 #��/home�²�60����ǰ�Ķ������ļ�

find /home -amin +30 #�����30����ǰ����ȡ�����ļ�

find /home -newer tmp.txt #��/home�²����ʱ���tmp.txt�����ļ���Ŀ¼

find /home -anewer tmp.txt #��/home�²��ȡʱ���tmp.txt�����ļ���Ŀ¼

find /home -used -2 #�г��ļ���Ŀ¼���Ķ���֮����2���ڱ���ȡ�����ļ���Ŀ¼

find /home -user cnscn #�г�/homeĿ¼�������û�cnscn���ļ���Ŀ¼

find /home -uid +501 #�г�/homeĿ¼���û���ʶ�������501���ļ���Ŀ¼

find /home -group cnscn #�г�/home����Ϊcnscn���ļ���Ŀ¼

find /home -gid 501 #�г�/home����idΪ501���ļ���Ŀ¼

find /home -nouser #�г�/home�ڲ����ڱ����û����ļ���Ŀ¼

find /home -nogroup #�г�/home�ڲ����ڱ�������ļ���Ŀ¼

find /home -name tmp.txt -maxdepth 4 #�г�/home�ڵ�tmp.txt ��ʱ������Ϊ3��

find /home -name tmp.txt -mindepth 3 #�ӵ�2�㿪ʼ��

find /home -empty #���Ҵ�СΪ0���ļ����Ŀ¼

find /home -size +512k #�����512k���ļ�

find /home -size -512k #��С��512k���ļ�

find /home -links +2 #��Ӳ����������2���ļ���Ŀ¼

find /home -perm 0700 #��Ȩ��Ϊ700���ļ���Ŀ¼

find /tmp -name tmp.txt -exec cat {} ; #��/tmpĿ¼�в���tmp.txt�ļ�����

find /tmp -name tmp.txt -ok rm {} ; #��/tmpĿ¼�в���tmp.txt�ļ���ɾ������

find / -amin -10 # ������ϵͳ�����10���ӷ��ʵ��ļ�

find / -atime -2 # ������ϵͳ�����48Сʱ���ʵ��ļ�

find / -empty # ������ϵͳ��Ϊ�յ��ļ������ļ���

find / -group cat # ������ϵͳ������ groupcat���ļ�

find / -mmin -5 # ������ϵͳ�����5�������޸Ĺ����ļ�

find / -mtime -1 #������ϵͳ�����24Сʱ���޸Ĺ����ļ�

find / -nouser #������ϵͳ�����������û����ļ�

find / -user fred #������ϵͳ������FRED����û����ļ�