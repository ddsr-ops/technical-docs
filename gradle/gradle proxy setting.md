Gradle Ĭ��ֱ�����磬��ʹ Mac ������ȫ�ִ���Ҳ��һ����������� Android Studio �����˴���
�����ɻ�����Ƶ���ֱ���Ǹ������й�һ����Ҳ���������ϵ���վ����

������Ҫ�����������ļ��������Ӧ�������

1������Ŀgradleʹ�ô���gradle/wrapper/gradle-wrapper.properties

2��ȫ��gradleʹ�ô���userdir/.gradle/gradle.properties

��ס https ǧ����ʡ��
```
#���������IP/����

systemProp.http.proxyHost=127.0.0.1

#����������˿�

systemProp.http.proxyPort=8080

#�����������Ҫ��֤ʱ����д�û���

systemProp.http.proxyUser=userid

#�����������Ҫ��֤ʱ����д����

systemProp.http.proxyPassword=password

#����Ҫ���������/IP

systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost

systemProp.https.proxyHost=127.0.0.1

systemProp.https.proxyPort=8080

systemProp.https.proxyUser=userid

systemProp.https.proxyPassword=password

systemProp.https.nonProxyHosts=*.nonproxyrepos.com|localhost
```