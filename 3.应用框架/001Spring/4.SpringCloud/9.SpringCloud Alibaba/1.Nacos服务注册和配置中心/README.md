- [简介](#简介)
- [安装与运行](#安装与运行)
- [服务注册中心演示](#服务注册中心演示)
    - [服务提供者](#服务提供者)
    - [服务消费者](#服务消费者)
- [服务配置中心](#服务配置中心)
    - [Nacos配置中心](#Nacos配置中心)
    - [基础配置](#基础配置)
    - [分类配置](#分类配置)
# 简介
为什么叫Nacos.前四个字母分别为Naming和Configuration的前两个字母，最后一个s为Service。

Nacos是一个更易于构建云原生应用动态服务发现、配置管理和服务管理的平台。

能做什么？替代Eureka做服务注册中心；替代Config做服务配置中心

主页及下载地址 https://github.com/alibaba/nacos

https://nacos.io/en-us/docs/quick-start.html

springcloud 官方学习文档 https://spring-cloud-alibaba-group.github.io/github-pages/hoxton/en-us/index.html#_spring_cloud_alibaba_nacos_discovery

# 安装与运行
- 本地需要有Java8+Maven环境
- 先从官网下载Nacos
- 到bin 目录中启动 Nacos
```
mac/linux  sh startup.sh -m standalone
windows cmd startup.cmd
```
- 访问 `http://localhost:8848/nacos`  默认账户密码都为 `nacos`
# 服务注册中心演示
## 服务提供者 
cloudalibaba-provider-payment9001
### 创建项目`cloudalibaba-provider-payment9001`
### pom
父pom
```
      <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-alibaba-dependencies</artifactId>
        <version>2.1.0.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
```
子pom
```
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>

    <dependency>
      <groupId>com.alibaba.cloud</groupId>
      <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
    </dependency>
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
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
### application.properties
```
server.port=9001
spring.application.name=nacos-payment-provider
spring.cloud.nacos.discovery.server-addr=localhost:8848
management.endpoints.web.exposure.include=*
```
### main
```
@SpringBootApplication
@EnableDiscoveryClient
public class PaymentMain9001 {

  public static void main(String[] args) {
    SpringApplication.run(PaymentMain9001.class, args);
  }
}
```
### controlelr
```
  @RestController
  public class PaymentController {

    @Value("${server.port}")
    private String port;

    @GetMapping("/payment/nacos/{id}")
    public String getPayment(@PathVariable("id") Integer id) {
      return "nacos registry,serverPort:" + port + "\t" + id;
    }

  }
```

启动 9001 和9002
> 启动9002 可以复制9001 只需要在 VM optins 参数中加 -DServer.port=9002 即可

## 服务消费者
### 创建 cloudalibaba-consumer-nacos-order83
### pom
```
  <dependencies>
    <dependency>
      <groupId>com.alibaba.cloud</groupId>
      <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
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
### application.properties
```
server.port=83
spring.application.name=nacos-order-consumer
spring.cloud.nacos.discovery.server-addr=localhost:8848
management.endpoints.web.exposure.include=*
# 消费者将要去访问的微服务名称(注册成功进nacos的微服务提供者)
service-url.nacos-user-service=http://nacos-payment-provider
```
### 主启动类
```
@EnableDiscoveryClient
@SpringBootApplication
public class OrderNacosMain83 {

  public static void main(String[] args) {
    SpringApplication.run(OrderNacosMain83.class, args);
  }
}
```
### RestTemplate配置类
```
@Configuration
public class RestTemplateConfig {

  @Bean
  @LoadBalanced
  public RestTemplate getRestTemplate() {
    return new RestTemplate();
  }
}
```
### 控制类
```
@RestController
@Slf4j
public class OrderNacosController {

  @Value("${service-url.nacos-user-service}")
  private String serverURL;
  @Resource
  private RestTemplate restTemplate;

  @GetMapping("/consumer/payment/nacos/{id}")
  public String paymentInfo(@PathVariable("id") Long id) {
    return restTemplate.getForObject(serverURL + "/payment/nacos/" + id, String.class);
  }
}
```

启动 83并测试 

访问`http://localhost:83/consumer/payment/nacos/3`

会发现两个微服务已经开始正常提供
```
nacos registry,serverPort:9001 3
nacos registry,serverPort:9002 3 
```

---

# 服务配置中心
## 基础配置
1. 创建 cloudalibaba-config-nacos-client3377
2. pom.xml
```
  <dependencies>
    <dependency>
      <groupId>com.alibaba.cloud</groupId>
      <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
    </dependency>
    <dependency>
      <groupId>com.alibaba.cloud</groupId>
      <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
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
3. bootstrap.properties
```
server.port=3377
spring.application.name=nacos-config-client
spring.cloud.nacos.discovery.server-addr=localhost:8848
spring.cloud.nacos.config.server-addr=localhost:8848
spring.cloud.nacos.config.file-extension=properties

```
4. application.properties
```
spring.profiles.active=dev
```
5. 主启动类
```
@SpringBootApplication
@EnableDiscoveryClient
public class NacosConfigClientMain3377 {

  public static void main(String[] args) {
    SpringApplication.run(NacosConfigClientMain3377.class, args);
  }
}
```
6. controller
```
@RestController
@RefreshScope //支持Nacos的动态刷新功能
public class ConfigClientController {

  @Value("${config.info}")
  private String configInfo;

  @GetMapping("/config/info")
  public String getConfigInfo() {
    return configInfo;
  }
}

```
7. Nacos中的匹配规则

Nacos中的dataid的组成格式及与SpringBoot配置文件中的匹配规则
https://nacos.io/zh-cn/docs/quick-start-spring-cloud.html

http://localhost:8848/ nacos页面中新建配置文件 
nacos-config-client-dev.properties 
内容如下

`config.info=config info for dev.from nacos ocnfig center`

> nacos-config-client-dev.properties 公式为: ${spring.application.name}-${spring.profiles.active}.{spring.cloud.nacos.config.file-extension}
>
> prefix 的值 默认为 spring.application.name 的值
>
> spring.profiles.active 即为当前环境对应的profile, 可以通过配置项 spring.profile.active来配置。
>
> file-extension 为配置内容的数据格式，可以通过配置项 spring.cloud.nacos.config.file-extension来配置

**nacos 配置中心默认自动刷新，只要修改配置后，自动就刷新了**
## 分类配置
## Nacos配置中心
