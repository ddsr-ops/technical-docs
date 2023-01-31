mysql  innbackupex备份mysql数据，流式备份和传输

服务端：nc -l 5000 | pv -q -L 50M | tar -xi

客户端：innobackupex  --host=127.0.0.1 --port=3306  --user=root --password=123456  --stream=tar  --tmpdir=/tmp/tmpdir  --include='mysql' --slave-info  /usr/local/src/nvpv2/ | nc -nvv 127.0.0.1 5000