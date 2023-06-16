```
[xxx@dbhost log]$ mysqlbinlog mysql-bin.000004
mysqlbinlog: unknown variable 'default-character-set=utf8'
```

```
mysqlbinlog --no-defaults mysql-bin.000004
```

Note `--no-defaults` option must follow the `mysqlbinlog` command closely.