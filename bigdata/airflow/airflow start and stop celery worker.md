source /root/airflow_env/bin/activate  
airflow celery worker -c 6 -q ge -D  
airflow celery stop