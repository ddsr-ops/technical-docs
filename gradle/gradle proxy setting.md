Gradle 默认直连网络，即使 Mac 设置了全局代理也是一样。就算你给 Android Studio 设置了代理，
它依旧会风轻云淡地直连那个你在中国一辈子也不可能连上的网站……

根据需要在下列所述文件中添加相应配置语句

1、单项目gradle使用代理：gradle/wrapper/gradle-wrapper.properties

2、全局gradle使用代理：userdir/.gradle/gradle.properties

记住 https 千万不能省！
```
#代理服务器IP/域名

systemProp.http.proxyHost=127.0.0.1

#代理服务器端口

systemProp.http.proxyPort=8080

#代理服务器需要验证时，填写用户名

systemProp.http.proxyUser=userid

#代理服务器需要验证时，填写密码

systemProp.http.proxyPassword=password

#不需要代理的域名/IP

systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost

systemProp.https.proxyHost=127.0.0.1

systemProp.https.proxyPort=8080

systemProp.https.proxyUser=userid

systemProp.https.proxyPassword=password

systemProp.https.nonProxyHosts=*.nonproxyrepos.com|localhost
```