ҳ������ٶȵ�ͼapiʱ

```
chrome����̨������ʾ���� A Parser-blocking, cross site (i.e. different eTLD+1) script, http://api.map.baidu.com/getscript?v=2.0&ak=Kpjp7jddqVUhWK5VkrfNt3YNezY88NtR&services=&t=20170517145936, is invoked via document.write. The network request for this script MAY be blocked by the browser in this or a future page load due to poor network connectivity. If blocked in this page load, it will be confirmed in a subsequent console message.See https://www.chromestatus.com/feature/5718547946799104 for more details. (anonymous) @ api:1
```

����һЩ���ϣ������˼��˵ ��ҳ����Ⱦ��ɺ�ʹ����document.write()
���ǲ�������ģ�
�����������ʾ����api����url����� api ��Ϊ getscript

<script src="http://api.map.baidu.com/api?v=2.0&ak=�������ak"></script>

api ��Ϊ getscript�Ժ�

<script src="http://api.map.baidu.com/getscript?v=2.0&ak=�������ak"></script>