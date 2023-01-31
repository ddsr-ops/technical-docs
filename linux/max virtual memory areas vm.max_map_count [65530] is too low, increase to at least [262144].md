**Problem**

```text
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

**Solution**

```shell
/etc/sysctl.conf
vm.max_map_count=655360
sysctl -p

```
