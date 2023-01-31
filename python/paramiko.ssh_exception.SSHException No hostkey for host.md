When using pysftp package to upload file, throws 'paramiko.ssh_exception.SSHException: No hostkey for host'
exception.


```
cnopts = pysftp.CnOpts()
cnopts.hostkeys = None
with pysftp.Connection(host=host, port=port, username=user,
                       password=password, cnopts=cnopts, log="./pysftp.log") as sftp:
    sftp.cwd(dest_dir)
    sftp.put(file)
```

[Reference](https://stackoverflow.com/questions/38939454/verify-host-key-with-pysftp)