rule a
rule b
rule c

* No hard code
* Dynamic
* Rules include logic operand

rule a > rule b > rule c == rule a & rule b & rule c
rule a & rule b & ! rule c

rule engine: last recent 15 days

message-push action: re-send again if failure, how to push, what to push , when to push

what is the boundary


```python
from airflow import DAG
from airflow.models import Variable
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.trigger_rule import TriggerRule
from datetime import datetime
import tft.util.db_util as DBUtil

def retrieve_sql_statements():
    res = DBUtil.get_hook_result(hook=DBUtil.get_hook("mysql_hive"),
                                 load_sql="""
                                       select sub_task_mess from compare_data.etl_sub_tasks
                                   """)

    return res

def execute_sql_statement(sql_statement):
    # Execute the SQL statement
    # host = Variable.get("mysql_host")
    # user = Variable.get("mysql_user")
    # password = Variable.get("mysql_password")
    # database = Variable.get("mysql_database")
    # 
    # connection = pymysql.connect(
    #     host=host,
    #     user=user,
    #     password=password,
    #     database=database
    # )
    # 
    # try:
    #     with connection.cursor() as cursor:
    #         cursor.execute(sql_statement)
    #         # Handle any result or error as needed
    # finally:
    #     connection.close()
    print(sql_statement)

dag = DAG(
    'dynamic_sql_statements',
    start_date=datetime(2022, 1, 1),
    schedule_interval='@daily',
    catchup=False
)

retrieve_statements = PythonOperator(
    task_id='retrieve_sql_statements',
    python_callable=retrieve_sql_statements,
    dag=dag
)

execute_statements = DummyOperator(
    task_id='execute_sql_statements',
    trigger_rule=TriggerRule.ALL_SUCCESS,
    dag=dag
)

retrieve_statements >> execute_statements

sql_statements = retrieve_statements.execute(context={})

for statement in sql_statements:
    execute_task = PythonOperator(
        task_id='execute_sql_statement' + str(sql_statements.index(statement)),
        op_kwargs={"sql_statement" : statement},
        python_callable=execute_sql_statement,
        dag=dag
    )
    execute_statements >> execute_task
```