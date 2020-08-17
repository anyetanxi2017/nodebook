* [简介](#简介)
* [三大核心概念](#三大核心概念)
    * [Rute](#Rute)
    * [Predicate](#Predicate)
    * [Filter](#Filter)
* [工作流程](#工作流程)
* [demo](#demo)
* [通过微服务名实现动态路由](#通过微服务名实现动态路由)
* [Predicate的使用](#Predicate的使用)
* [Filter的使用](#Filter的使用)
# 简介
```
SpringCloud Gatway旨在提供一种简单而有效的方式来对API进行路由，以及提供一些强大的过滤器功能，例如：熔断、限流、重试等。
SpringCloud Gatway是基于WebFlux框架实现的，而WebFlux框架底层则使用了高性能的Reactor模式通知框架Netty。

SpringCloud Gatway具体如下特性：
基于Spring Framework 5，Project Reactor 和 Spring Boot 2.0进行构建；
动态路由，能够匹配任何请求属性；
可以对路由指定Predicate（断言）和Filter（过滤）
集成Hystrix的断路器功能；
集成Spring Cloud 服务发现功能；
请求限流功能；
运行路径重写。
```
# 三大核心概念
## Rute
路由是构建网关的基本模块，它由ID，目标URI，一系列的断言和过滤器组成，如果断言为true则匹配该路由。

## Predicate
参考的是Java8的java.util.function.Predicate 开发人员可以匹配HTTP请求中的所有内容（例如请求头或请求参数），如果请求与断言相匹配则进行路由。

## Filter
指的是Spring框架中GatewayFilter的实例，使用过滤器，可以在请求被 路由前或者之后对请求进行修改。
# 工作流程
核心逻辑就是路由转发+执行过滤器链

客户端向SpringCloud Gateway 发出请求。然后在Gateway Handler Mapping 中找到与请求相匹配的路由，将其改善到Gateway Web Handler。

Handler 再通过指定的过滤器链来将请求改到我们实际的服务执行业务逻辑，然后返回。
过滤器之间用虚线分开是因为过滤器可能会在改善代理请求之前或之后执行业务逻辑。

Fitler在请求之前类型的过滤器可以做核验、权限核验、流量监控、日志输出、协议转换等，在 post 类型的过滤器中可以做响应内容、响应头的修改，日志的输出，流量监控等有着非常重要的作用。

# demo
## pom.xml
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
## Gateway网关配置的两种方式
方式一：application.properties
```
server.port=9527
spring.application.name=cloud-gateway
# 路由的ID，没有固定规则但要求唯一，建议配合服务名
spring.cloud.gateway.routes[0].id=payment_routh
# 匹配后提供服务的路由地址
spring.cloud.gateway.routes[0].uri=http://localhost:8001
# 断言，路径相匹配的进行路由 注意：这里 "=Path=+路由的接口" 为固定写法 P不能为小写 
spring.cloud.gateway.routes[0].predicates[0]=Path=/payment/get/**
eureka.instance.hostname=cloud-gateway-service
eureka.client.service-url.registerWithEureka=true
eureka.client.service-url.fetchRegistry=true
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka

```
方式二：JavaBean
```
/**
 * @author myrita
 * @date 2020/7/17 20:43
 */
@Configuration
public class GateWayConfig {
  @Bean
  public RouteLocator customRouteLocator(RouteLocatorBuilder routeLocatorBuilder) {
    RouteLocatorBuilder.Builder routes = routeLocatorBuilder.routes();
    return routes.route("path_route_1", r -> r.path("/payment/get/**").uri("http://localhost:8001"))
        .route("path_route_2", r -> r.path("/plan/**").uri("http://kuozhan.ysdgd9.com")).build();
    /*
     * 说明  参数ID不能相同， uri参数为代理的网关端口（注意不能加/接口，不然找不到）  path参数为代理端口下的接口
     *
     */
  }
}

```
## Main9527
```
@SpringBootApplication
@EnableEurekaClient
public class GateWayMain9527 {
  public static void main(String[] args) {
    SpringApplication.run(GateWayMain9527.class, args);
  }
}

```
## 测试
step1:启动之前写的cloud-provider-payment8001 微服务

直接访问 localhost:8001/payment/get/31

通过网关访问 localhost:9527/payment/get/31

都会得到同样的结果
```
{
    "code": 200,
    "message": "查询成功8001",
    "data": {
        "id": 31,
        "serial": "hehe23"
    }
}
```

# 通过微服务名实现动态路由
默认情况下Gateway会根据注册中心注册的服务列表，以注册中心上微服务名为路径创建动态路由进行转发，从而实现动态路由的功能

启动 eureka +两个服务提供者 8001/8002

修改application.properties 配置为true
```
server.port=9527
spring.application.name=cloud-gateway
eureka.instance.hostname=cloud-gateway-service
eureka.client.service-url.registerWithEureka=true
eureka.client.service-url.fetchRegistry=true
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka
# 开启从注册中心动态创建路由的功能，利用微服务进行路由
spring.cloud.gateway.discovery.locator.enabled=true

```
配置类， uri里面的地址写成 lb://cloud-payment-service 微服务名
其中lb表示均衡负载。
```
@Configuration
public class GateWayConfig {
  @Bean
  public RouteLocator customRouteLocator(RouteLocatorBuilder routeLocatorBuilder) {
    RouteLocatorBuilder.Builder routes = routeLocatorBuilder.routes();

    return routes.route("path_route_1", r -> r.path("/payment/get/**").uri("lb://cloud-payment-service"))
        .route("path_route_2", r -> r.path("/plan/**").uri("https://kuozhan.ysdgd9.com")).build();
    /*
     * 说明  参数ID不能相同， uri参数为代理的网关端口(lb:表示负载均衡)（注意不能加/接口，不然找不到）  path参数为代理端口下的接口
     */
  }
}

```
如果是配置文件则修改如下
```
# 路由的ID，没有固定规则但要求唯一，建议配合服务名
spring.cloud.gateway.routes[0].id=payment_routh
## 匹配后提供服务的路由地址
spring.cloud.gateway.routes[0].uri=lb://cloud-payment-service
# 断言，路径相匹配的进行路由 注意：这里 "=Path=+路由的接口" 为固定写法 P不能为小写
spring.cloud.gateway.routes[0].predicates[0]=Path=/payment/get/**
# 开启从注册中心动态创建路由的功能，利用微服务进行路由 
spring.cloud.gateway.discovery.locator.enabled=true

```

# Predicate的使用
https://cloud.spring.io/spring-cloud-gateway/2.1.x/multi/multi_gateway-request-predicates-factories.html

# Filter的使用
功能：路由过滤器可用于修改进入的HTTP请求和返回的HTTP响应，路由过滤器只能指定路由进行使用。
SpringCloud Gateway 内置了多种路由过滤器，他们都由GatewayFilter的工厂类来产生

```
/**
 * @author myrita
 * @date 2020/7/18 10:52
 */
@Component
@Slf4j
public class MyLogGatewayFilter implements GlobalFilter, Ordered {
  @Override
  public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
    log.info("************* come in MyLogGatewayFilter:" + new Date());
    String uname = exchange.getRequest().getQueryParams().getFirst("uname");
    if (uname == null) {
      log.info("************ 用户为null，非法用户！");
      exchange.getResponse().setStatusCode(HttpStatus.NOT_ACCEPTABLE);
      return exchange.getResponse().setComplete();
    }
    return chain.filter(exchange);
  }

  @Override
  public int getOrder() {
    return 0;
  }
}

```
