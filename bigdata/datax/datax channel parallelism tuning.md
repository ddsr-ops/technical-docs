优化1：提升每个channel的速度

在DataX内部对每个Channel会有严格的速度控制，分两种，一种是控制每秒同步的记录数，另外一种是每秒同步的字节数，默认的速度限制是1MB/s，可以根据具体硬件情况设置这个byte速度或者record速度，一般设置byte速度，比如：我们可以把单个Channel的速度上限配置为5MB

优化2：提升DataX Job内Channel并发数 并发数=taskGroup的数量每一个TaskGroup并发执行的Task数 (默认单个任务组的并发数量为5)。

提升job内Channel并发有三种配置方式：

配置全局Byte限速以及单Channel Byte限速，Channel个数 = 全局Byte限速 / 单Channel Byte限速
配置全局Record限速以及单Channel Record限速，Channel个数 = 全局Record限速 / 单Channel Record限速
直接配置Channel个数.

配置含义：

job.setting.speed.channel : channel并发数
job.setting.speed.record : 全局配置channel的record限速
job.setting.speed.byte：全局配置channel的byte限速

core.transport.channel.speed.record：单channel的record限速
core.transport.channel.speed.byte：单channel的byte限速