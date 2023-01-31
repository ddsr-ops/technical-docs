Exception as follows:

[root@centos7 jimureport-example]# docker exec -it /bin/bash mysql0
Error response from daemon: page not found

As usually, input command is un-correct.

```
[root@centos7 jimureport-example]# docker help exec

Usage:	docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

Run a command in a running container

Options:
  -d, --detach               Detached mode: run command in the background
      --detach-keys string   Override the key sequence for detaching a container
  -e, --env list             Set environment variables (default [])
      --help                 Print usage
  -i, --interactive          Keep STDIN open even if not attached
      --privileged           Give extended privileges to the command
  -t, --tty                  Allocate a pseudo-TTY
  -u, --user string          Username or UID (format: <name|uid>[:<group|gid>])

```

[root@centos7 jimureport-example]# docker exec -it mysql0 /bin/bash
root@b4d9e93642ee:/# exit;
exit
