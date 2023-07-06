kafka-console-consumer.sh --bootstrap-server 10.50.253.202:9093 --topic xoracle_tsm.TFT_TSM.T_TRADE_INFO \
--from-beginning --property print.key=true --property print.headers=true --property print.timestamp=true

nohup ./kafka-console-consumer.sh --bootstrap-server 10.50.253.202:9093 --topic xoracle_tsm.TFT_TSM.T_TRADE_INFO \
--from-beginning --property print.key=true --property print.headers=true \
--property print.timestamp=true|egrep -i "20230630085611573076|20230627185053754114|20230627084009855638|20230626081418527414|20230626081418527414" > tmp.out 2>&1 &
