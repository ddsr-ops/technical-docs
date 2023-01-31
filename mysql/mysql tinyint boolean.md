**需求背景**：从MySQL数据库读取1、2、3、4等阿拉伯数字定义的状态，并转换成Java中Integer类型的数据，但是转换失败了。  
**问题分析**：布尔型 bool 或者 boolean 在MySQL里的类型定义为tinyint(1)。当在服务端读取的时候，字段tinyint(1)的类型被当做boolean类型进行了返回，导致无法转换为Integer类型。  
**解决思路**：修改tinyint数据类型长度或者改为int类型，mysql也就不再当做boolean类型进行返回了。  
**经验总结**：Mysql表结构设计枚举值为1、2、3等阿拉伯数字的时候，要避免设计为tinyint(1)类型，以防止与boolean类型数据结构混淆，导致不必要bug。