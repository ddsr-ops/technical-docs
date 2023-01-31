### Add a repo

```
yum install -y yum-utils

yum-config-manager --add-repo http://www.example.com/example.repo
```

### enable a repo

```
yum-config-manager --enable docker-ce

```

### disable a repo

```
yum-config-manager --disable docker-ce
```

Note: It prompted `This system is not registered with an entitlement server.
You can use subscription-manager to register.`, ignore it.