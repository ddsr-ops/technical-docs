**Symptom**

When pulling images, `error pulling image configuration: unknown blob` exception appears.

**Analysis**

Docker registry mirrors are not set properly.

**Solution**

```shell
vi /etc/docker/daemon.json
{
 "registry-mirrors":["https://registry.docker-cn.com"]
}

sudo systemctl daemon-reload
sudo systemctl restart docker
```