# ������

java�з������ؿ���ʵ�ֲ�����ͬ�Զ�ƥ���Ӧ����������ʵ��Ҳ�����������⡣��ͨ���ζ�����������ķ�����ȴ�Ե�ӷ�׶�ʧ���š�
 ```
 Map getRealLine( int left, int top String color)
 //others method 
 Map getRealLine( int left, int right, int top , int bottom, String color)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb, String hh)
 Map getRealLine( int left, int right, int top , int bottom, String color, String rgb, String hh, String flowLine)
```

# ������

���������������ӣ��������е�����������ˡ�ͻȻ��һ�죬����ͼ�߹�����չ�ˣ������Ը����������String title�����£�������Ҫ���һϵ�еķ�����

ע�������и��ֻ�˵��Ϊʲô����һ�����������������ȫ�ģ���󻯲����������������ʱ����0��������null������һ˵������������һ��JDK�е�һЩ�࣬��������

2�����������һ�ֻ��ƣ��������������壬��Ϊ�������㡣

 Map getRealLine( int[] posiontElements, String[] descriptions)
ͬʱ��ʹ��ʱ������������

```
 //���� 
 int[] intArr = new int[]{"1", "2", "3", "4"};
 String[] strArr = new String[]{"read", "#994e8a"};
 //���� 
 this.obj.getRealLine( intArr , strArr );
``` 

����������ˣ��ǲ����ǲ������鴫���ˡ�ʵ�������Ƿ���ÿ���������ʱ�򣬶��и�׼�������Ĺ��̣�һ������£���ֻ��һ������е�һ�����ȷ�˵color����ôÿ�δ������顢��ʼ�����飬���Σ���ʾ�ܷ������Ƚ����ŵ������ǣ�����ȥ�Ĳ������Զ�תΪ������ʽ���������ڵ��÷�����ʱ�����ס��ÿա��������മ�����飬�����Ա����գ����Դ������ظ�׼�����ݵ������Ͷ������Դ������£�ͨ����Щ���룬�ܶԡ�String�� args���и�������˽⡣

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

������£�

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


# С�᣺

1��String�� args ���η�ʽ��Ϊ����ǰ��׼��ʡ�����������

2��һ�������ֻ����һ�������������Ŀɱ����������������󣨷�������ƥ�����ԭ�򣩣�

3��һ�������Ĳ������ѿ�����������������ͬ���Ͳ����ܶ࣬���ô˷�������ʹ����������ţ�ͬʱ���޸�ʱֻ��Ķ�ʵ���༴�ɡ�

Object��������Ļ��࣬�������Բ�ѯjdk�ĵ��˽⣬�����඼�̳���Object��Object ...objects���ֲ����������ڲ�ȷ����������������µ�һ�ֶ�̬������ʽ��
������������Դ��ݶ����������������ĸ����ǲ�ȷ���ġ��������ڷ���������Ҫ��Ӧ����Щ������ΪObject�ǻ��࣬����ʹ��Object ...objects�����Ĳ�����ʽ��
����һ�м̳���Object�Ķ�����Ϊ���������ַ�����ʵ����Ӧ�û��ǱȽ����õġ�

Object[] obj��������ʽ������һ��Object���鹹�ɵĲ�����ʽ��˵����������Ĳ����ǹ̶��ģ���һ��Object���飬������������д洢��Ԫ�أ�
�����Ǽ̳���Object��������Ķ�����Щ��������������࿴����"Think in java"ϣ���ҵĻش��������������