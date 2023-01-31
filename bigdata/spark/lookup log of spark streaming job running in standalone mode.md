**Background**

We need to lookup logs of streaming job especially when some errors occur.

Here, jobs are running in the standalone mode instead of yarn mode. 

When streaming jobs exited with some exceptions, we usually look for history log to find what happened in our program.


**History log reading**

Firstly, spark history server(http://namenode1:18080/) would not log the driver log message. 
Incompleted or completed drivers can be found in spark master web ui, such as http://namenode1:8080/.

Scroll to the end of spark master web ui, find the driver which you want in the Completed Drivers section, remember the driver name,
such as driver-20220609141228-0001.

Click the related worker of the driver, you will switch to another page(worker page), here you will find running and finished executors.
However, they are not needed for you. Scroll to the end of worker page, Finished Drivers section appear which you need.

In this section, you find the same driver(driver-20220609141228-0001). Click the related stderr log to lookup what happened at all. 