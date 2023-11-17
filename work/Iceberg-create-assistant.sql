select concat(column_name, ' ', converted_type, ' comment \'', column_comment, '\',')
from (select column_name
           , case
                 when data_type in ('char', 'varchar') then 'string'
                 when data_type in ('tinyint', 'int', 'smallint') then 'int'
                 when data_type in ('bigint') then 'bigint'
                 when data_type in ('datetime') then 'timestamp' end as converted_type
           , column_comment
      from information_schema.columns
      where table_schema in ('user_core', 'certification')
        and table_name = 'old_user_id_link_person_id_0') t;
