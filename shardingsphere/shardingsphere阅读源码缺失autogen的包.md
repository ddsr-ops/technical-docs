**问题表现**：   
运行`./mvnw.cmd clean install -Prelease`后，虽执行成功，但在阅读源码时
主要表现为缺失org.apache.shardingsphere.sql.parser.autogen.*

**解决方法**：  
1. Right click project folder
2. Select Maven
3. Select Generate Sources And Update Folders
4. Select Maven
5. Select Reload Project

[参考链接](https://stackoverflow.com/questions/5170620/unable-to-use-intellij-with-a-generated-sources-folder/46812593#46812593)