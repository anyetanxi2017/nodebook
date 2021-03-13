## java 环境配置

/etc/profie

```
export JAVA_HOME=/usr/local/jdk1.8.0_171
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

export M2_HOME=/usr/local/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

```

## jdk安装

```
mkdir /usr/local/jdk8

wget -check-certificate --no-cookies --header  "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

vim /etc/profile

export JAVA_HOME=/usr/local/jdk8
export PATH=$JAVA_HOME/bin:$PATH 
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

source /etc/profile

java -version

```

## maven安装

```
export M2_HOME=/usr/local/apache-maven-3.3.1
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

```
