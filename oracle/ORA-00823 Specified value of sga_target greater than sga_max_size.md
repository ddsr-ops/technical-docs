```
SQL> startup
ORA-00823: Specified value of sga_target greater than sga_max_size
ORA-01078: failure in processing system parameters
```

Only set sga_max_target, Not set sga_target or set it to zero.

```
*.sga_max_size=2048000000
*.sga_target=0
```