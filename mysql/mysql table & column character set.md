修改表的默认字符集:

ALTER TABLE table_name DEFAULT CHARACTER SET character_name;

修改表字段的默认字符集:

ALTER TABLE table_name CHANGE field field field_type CHARACTER SET character_name [other_attribute]

修改表的默认字符集和所有列的字符集:
ALTER TABLE table_name CONVERT TO CHARACTER SET character_name