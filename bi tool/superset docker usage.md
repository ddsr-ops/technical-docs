Refers to https://hub.docker.com/r/apache/superset

How to use this image

Start a superset instance on port 8080
$ docker run -d -p 8080:8088 --name superset apache/superset
For demonstration
$ docker run -d -p 8080:8088 --name superset apache/superset:latest-dev

Initialize a local Superset Instance
With your local superset container already running...

Setup your local admin account
 $ docker exec -it superset superset fab create-admin \
               --username admin \
               --firstname Superset \
               --lastname Admin \
               --email admin@superset.com \
               --password admin

Migrate local DB to latest
 $ docker exec -it superset superset db upgrade

Load Examples, may fail to execute because of http error.
But it will load a example database into superset.
 $ docker exec -it superset superset load_examples

Setup roles
 $ docker exec -it superset superset init

Login and take a look -- navigate to http://localhost:8080/login/ -- u/p: [admin/admin]