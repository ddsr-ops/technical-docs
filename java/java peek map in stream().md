Stream<T> peek(Consumer<? super T> action);
<R> Stream<R> map(Function<? super T, ? extends R> mapper);

һ������T����T��һ������T����R

peek��Ҫ��ִ�в��裬Ҳ�����з���ֵ��������κͳ��α�����������ͬ�ģ���map���ǿ����޸ķ���ֵ������

```
//����д����ʵ�����ǲ���ִ��peek������
// ��һ��д��û����ֹ���������Բ���ִ��
 newList1.stream().peek(item -> {
            List<String> urls = item.getUrls();
            urls.add("https://nowcoder.com");
            item.setUrls(urls);
        });
 
//��Ҫ����д
 newList1 = newList1.stream().peek(item -> {
            List<String> urls = item.getUrls();
            urls.add("https://nowcoder.com");
            item.setUrls(urls);
        }).collect(Collectors.toList());
 
//���߲���Ҫת������List��ֻҪ������stream����������peek�ͻᱻִ��
```

peek ������һЩ��ӡ�����޸Ĺ�����map��������ת��

���޷��ز�ֻ��Consumer ��Function����ʽ�ӿڵ�����¥��û��˵����Ҫ��һ����map���Ըı䷵��ֵ���ͣ���peek�޷��ı䷵��ֵ���ͣ� 
ע�⣺ map ��peek ���з���ֵΪStream