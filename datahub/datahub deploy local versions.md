[Reference](https://datahubproject.io/docs/developers/)

Skip to 'Deploying local version'. 

After building project, some test errors may occur, we can ignore them. 

Before deploying project, some steps must be taken:

* docker and docker-compose must be installed. 

* http proxy should be configured, because docker action will fetch `yml` config file from github.
  Refer to local document <Failed to connect to raw.githubusercontent.com 443£¨linux´úÀíproxy£©.md> to set proxy.

