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
## Nacos配置中心
命名空间+Group+DataId三者关系？

是什么？
```
类型Java里面的 package名和类名
最外层的 namespace是可以用于区分部署环境的，group和dataid逻辑上区分两个目标对象。
默认情况
namespace=public,group=DEFAULT_GROUP,默认cluster是DEFAULT

Nacos默认命名空间是public ,namespace主要用来实现隔离。
比方说我们现在有三个环境：开发，测试，生产环境，我们就可以创建三个namespace。

group默认是DEFAULT_GROUP,group可以把不同的微服务划分到同一个分组里面去。

Service就是微服务；一个Service可以包含多个Cluster(集群)，Nacos默认Cluster是DEFAULT，Cluster是对指定微服务的一个虚拟划分。
比方说为也容灾，将Service微服务分别部署在了杭州机房和广州机房，这时就可以给杭州机房的Service微服务起一个集群名称(HZ).

最后是Instance,就是微服务的实例。


```

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
### Data ID 方式多配置文件切换 方案
在Nacos创建 `nacos-config-client-test.properties`

```
config.info=from nacos config center,nacos-config-test.properties,version=2
```
此时就有两个配置文件了
- nacos-config-client-dev.properties
- nacos-config-client-test.properties

系统进行切换时在`application.properties`文件里修改即可
```
#spring.profiles.active=dev
spring.profiles.active=test
```
### group分组方案
新建Group
```
Data ID:nacos-config-client-info.properties
Group:DEV_GROUP
content: config.info=from nacos config center,nacos-config-client-info.properties, version=1

Data ID:nacos-config-client-info.properties
Group: TEST_GROUP
content: config.info=from nacos config center,nacos-config-client-info.properties TEST_GROUP, version=1 
```
修改`bootstrap.properties` 指定group
```
server.port=3377
spring.application.name=nacos-config-client
spring.cloud.nacos.discovery.server-addr=localhost:8848
spring.cloud.nacos.config.server-addr=localhost:8848
spring.cloud.nacos.config.file-extension=properties
spring.cloud.nacos.config.group=TEST_GROUP
```
修改 `application.properties` 使用 info 
```
#spring.profiles.active=dev
#spring.profiles.active=test
spring.profiles.active=info

```

