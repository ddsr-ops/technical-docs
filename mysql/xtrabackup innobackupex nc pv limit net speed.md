mysql  innbackupex����mysql���ݣ���ʽ���ݺʹ���

����ˣ�nc -l 5000 | pv -q -L 50M | tar -xi

�ͻ��ˣ�innobackupex  --host=127.0.0.1 --port=3306  --user=root --password=123456  --stream=tar  --tmpdir=/tmp/tmpdir  --include='mysql' --slave-info  /usr/local/src/nvpv2/ | nc -nvv 127.0.0.1 5000