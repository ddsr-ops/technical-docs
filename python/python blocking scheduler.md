```
#BlockingScheduler��ʱ����
from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime
���ȿ�����һ�����嶨ʱִ������
# ���ʱ��
def job():
    print(datetime.now().strtime("%Y-%m-%d %H:%M:%S"))
# BlockingScheduler
scheduler = BlockingScheduler()
scheduler.add_job(job, "cron"�� day_of_week="1-5", hour=6, minute=30)
scheduler .start()


scheduler.add_job(job, 'cron', hour=1, minute=5)
hour =19 , minute =23   �����ʾÿ���19��23 ��ִ������
hour ='19', minute ='23'   ���������д���֣�Ҳ������д�ַ���
hour ='19-21', minute= '23'   ��ʾ 19:23�� 20:23�� 21:23 ��ִ��һ������

#ÿ300��ִ��һ��
scheduler .add_job(job, 'interval', seconds=300)

#��1��,3��,5��,7-9�£�ÿ�������2�㣬ÿһ����ִ��һ������
scheduler .add_job(func=job, trigger='cron', month='1,3,5,7-9', day='*', hour='14', minute='*')

# ��ǰ������� 6��7��8��11��12 �µĵ���������� 0��1��2��3 ��ִ��
scheduler .add_job(job, 'cron', month='6-8,11-12', day='3rd fri', hour='0-3')

#�ӿ�ʼʱ�䵽����ʱ�䣬ÿ����Сʱ����һ��
scheduler .add_job(job, 'interval', hours=2, start_date='2018-01-10 09:30:00', end_date='2018-06-15 11:00:00')

```