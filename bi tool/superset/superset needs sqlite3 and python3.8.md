Superset needs sqlite3 package and python3.8(version>=3.8).

���ȴ�Żᱨһ���������⣺

1. no mudole named _sqlite3

2. mportError: dynamic module does not define module export function (PyInit__caffe)

��ʵ���������ⶼ����Ϊpython3���ϰ汾��̫֧��sqlite3������ķ������ײ�û���⣬���ԣ�sparkexpert����

��1����װsqlite3�İ�

```wget https://www.sqlite.org/2017/sqlite-autoconf-3170000.tar.gz --no-check-certificate
tar zxvf sqlite-autoconf-3170000.tar.gz
cd sqlite-autoconf-3170000
./configure --prefix=/usr/local/sqlite3 --disable-static --enable-fts5 --enable-json1 CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_RTREE=1"
```

��2����python3�������±���

```cd Python-3.6.0a1
LD_RUN_PATH=/usr/local/sqlite3/lib ./configure LDFLAGS="-L/usr/local/sqlite3/lib" CPPFLAGS="-I /usr/local/sqlite3/include"
LD_RUN_PATH=/usr/local/sqlite3/lib make
LD_RUN_PATH=/usr/local/sqlite3/lib sudo make install
```

����̨����python3���뻷��

import sqlite3   û����˵��ok

```Python 3.4.3 (default, Jan 17 2019, 15:37:29) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-16)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import sqlite3
```
