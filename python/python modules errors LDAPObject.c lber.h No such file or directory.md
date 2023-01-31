Output like following: 
```
building '_ldap' extension
gcc -pthread -Wno-unused-result -Wsign-compare -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes -fPIC -DHAVE_SASL -DHAVE_TLS -DHAVE_LIBLDAP_R -DHAVE_LIBLDAP_R -DLDAPMODULE_VERSION=2.4.35 -IModules -I/usr/include -I/usr/include/sasl -I/usr/local/include -I/usr/local/include/sasl -I/usr/local/include/python3.6m -c Modules/LDAPObject.c -o build/temp.linux-x86_64-3.6/Modules/LDAPObject.o
In file included from Modules/LDAPObject.c:9:0:
Modules/errors.h:8:18: fatal error: lber.h: No such file or directory
#include "lber.h"
```

Solution  

```shell
yum -y install openldap-devel
```

[Reference](https://github.com/pyldap/pyldap/issues/91)