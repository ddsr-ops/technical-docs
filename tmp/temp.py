#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: Changhua Gong


import time
import logging
import requests
import logging.handlers
import os
import time

# 如果日志文件夹不存在，则创建
log_dir = "log-hour"  # 日志存放文件夹名称
log_path = os.getcwd() + os.sep + log_dir
if not os.path.isdir(log_path):
    os.makedirs(log_path)

# logging初始化工作
logging.basicConfig()

# 初始化loggger
test = logging.getLogger('test')
test.setLevel(logging.INFO)

# 添加TimedRotatingFileHandler
# 定义一个1小时换一次log文件的handler
# 保留24个旧log文件
time_file_handler = logging.handlers.TimedRotatingFileHandler(
    log_dir + os.sep + "log",
    when='H',
    interval=1,
    backupCount=24
)

# 设置后缀名称，跟strftime的格式一样
time_file_handler.suffix = "%Y-%m-%d_%H-%M-%S"

formatter = logging.Formatter('%(asctime)s|%(name)-12s: %(levelname)-8s %(message)s')
time_file_handler.setFormatter(formatter)
test.addHandler(time_file_handler)


def request_metric():
    response = requests.get('http://namenode1:7071/metric')
    elapsed_time = response.elapsed
    return str(elapsed_time) + "\n" + response.text


while 1 == 1:
    test.info(request_metric())
    time.sleep(5)
