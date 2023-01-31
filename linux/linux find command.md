Linux系统下用find命令查找最近修改过的文件

简介Linux的终端上，没有windows的搜索那样好用的图形界面工具，但find命令确是很强大的。按时间查找也有参数 -atime 访问时间 -ctime 改变状态的时间 -mtime修改的时间。但要注意，这里的时间是以24小时为单位的。

查找最近24小时内修改过的文件。

find ./ -mtime 0

查找前48~24小时修改过的文件。而不是48小时以内修改过的文件。

find ./ -mtime 1

查找最近30分钟修改的当前目录下的.php文件

find . -name ‘*.php’ -mmin -30

查找最近24小时修改的当前目录下的.php文件

find . -name ‘*.php’ -mtime 0

查找最近24小时修改的当前目录下的.php文件，并列出详细信息

find . -name ‘*.inc’ -mtime 0 -ls

查找当前目录下，最近24-48小时修改过的常规文件。

find . -type f -mtime 1

查找当前目录下，最近1天前修改过的常规文件。

find . -type f -mtime +1

附加几个find命令使用实例

find -name april* #在当前目录下查找以april开始的文件

find -name april* fprint file #在当前目录下查找以april开始的文件，并把结果输出到file中

find -name ap* -o -name may* #查找以ap或may开头的文件

find /mnt -name tom.txt -ftype vfat #在/mnt下查找名称为tom.txt且文件系统类型为vfat的文件

find /mnt -name t.txt ! -ftype vfat #在/mnt下查找名称为tom.txt且文件系统类型不为vfat的文件

find /tmp -name wa* -type l #在/tmp下查找名为wa开头且类型为符号链接的文件

find /home -mtime -2 #在/home下查最近两天内改动过的文件

find /home -atime -1 #查1天之内被存取过的文件

find /home -mmin +60 #在/home下查60分钟前改动过的文件

find /home -amin +30 #查最近30分钟前被存取过的文件

find /home -newer tmp.txt #在/home下查更新时间比tmp.txt近的文件或目录

find /home -anewer tmp.txt #在/home下查存取时间比tmp.txt近的文件或目录

find /home -used -2 #列出文件或目录被改动过之后，在2日内被存取过的文件或目录

find /home -user cnscn #列出/home目录内属于用户cnscn的文件或目录

find /home -uid +501 #列出/home目录内用户的识别码大于501的文件或目录

find /home -group cnscn #列出/home内组为cnscn的文件或目录

find /home -gid 501 #列出/home内组id为501的文件或目录

find /home -nouser #列出/home内不属于本地用户的文件或目录

find /home -nogroup #列出/home内不属于本地组的文件或目录

find /home -name tmp.txt -maxdepth 4 #列出/home内的tmp.txt 查时深度最多为3层

find /home -name tmp.txt -mindepth 3 #从第2层开始查

find /home -empty #查找大小为0的文件或空目录

find /home -size +512k #查大于512k的文件

find /home -size -512k #查小于512k的文件

find /home -links +2 #查硬连接数大于2的文件或目录

find /home -perm 0700 #查权限为700的文件或目录

find /tmp -name tmp.txt -exec cat {} ; #在/tmp目录中查找tmp.txt文件并打开

find /tmp -name tmp.txt -ok rm {} ; #在/tmp目录中查找tmp.txt文件并删除它们

find / -amin -10 # 查找在系统中最后10分钟访问的文件

find / -atime -2 # 查找在系统中最后48小时访问的文件

find / -empty # 查找在系统中为空的文件或者文件夹

find / -group cat # 查找在系统中属于 groupcat的文件

find / -mmin -5 # 查找在系统中最后5分钟里修改过的文件

find / -mtime -1 #查找在系统中最后24小时里修改过的文件

find / -nouser #查找在系统中属于作废用户的文件

find / -user fred #查找在系统中属于FRED这个用户的文件