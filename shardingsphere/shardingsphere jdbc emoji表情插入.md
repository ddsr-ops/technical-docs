# Prerequisite
1. not all tables`s charset is utf8mb4. some for them are utf8. we changed all of them to utf8mb4
2. not all server linked shradingsphere use utf8mb4 in their connection url by 
   character_set_server=utf8mb4&connectionCollation=utf8mb4_bin, we changed all the connection url 
   with character_set_server=utf8mb4&connectionCollation=utf8mb4_bin