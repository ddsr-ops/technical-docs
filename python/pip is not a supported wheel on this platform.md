#Background

When installing offline python package via pip command, throws exceptions, Details are as follows.

```
[root@namenode2 pysftp1]# pip3 install cryptography-35.0.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl 
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
cryptography-35.0.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl is not a supported wheel on this platform.
```

# Solution

I changed whl name suffix from manylinux2010_x86_64.whl to manylinux1_x86_64.whl, succeed in installing offline package.

```
mv bcrypt-3.2.0-cp36-abi3-manylinux2010_x86_64.whl bcrypt-3.2.0-cp36-abi3-manylinux1_x86_64.whl
mv cryptography-35.0.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl cryptography-35.0.0-cp36-abi3-manylinux_2_17_x86_64.manylinux1_x86_64.whl

pip3 install --no-index --find-links=/tmp/whl_location package_name
```

# Advisement

Proposing to upgrade pip is a good choice. 


[Reference1](https://blog.csdn.net/sty945/article/details/105200436)
[Reference2](https://blog.csdn.net/happywlg123/article/details/107281936)
