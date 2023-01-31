[Official reference](https://datahubproject.io/docs/docker/airflow/local_airflow)

The first time to start airflow, you will fail because of file permission.

Solution:
Modify `logs` directory permission by using `chmod 777 logs`
```shell
[root@hadoop-193 airflow]# ll
total 8
drwxr-xr-x 2 root root   37 Oct 14 17:23 dags
-rw-r--r-- 1 root root 5470 Oct 14 17:22 docker-compose.yaml
drwxrwxrwx 5 root root   88 Oct 15 18:14 logs
drwxr-xr-x 2 root root    6 Oct 15 17:51 plugins
```
