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
### main.java
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
### controller
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
### service
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

### 服务端降级处理
main添加注解
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
服务层修改
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

```
### 客户端降级处理
pom.xml添加依赖
```
<!--hystrix-->
<dependency>
<groupId>org.springframework.cloud</groupId>
<artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>

```
application.properties 添加配置
```
feign.hystrix.enabled=true
```
主启动类添加 @EnableHystrix
```
@SpringBootApplication
@EnableFeignClients
@EnableHystrix
public class OrderHystrixOrderMain80 {
  public static void main(String[] args) {
    SpringApplication.run(OrderHystrixOrderMain80.class, args);
  }
}

```
### 默认降级处理 @DefaultProperties
```
@RestController
@Slf4j
@DefaultProperties(defaultFallback = "payment_Global_FallbackMethod",
    commandProperties = {
        @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds", value = "5000")})
public class OrderHystrixController {

  @Resource
  private PaymentHystrixService paymentHystrixService;

  /**
   * 默认 降级处理方法
   */
  public String payment_Global_FallbackMethod() {
    return " Global异常处理信息，请稍后再试!";
  }

  @GetMapping("/consumer/payment/hystrix/timeout/{id}")
  @HystrixCommand //使用默认降级处理 也需要加此注解
  public String paymentInfo_timeOut(@PathVariable Integer id) {
    String result = paymentHystrixService.paymentInfo_timeOut(id);
    log.info("***********result:" + result);
    return result;
  }
```
### 通配服务降级处理Service层处理
服务层方法配置 @FeignClient配置 fallback属性
```
@FeignClient(value = "CLOUD-PROVIDER-HYSTRIX-PAYMENT", fallback = PaymentFallbackService.class)
public interface PaymentHystrixService {

  @GetMapping("/payment/hystrix/timeout/{id}")
  String paymentInfo_timeOut(@PathVariable(value = "id") Integer id);

  @GetMapping("/payment/hystrix/ok/{id}")
  String paymentInfo_ok(@PathVariable(value = "id") Integer id);
}
```
创建一个PaymentHystrixService的实现类
```
@Component
public class PaymentFallbackService implements PaymentHystrixService {

  @Override
  public String paymentInfo_timeOut(Integer id) {
    return "------------ PaymentFallbackService fall back timeout";
  }

  @Override
  public String paymentInfo_ok(Integer id) {
    return "------------ PaymentFallbackService fall back ok";
  }
}
```
## 服务熔断
### 服务层
```
/**
 * circuitBreaker.enabled 配置是否开启断路器
 * circuitBreaker.requestVolumeThreshold  10 请求总次数阀值 （默认20）
 * circuitBreaker.errorThresholdPercentage  60  错误百分比阀值（默认50%）
 * 请求次数和失败率 加在一起， 如果请求10次，失败率达到 60% 则触发熔断机制。
 * 熔断被触发后，请求直接会调用 fallback 降级方法
 * circuitBreaker.sleepWindowInMilliseconds 快照时间窗（默认10秒） 意思是当熔断被触发后，等待多久后尝试恢复接口的访问。
 * 在恢复尝试时，如果发现服务也是不能用的则。继续处于熔断状态，如果服务已正常，则关闭熔断状态
 */
@HystrixCommand(fallbackMethod = "paymentCircuitBreaker_fallback", commandProperties = {
    @HystrixProperty(name = "circuitBreaker.enabled", value = "true"),//是否开启断路器
    @HystrixProperty(name = "circuitBreaker.requestVolumeThreshold", value = "10"),//请求次数    (意思是 10次里面有 6次失败则熔断)
    @HystrixProperty(name = "circuitBreaker.errorThresholdPercentage", value = "60"),//失败率达到多少后熔断
    @HystrixProperty(name = "circuitBreaker.sleepWindowInMilliseconds", value = "10000")//时间窗口期 熔断后在规定时间后进行重新通过试试，看服务恢复没有
})
public String paymentCircuitBreaker(@PathVariable("id") Integer id) {
    if (id < 0) {
    throw new RuntimeException("**********id 不能为负数");
    }
    String serialNumber = IdUtil.simpleUUID();
    return Thread.currentThread().getName() + "\t 调用成功，流水号：" + serialNumber;
    }
```
### 控制层
```
// =====服务熔断
@GetMapping("/payment/circuit/timeout/{id}")
public String paymentCircuitBreaker(@PathVariable Integer id) {
    String result = paymentService.paymentCircuitBreaker(id);
    log.info("***********result:" + result);
    return result;
    }
```
### 熔断类型
```
熔断打开
    请求不再进行调用当前服务，内部设置时钟一般为MTTR（平均故障处理时间），当打开长达到所设时钟则进入半熔断状态
熔断半开
    部分请求根据规则调用当前服务，如果请求成功且符合规则则认为当前服务恢复正常，关闭熔断。
熔断关闭
    熔断关闭，不会对服务进行熔断。
```
断路器在什么时候起作用?

涉及到断路器的三个重要参数：快照时间窗、请求总数阀值、错误百分比阀值。

