Note: IDE as debug server

Python codes as a client connecting to the debug server.

In the IDE, Run --> Edit configurations --> Add Python Debug Server

According to the instruction, config the python debug server, especially file path mapping. 

Try to keep IDE file path in consistent with remote python file path, otherwise debug cursors are inconsistent when debugging.

Another attention to be paid is packages which are needed for debugging should be installed in remote and local (IDE) endpoints.

[Reference](https://blog.csdn.net/dkjkls/article/details/89054595)

