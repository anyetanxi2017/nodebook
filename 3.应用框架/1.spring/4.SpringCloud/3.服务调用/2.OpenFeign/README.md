* [简介](#简介)
* [功能](#功能)
* [pom.xml](#pom.xml)
* [application.properties](#application.properties)
* [OrderFeignMain80](#OrderFeignMain80)
* [服务层](#服务层)
* [控制层](#控制层)
* [OpenFeign超时控制](#OpenFeign超时控制)
* [OpenFeign日志打印](#OpenFeign日志打印)

# 简介
Feign是一个声明式的Web客户端，让编写Web服务客户端变得非常容易，只需要创建一个接口并在接口上添加注解即可。
# 功能
前面在使用Ribbon+RestTemplate时，利用RestTemplate对Http请求的封装处理，形成了一套模版化的调用方法。
但是在实际开发中，由于对服务依赖的调用可能不止一处，往往一个接口会被多处调用，所以通常都会针对每个微服务自行封装一些客户端类来包装这些依赖服务的调用。
所以，Feign在此基础上做了进一步的封装，由他来帮助我们定义和实现依赖服务接口的定义。
在Feign的实现下，只需要创建一个接口并使用注解的方式来配置它即可完成对服务提供方的接口绑定，简化了使用SpringCloud Ribbon时，自动封装服务调用客户端的开发量。
# pom.xml
```
<artifactId>cloud-consumer-feign-order80</artifactId> <dependencies>
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>     <!--eureka client-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
<dependency>
  <groupId>com.atguigu.springcloud</groupId>
  <artifactId>cloud-api-commons</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
</dependency>
</dependencies> <build>
<plugins>
  <plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
  </plugin>
</plugins>
</build>
```
# application.properties
```
server.port=80
spring.application.name=cloud-order-server
# 是否将自己注册到 EurekaServer 默认为true
eureka.client.register-with-eureka=false
# 是否从 EurekaServer 抓取自己的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合 ribbon使用负载均衡
eureka.client.fetch-registry=true
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka
# Eureka 客户端发送心跳的时间间隔 ，单位为秒 （默认为30秒）
eureka.instance.lease-renewal-interval-in-seconds=1
# Eureka 服务端在收到最后一次心跳后等待时间上限，单位为秒（默认90秒），超时将剔除服务
eureka.instance.lease-expiration-duration-in-seconds=2
```
# OrderFeignMain80
```
@SpringBootApplication
@EnableFeignClients
public class OrderFeignMain80 {

  public static void main(String[] args) {
    SpringApplication.run(OrderFeignMain80.class, args);
  }
}
```
# 服务层
```
@Component
@FeignClient(value = "CLOUD-PAYMENT-SERVICE")
public interface PaymentFeignService {
  @GetMapping(value = "/payment/get/{id}")
  CommonResult<Payment> getPayment(@PathVariable("id") Long id);
}
```
# 控制层
```
@RestController
public class PaymentController {

  @Resource
  private PaymentFeignService paymentFeignService;

  @GetMapping("/consumer/payment/{id}")
  public CommonResult<Payment> test(@PathVariable Long id) {
    return paymentFeignService.getPayment(id);
  }
}
```
# OpenFeign超时控制
默认Feign客户端只等待一秒钟，但是服务端处理超过1秒钟时，会导致Feign客户端等待超时，直接报错。为也避免这样的情况，有时我们需要设置Feign客户端的超时控制。

application.properties
```
# 设置Feign客户端超时时间（OpenFeign默认支持Ribbon）
# 设置读取超时时间
ribbon.ReadTimeout=6000
# 设置连接超时时间
ribbon.ConnectTimeout=600
# 对所有操作请求都进行重试
ribbon.OkToRetryOnAllOperations=true
# 切换实例的重试次数
ribbon.MaxAutoRetriesNextServer=2
# 对当前实例的重试次数
ribbon.MaxAutoRetries=1

```
# OpenFeign日志打印
- NONE：默认的，不显示任何日志
- BASIC：仅记录请求方法、URL、响应状态码及执行时间
- HEADERS：除了BASIC中定义的信息之外，还有请求和响应的头信息
- FULL：除了HEADERS中定义的信息之外，还有请求和响应的正文及元数据。

JavaBean配置类
```
@Configuration
public class FeignConfig {

  @Bean
  Logger.Level feignLoggerLevel() {
    return Logger.Level.FULL;
  }
}
```
application.properties
```
logging.level.com.atguigu.springcloud.service.PaymentFeignService:debug
```
