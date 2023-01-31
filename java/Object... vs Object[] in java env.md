# 简述：

java中方法重载可以实现参数不同自动匹配对应方法。但现实中也存在这种问题。普通传参对于形如下面的方法，却显得臃肿而失优雅。
 ```
 Map getRealLine( int left, int top String color)
 //others method 
 Map getRealLine( int left, int right, int top , int bottom, String color)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb, String hh)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb, String hh, String flowLine)
```

# 引导：

１，正如上述例子，假设所有的情况都包含了。突然有一天，绘制图线功能扩展了，还可以给定点的名称String title。这下，我们又要添加一系列的方法。

注：可能有高手会说，为什么不给一个方法，里面参数是全的（最大化参数）。如果不给的时候置0，或者置null。对这一说法，建议质疑一下JDK中的一些类，定有所获。

2，假设如果有一种机制，可以如下来定义，将为带来方便。

 Map getRealLine( int[] posiontElements, String[] descriptions)
同时在使用时这样调用他：

```
 //备参 
 int[] intArr = new int[]{"1", "2", "3", "4"};
 String[] strArr = new String[]{"read", "#994e8a"};
 //调用 
 this.obj.getRealLine( intArr , strArr );
``` 

３，仅仅如此，那不就是采用数组传参了。实践中我们发现每次用数组的时候，都有个准备参数的过程，一般情况下，又只用一组参数中的一个，比方说color。那么每次创建数组、初始化数组，传参，显示很繁锁。比较优雅的作法是，传进去的参数都自动转为数组形式。这样，在调用方法的时候，留白、置空、单串、多串、数组，都可以被接收，可以大大减轻重复准备数据的体力劳动。测试代码如下，通过这些代码，能对“String… args”有个大体的了解。

```
 public class StrParamTest {
  
 
 public static void main(String[] args) {
 String[] strings = new String[]{"1","2"};
  
 StrParamTest.sayHi(strings);
 StrParamTest.sayHi("A");
 
 StrParamTest.sayHi("O", "P");
 StrParamTest.sayHi();
 StrParamTest.sayHi(null);
 }
 
 private static void sayHi( String... strings ){
  
 System.out.println("----------" + strings);
 
 if ( strings != null ) {
 
 for (String string : strings) {
 
 System.out.println(string);
 }
 }
 else {
 System.out.println("=========null");
 }
 }
  
 }
```

结果如下：

```
 ----------[Ljava.lang.String;@de6ced
 1
 2
 ----------[Ljava.lang.String;@c17164
 A
 ----------[Ljava.lang.String;@1fb8ee3
 O
 P
 ----------[Ljava.lang.String;@61de33
 ----------null
 =========null
```


# 小结：

1，String… args 传参方式，为调用前的准备省了许多气力；

2，一个方法里，只能有一个”…”这样的可变参数，而且置于最后（方法重载匹配策略原因）；

3，一个方法的参数很难考虑完整或者组内相同类型参数很多，采用此方法，可使代码更加优雅，同时，修改时只需改动实现类即可。

Object是所有类的基类，这个你可以查询jdk文档了解，所有类都继承自Object。Object ...objects这种参数定义是在不确定方法参数的情况下的一种多态表现形式。
即这个方法可以传递多个参数，这个参数的个数是不确定的。这样你在方法体中需要相应的做些处理。因为Object是基类，所以使用Object ...objects这样的参数形式，
允许一切继承自Object的对象作为参数。这种方法在实际中应该还是比较少用的。

Object[] obj这样的形式，就是一个Object数组构成的参数形式。说明这个方法的参数是固定的，是一个Object数组，至于这个数组中存储的元素，
可以是继承自Object的所有类的对象。这些基础东西建议你多看几遍"Think in java"希望我的回答对你有所帮助。