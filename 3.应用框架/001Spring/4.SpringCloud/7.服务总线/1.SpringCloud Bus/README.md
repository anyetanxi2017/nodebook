
* [概述](#概述)
* [RabbitMQ环境配置](#RabbitMQ环境配置)
* [SpringCloud Bus动态刷新全局广播](#SpringCloud Bus动态刷新全局广播)
* [SpringCloud Bus动态刷新点通知](#SpringCloud Bus动态刷新点通知)
# 概述
## 什么是总线
在微服务架构的系统中，通常会使用轻量级的消息代理来构建一个共用的消息主题，并让系统中所有微服务实例都连接上来。由于该主题中产生的消息会被所有实例监听和消费，所以称它为消息总线。
## 基本原理
ConfigClient实例都监听MQ中同一个topic。当一个服务刷新数据的时候，它会把信息放入到topic中，这样其它监听同一个topic的服务就能得到通知，然后去更新自身的配置。

SpringCloud Bus 是用来将分布式系统的节点与轻量级消息系统链接起来的框架，它整合了Java的事件处理机制和消息中间件的功能。

SpringCloud Bus 目前支持RabbitMQ和Kafka
# RabbitMQ环境配置
# SpringCloud Bus动态刷新全局广播
# SpringCloud Bus动态刷新点通知
