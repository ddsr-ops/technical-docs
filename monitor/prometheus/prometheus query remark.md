### http_requests_total{job="prometheus"}[120s:10s]  offset 1d

> offset 1w表示偏移量为1周，假设当前时刻为2022-7-22 15:00:27， 往过去回溯至2022-07-21 15:00:27.
> 在上述时刻基础上，即在2022-07-21 15:00:27，往过去回溯100s时长，即start为2022-07-21 14:58:27，end为2022-07-21 15:00:27，
> 步长为10s取值（instant vector），每个步长内共计12个值。
> 查询结果为range vector


### elasticsearch_os_cpu_percent[60s] offset 1d

> offset 1d表示偏移量为1天，假设当前时刻为2022-7-22 15:19:03， 往过去回溯至2022-7-22 15:19:03.
> 在上述时刻基础上，即在2022-7-22 15:19:03，往过去回溯60s时长，即start为2022-7-22 15:18:03，end为2022-7-22 15:19:03，
> 这里步长其实未指定，则使用全局的step或resolution，应该是15s。
> 步长为15s取值（instant vector），每个步长内共计4个值。
> 查询结果为range vector

### elasticsearch_os_cpu_percent offset 1d

> offset 1d表示偏移量为1天，假设当前时刻为2022-7-22 15:19:03， 往过去回溯至2022-7-22 15:19:03.
> 查询结果返回是2022-7-22 15:19:03时刻的度量值，即instant vector



References:
1. https://blog.csdn.net/iceman1952/article/details/120147853
2. https://blog.csdn.net/weixin_33778778/article/details/88705246
3. https://cloud.tencent.com/developer/article/1506942
