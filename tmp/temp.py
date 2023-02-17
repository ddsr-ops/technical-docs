import re

topic = "mysql_93_base_test1.msx_online.user_base"
topic_naming_pattern = r"({0})\.(\w+\.\w+)".format("mysql_93_base_test2")
found = re.search(re.compile(topic_naming_pattern), topic)
print(found.group(2))
