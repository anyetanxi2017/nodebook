* [解决的问题](#解决的问题)
* [SpringCloudConfig简介](#SpringCloudConfig简介)
* [demo](#demo)
* [Config动态刷新之手动版本](#Config动态刷新之手动版本)

# 解决的问题
微服务意味着要将单体应用中的业务拆分成一个个子服务，每个服务的粒度相对较小，因此系统中会出现大量的服务。
由于每个服务都需要必要的配置信息才能运行，所以一套集中式的、动态的配置管理设施是必不可少的。

# SpringCloudConfig简介
SpringCloud Config 为微服务架构中的微服务提供集中化的外部配置支持。配置服务器为各个不同微服务应用的所有环境提供了一个中心化的外部配置。

作用
```
集中管理配置文件
不同环境不同配置，动态化更新，分环境部署比如 dev/test/prod/beta/release
运行期间动态调整配置，不再需要在每个服务部署的机器上编写配置文件，服务会向配置中心统计摘取配置自己的信息。
当配置发生变动时，服务不需要重启即可感知到配置的变化并应用到配置。
将配置信息以REST接口的形式暴露。
```
# demo
首先在github上创建 `springcloud-config` 项目 并创建文件`config-dev.properties` 内容如下
```
config.info=master branch springcloud-config/config-dev.properties version=1
```
## 创建服务端 cloud-config-center-3344 模块
### pom.xml
```
<dependencies>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-server</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
  </dependency>
  <dependency>
    <groupId>com.atguigu.springcloud</groupId>
    <artifactId>cloud-api-commons</artifactId>
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
  </project>
```
### application.properties
注意这里，uri要使用https的方式，不然会报错

```
server.port=3344
spring.application.name=cloud-config-center
spring.cloud.config.server.git.uri=https://github.com/anyetanxi2017/springcloud-config.git
# 搜索目录
spring.cloud.config.server.git.search-paths=springcloud-config
# 读取分支
spring.cloud.config.server.git.default-label=master
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka

```
### main
```
@SpringBootApplication
@EnableConfigServer
public class ConfigCenterMain3344 {
  public static void main(String[] args) {
    SpringApplication.run(ConfigCenterMain3344.class, args);
  }
}

```
### 测试（即可访问github上面的内容）
http://localhost:3344/master/config-dev.properties
```
    config.info: master branch springcloud-config/config-dev.properties version=1
```
## Config客户端配置与测试
### pom.xml
```
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-config</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--监控-->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
      <groupId>com.atguigu.springcloud</groupId>
      <artifactId>cloud-api-commons</artifactId>
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
### bootstrap.properties
```
server.port=3355
spring.application.name=config-client
# 分支名称
spring.cloud.config.label=master
# 配置文件名称
spring.cloud.config.name=config
# 读取后缀名称
spring.cloud.config.profile=dev
spring.cloud.config.uri=http://localhost:3344
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka
```
### main 
```
@SpringBootApplication
@EnableEurekaClient
public class ConfigClientMain3355 {
  public static void main(String[] args) {
    SpringApplication.run(ConfigClientMain3355.class, args);
  }
}

```
### controller
获取配置文件里面的内容
```
@RestController
public class ConfigClientController {
    @Value("${config.info}")
    private String configInfo;

    @GetMapping("/configInfo")
    public String getConfigInfo() {
        return configInfo;
    }
}
```
### 测试
访问 `http://localhost:3355/configInfo` 即可查看到配置信息
```
master branch springcloud-config/config-dev.properties version=1
```
# Config动态刷新之手动版本


