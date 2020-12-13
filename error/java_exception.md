## 服务器启动服务 renren-fast 的 SchedulerFactory 定时任务报错 
StdSchedulerFactory.java:1202]-Couldn't generate instance Id!

解决
```
vim /etc/hosts
# 将自己主机名按以下方式添加 myhost 查看具体报错显示的是什么
127.0.0.1   localhost myhost
```
