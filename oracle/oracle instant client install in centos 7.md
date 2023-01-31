```
# (Optional) Get the latest repository info.
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

# Enable the instant client repository.
yum install -y yum-utils
yum-config-manager --enable ol7_oracle_instantclient

# (Optional) Check what packages are available.
yum list oracle-instantclient*

# Install basic and sqlplus.
yum install -y oracle-instantclient18.3-basic oracle-instantclient18.3-sqlplus
```


```
After this installation you can use SQL*Plus as follows.

export CLIENT_HOME=/usr/lib/oracle/18.3/client64
export LD_LIBRARY_PATH=$CLIENT_HOME/lib
export PATH=$PATH:$CLIENT_HOME/bin

sqlplus /nolog
```

[Reference1](https://oracle-base.com/articles/misc/oracle-instant-client-installation#yum)
[Reference2](https://docs.oracle.com/en/database/oracle/oracle-database/21/lacli/install-instant-client-using-rpm.html#GUID-2E81E2AE-E94C-413F-99B2-AE9A3949F05D)