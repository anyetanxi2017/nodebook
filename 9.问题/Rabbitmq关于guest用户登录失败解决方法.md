https://blog.csdn.net/doubleqinyan/article/details/81081673?depth_1-utm_source=distribute.pc_relevant.none-task&utm_source=distribute.pc_relevant.none-task

## 解决办法
Step1：执行如下命令
```
rabbitmqctl set_user_tags guest administrator
rabbitmqctl set_permissions -p / guest '.*' '.*' '.*'
```
重启rabbitmq即可。测试如果还是无法登陆，则进行Step2。

Step2：在rabbitmq的配置文件目录下创建一个rabbitmq.config文件。文件中添加如下配置（请不要忘记那个“.”）：
```
[{rabbit, [{loopback_users, []}]}]. 
```
然后重启rabbitmq即可。

- 停止：service rabbitmq-server stop
- 启动：service rabbitmq-server start
- 查看状态：service rabbitmq-server status
