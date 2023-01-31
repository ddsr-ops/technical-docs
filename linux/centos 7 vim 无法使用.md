vim: error while loading shared libraries: /lib64/libgpm.so.2: file too short


yum provides *libgpm.so.2

rpm -qa|grep libgpm|xargs yum remove

yum remove -y vim*

yum install -y vim