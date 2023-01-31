When building docker container

```
$ docker-compose up
Building tomcat
unknown flag: --iidfile
See 'docker build --help'.
ERROR: Service 'tomcat' failed to build
```

We should check docker and docker-compose version, may upgrade or downgrade them.

docker 1.13.1 is compatible with docker-compose 1.27.4 