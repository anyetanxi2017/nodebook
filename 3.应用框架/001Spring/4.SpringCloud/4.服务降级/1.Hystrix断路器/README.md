* [概述](#概述)
* [停更](#停更)
* [Hystrix重要概念](#Hystrix重要概念)
    * [服务降级 Fallback](#服务降级Fallback)
    * [服务熔断 Break](#服务熔断Break)
    * [服务限流 Flowlimit](#服务限流Flowlimit)
* [HystrixDEMO](#HystrixDEMO)
    * [创建项目](#创建项目)
    * [服务降级](#服务降级)
    * [服务熔断](#服务熔断)

# 概述
**分布式系统面临的问题**
复杂分布式体系结构中的应用程序有数十个依赖关系，每个依赖关系在某些时候将不可避免地失败。
> 服务雪崩 多个微服务之间调用的时候，假设微服务A调用微服务B和微服务C，微服务B唾微服务C又调用其它的微服务，这就是所谓的“扇出”。
> 如果扇出的链路上某个微服务的调用响应时间过长或者不可用，对微服务A的调用就会占用越来越多的系统资源，进而引起系统崩溃，所谓的“雪崩效应”。
Hystrix是一个用于处理分布式系统的延迟和容错的开源库，在分布式系统里，许多依赖不可避免的会调用失败，比如超时、异常等，Hystrix能够保证一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性。

“断路器”本身是一种开关装置，当某个服务单元发生故障之后，通过断路器的故障监控，向调用方返回一个符合预期的、可处理的备选响应（FallBack），而不是长时间的等待或者抛出调用方无法处理的异常，这样就保证了服务调用方的纯种不会被长时间、不必要地占用，从而避免了故障在分布式系统中的蔓延，及至雪崩。
# 停更
停更了为什么还要学习？学的是理念思想

上面神仙打架，下面程序员遭殃。不停学习就是程序员的宿命。    ----周阳
# Hystrix重要概念
## 服务降级Fallback
服务器忙，请稍后再试，不让客户端等待并立刻返回一个友好提示，fallback

哪些情况会触发降级？
```
程序运行异常
超时
服务熔断触发服务降级
线程池/信号量打满也会导致服务降级
```
## 服务熔断Break
熔断机制是对雪崩效应的一种微服务链路保护机制。当扇出链路的某个微服务出错不可用或者响应时间太长时，会进行服务降级，进而熔断该节点的微服务调用，快速返回错误的响应信息。
当检测到该节点微服务调用响应正常后，恢复调用链路。
## 服务限流Flowlimit
秒杀高并发等操作，大家排除，一秒钟N个，有序进行。
# HystrixDEMO
## 创建项目
(服务降级demo)
pom.xml
```
<dependencies>
  <dependency>
    <groupId>com.atguigu.springcloud</groupId>
    <artifactId>cloud-api-commons</artifactId>
  </dependency>
  <!--hystrix-->
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
  </dependency>

  <!--eureka client-->
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
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
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
  </dependency>
  <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
  </dependency>
  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
  </dependency>
</dependencies>
<build>
<plugins>
  <plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
  </plugin>
</plugins>
</build>
```
application.properties
```
server.port=8001
spring.application.name=cloud-provider-hystrix-payment
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/db2019?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false&useAffectedRows=true&useSSL=false
spring.datasource.username=root
spring.datasource.password=123456
mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.type-aliases-package=com.atguigu.springcloud.entities
# 是否将自己注册到 EurekaServer 默认为true
eureka.client.register-with-eureka=true
# 是否从 EurekaServer 抓取自己的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合 ribbon使用负载均衡
eureka.client.fetch-registry=true
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka
eureka.instance.instance-id=payment8001
eureka.instance.prefer-ip-address=true
# Eureka 客户端发送心跳的时间间隔 ，单位为秒 （默认为30秒）
eureka.instance.lease-renewal-interval-in-seconds=1
# Eureka 服务端在收到最后一次心跳后等待时间上限，单位为秒（默认90秒），超时将剔除服务
eureka.instance.lease-expiration-duration-in-seconds=2

```
main.java
```
@SpringBootApplication
@EnableEurekaClient
@EnableCircuitBreaker //降级
public class PaymentHystixMain8001 {
  public static void main(String[] args) {
    SpringApplication.run(PaymentHystixMain8001.class, args);
  }
}

```
controller
```
@RestController
@Slf4j
public class PaymentController {
  @Resource
  private PaymentService paymentService;
  @Value("${server.port}")
  private Integer port;

  @GetMapping("/payment/hystrix/ok/{id}")
  public String paymentInfo_ok(@PathVariable Integer id) {
    String result = paymentService.paymentInfo_ok(id);
    log.info("***********result:" + result);
    return result;
  }

  @GetMapping("/payment/hystrix/timeout/{id}")
  public String paymentInfo_timeOut(@PathVariable Integer id) {
    String result = paymentService.paymentInfo_Timeout(id);
    log.info("***********result:" + result);
    return result;
  }
}

```
service
```
@Service
public class PaymentService {

  /**
   * 超时3秒钟则服务降级 或报错 fallback 也服务降级
   */
  @HystrixCommand(fallbackMethod = "paymentInfo_TimeOutHandler", commandProperties = {
      @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds", value = "3000")})
  public String paymentInfo_Timeout(Integer id) {
    int a = 20 / 0; //造错
    final int millis = 5000; //超时
    ThreadUtil.sleep(millis);
    return "线程池：" + Thread.currentThread().getName() + " paymentInfo_TimeOut,id:" + id
        + "\t 耗时：(毫秒)" + millis;
  }

  /**
   * 降级处理方法
   */
  public String paymentInfo_TimeOutHandler(Integer id) {
    return "线程池：" + Thread.currentThread().getName() + " 系统繁忙请稍后再试";
  }

  /**
   * 正常访问肯定ok
   */
  public String paymentInfo_ok(Integer id) {
    return "线程池：" + Thread.currentThread().getName() + " paymentInfo_ok,id:" + id + "\t";
  }

}
```
## 服务降级
（一般在客户端进行降级处理）
## 服务熔断
