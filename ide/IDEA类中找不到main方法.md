```
错误在类中找不到main方法，请将main方法定义为 public static void main(String[] args)

否则 JavaFX 应用程序类必须扩展javafx.application.Application。

```

Two steps to try:

1. Run `mvn clean` in idea tool

2. Invalidate caches & restart (Path: File --> Invalidate caches & restart)