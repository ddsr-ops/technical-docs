ModuleNotFoundError: No module named '_bz2'

�ô�����ȱʧ_bz2.cpython-38-x86_64-linux-gnu.so���os�ļ������������£�

1�����ظ��ļ�: https://pan.baidu.com/s/1iPuEBYnUABWf94QM9fQZgQ ��ȡ��: nw2g

2�������غ���ļ��ŵ�python3.8�ļ�����/usr/local/python/lib/python3.8/lib-dynload/Ŀ¼�£�

��lib-dynloadĿ¼��ʹ��"chmod +x _bz2.cpython-38-x86_64-linux-gnu.so"���Ӹ��ļ��Ŀ�ִ��Ȩ��

3���ٴ����г�����ܻ��ᱨ��ImportError: libbz2.so.1.0: cannot open shared object file: No such file or directory

1.������Ҫʹ��sudo yum install -y bzip2* ȷ��ϵͳ�Ѿ���װ����صĿ⣻

2.��ʱ�ᷢ����/usr/lib64Ŀ¼�»ᷢ����ʵ��libbz2.so.1.0.6����һ���ļ�������ֻ��Ҫ�ڸ�Ŀ¼��ʹ������

"sudo ln -s libbz2.so.1.0.6 libbz2.so.1.0"����һ�����ļ��������ӡ�

������OK��
