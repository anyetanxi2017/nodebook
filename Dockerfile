```
from openjdk:8
MAINTAINER www.983132370@qq.com
ENV LANG C.UTF-8
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
echo 'Asia/Shanghai' >/etc/timezone
ADD ./target/rita-core.jar /usr
CMD ["java", "-jar","/usr/rita-core.jar"]

```
