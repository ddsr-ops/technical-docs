When deploying debezium cdc connector for oracle dataguard server(11g, open read_only), 
It can not work correctly. Because privileges which debezium connector wants are not satisfied, the connector can not be launched.


When debezium cdc connector works with mysql slave of which read only is off, it works correctly.