
* [概述](#概述)
* [RabbitMQ环境配置](#RabbitMQ环境配置)
* [SpringCloud Bus动态刷新全局广播](#SpringCloudBus动态刷新全局广播)
* [SpringCloud Bus动态刷新点通知](#SpringCloudBus动态刷新点通知)
# 概述
## 什么是总线
在微服务架构的系统中，通常会使用轻量级的消息代理来构建一个共用的消息主题，并让系统中所有微服务实例都连接上来。由于该主题中产生的消息会被所有实例监听和消费，所以称它为消息总线。
## 基本原理
ConfigClient实例都监听MQ中同一个topic。当一个服务刷新数据的时候，它会把信息放入到topic中，这样其它监听同一个topic的服务就能得到通知，然后去更新自身的配置。

SpringCloud Bus 是用来将分布式系统的节点与轻量级消息系统链接起来的框架，它整合了Java的事件处理机制和消息中间件的功能。

SpringCloud Bus 目前支持RabbitMQ和Kafka
# RabbitMQ环境配置
启动RabbitMQ
# SpringCloudBus动态刷新全局广播
## 修改配置中心3344
### 添加bus 依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bus-amqp</artifactId>
</dependency>
```
### 添加配置文件
```
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
management.endpoints.web.exposure.include=bus-refresh
```
## 修改客户端3355
### 添加依赖
```
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-bus-amqp</artifactId>
  </dependency>
```
### application.properties
```
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
```
## 测试
1. 启动 eureka7001 7002
2. 启动 配置中心3344
3. 启动 客户端 3355 3366
4. 请求 3344配置文件 `http://localhost:3344/config-dev.properties`
```
config.info: master branch springcloud-config/config-dev.properties version=2
```
5. 请求 3355/3366 `http://localhost:3355/configInfo`
```
master branch springcloud-config/config-dev.properties version=2
```
6. 修改 github上面的配置文件 
```
config.info=master branch springcloud-config/config-dev.properties version=10

```
7. 重复请求 4-5步 会发现 3344已经变成 `version=10`了。但 3355和3366还没有改变。接近下一步
8. 手动请求配置中心`curl -X POST "http://localhost:3344/actuator/bus-refresh"` 通知所有订阅的客户端自己刷新自己的配置。
9. 再执行第5步，会发现配置已经更新为`version=10` 说明成功了
# SpringCloudBus动态刷新点通知 
指定具体某一个实例生效而不是全部

公式：`hptt://localhost:配置中心端口号/actuator/bus-refresh/{destination}`

demo 不想全局通知，只想定点通知。假设只通知 3355 不通知3366.

`curl -X POST "http://localhost:3344/actuator/bus-refresh/config-client:3355"`

至此，bus 内容完结。
