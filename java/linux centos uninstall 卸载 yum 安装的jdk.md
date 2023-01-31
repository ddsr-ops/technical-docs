First Find java product and version using below command:

rpm -qa | grep java
And

rpm -qa | grep jdk
OUTPUT like:

jdk1.7.0
Then remove package using RPM or YUM:

yum remove jdk1.7.0
or

rpm -e jdk1.7.0

**Note: Remove every rpm.**