**Symptom**

when pulling images in the docker, some exception occurs of which messages include 
`docker pull was failed due to "unauthorized: authentication required"`

Clock time is wrong, fix it.

```shell
yum install -y ntpd ntpdate
yum start ntpdate && yum start ntpd
ntpq -p
```

[Reference](https://github.com/jupyter/docker-stacks/issues/484)