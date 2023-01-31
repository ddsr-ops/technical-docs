按理来说，可以存在不同Label值的Metric的，
例如Metric{LabelA="value1"}=,Metric{LabelA="value2"}=

但是在某些特定场景下，上述Metric是不可能同时存在的。

例如在Debezium的官方Metric中，同一个Connector名称的Metric，只能同时存在一个。
因为Connector名称重复，则不允许创建。

When debezium connectors switch to another server,  alert rule measurement result may be error, because different host labels
brings two or more measurement result.

This is because one connector node seems to be hanged.

I restart the connector node so resolve it.