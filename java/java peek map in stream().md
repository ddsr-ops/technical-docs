Stream<T> peek(Consumer<? super T> action);
<R> Stream<R> map(Function<? super T, ? extends R> mapper);

一个传入T返回T，一个传入T返回R

peek需要有执行步骤，也可以有返回值，但是入参和出参必须类型是相同的，而map的是可以修改返回值的类型

```
//这种写法，实际上是不会执行peek操作的
// 第一种写法没有终止操作，所以不会执行
 newList1.stream().peek(item -> {
            List<String> urls = item.getUrls();
            urls.add("https://nowcoder.com");
            item.setUrls(urls);
        });
 
//需要这样写
 newList1 = newList1.stream().peek(item -> {
            List<String> urls = item.getUrls();
            urls.add("https://nowcoder.com");
            item.setUrls(urls);
        }).collect(Collectors.toList());
 
//或者不需要转换成新List，只要后续对stream流做操作，peek就会被执行
```

peek 可以做一些打印或者修改工作，map用来数据转换

有无返回参只是Consumer 和Function函数式接口的区别，楼主没有说最重要的一点是map可以改变返回值类型，而peek无法改变返回值类型； 
注意： map 和peek 都有返回值为Stream