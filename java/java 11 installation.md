Download jdk package from Oracle website.

jdk-11.0.18_linux-x64_bin.tar.gz

tar -zxf jdk-11.0.18_linux-x64_bin.tar.gz -C /home/jdk

export JAVA_HOME=/home/jdk/jdk-11.0.18  
export CLASSPATH=${CLASSPATH}:${JAVA_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH

You can add these items to /etc/profile

java -version