1. varchar��ͷ��һ��ͷ��Ϣ��¼ʵ�����ݳ���
2. ��varchar��������<256�ֽ�ʱ��ͷ��Ϣ����Ϊ1�ֽ�
3. ��varchar��������>=256�ֽ�ʱ��ͷ��Ϣ����Ϊ2�ֽ�
4. ��utf8mb4�����£�varchar(64)��������Ϊ64*4=256�ֽ�
���ϣ���63��Ϊ64ʱ�ᵼ��ȫ��������д
   
So, when altered statements are issued, MySQL database could hang.

```sql
create table t (name varchar(62));

alter table t modify name varchar(65);
```