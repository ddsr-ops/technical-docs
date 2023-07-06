1. varchar开头有一个头信息记录实际数据长度
2. 当varchar声明长度<256字节时，头信息长度为1字节
3. 当varchar声明长度>=256字节时，头信息长度为2字节
4. 在utf8mb4环境下，varchar(64)声明长度为64*4=256字节
综上，从63改为64时会导致全量数据重写
   
So, when altered statements are issued, MySQL database could hang.

```sql
create table t (name varchar(62));

alter table t modify name varchar(65);
```