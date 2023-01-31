[Official reference](https://datahubproject.io/docs/quickstart)

Before beginning, we have to take some actions.
* Install docker and docker-compose, simultaneously set proper docker mirror, 
  refer to local readme file(error pulling image configuration unknown blob.md).
* Ensure that the clock time of the server with docker env is right, refer to local readme file 
  (docker pull was failed due to unauthorized authentication required.md).
* Configuring pip.conf is essential. 

In the [Official reference](https://datahubproject.io/docs/quickstart), when pulling images, some https errors
(such as SSL) occur, add the IP to /etc/hosts.

```
[root@hadoop-193 ~]# ping raw.githubusercontent.com
PING raw.githubusercontent.com (185.199.108.133) 56(84) bytes of data.
64 bytes from raw.githubusercontent.com (185.199.108.133): icmp_seq=1 ttl=51 time=145 ms
64 bytes from raw.githubusercontent.com (185.199.108.133): icmp_seq=2 ttl=51 time=137 ms
^C
--- raw.githubusercontent.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 137.495/141.369/145.243/3.874 ms
[root@hadoop-193 ~]# tail -n 1 /etc/hosts
185.199.108.133 raw.githubusercontent.com
```

When restarting datahub docker env by using `datahub docker quickstart`, found containers could not contact with each other.
So the datahub service could not be started.

I removed docker package by using `yum remove docker`, reinstall docker package by using `yum install -y docker`, finally succeed to start 
datahub service by using `datahub docker quickstart`.

Once you follow quickstart step using `datahub docker quickstart`,  the program will download yml file for docker-compose
from raw.githubusercontent.com. The yml file is located at /tmp directory. We can move it to another directory for quickstart
next time.
```shell
[root@hadoop-193 datahub]# ls -ltr /tmp/*yml|tail -1
-rw------- 1 root root 4981 Oct 25 18:24 /tmp/tmp8wkyg_ho.yml
[root@hadoop-193 datahub]# ls
datahub.log  datahub.yml
```
Stop datahub by using `docker-compose -f datahub.yml down`
Start datahub by using `docker-compose -f datahub.yml up > datahub.log 2>&1 &`