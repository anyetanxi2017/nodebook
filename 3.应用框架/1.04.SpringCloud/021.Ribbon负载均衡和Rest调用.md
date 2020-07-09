## 添加依赖
```
<!--eureka client-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```
## 配置application.properties
```
server.port=80
spring.application.name=cloud-order-server
# 是否将自己注册到 EurekaServer 默认为true
eureka.client.register-with-eureka=true
# 是否从 EurekaServer 抓取自己的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合 ribbon使用负载均衡
eureka.client.fetch-registry=true
eureka.client.service-url.defaultZone=http://localhost:7001/eureka,http://localhost:7002/eureka
# Eureka 客户端发送心跳的时间间隔 ，单位为秒 （默认为30秒）
eureka.instance.lease-renewal-interval-in-seconds=1
# Eureka 服务端在收到最后一次心跳后等待时间上限，单位为秒（默认90秒），超时将剔除服务
eureka.instance.lease-expiration-duration-in-seconds=2
```

## 配置 RestTeamlate
```
/**
 * @author myrita
 * @date 2020/7/2 11:14
 */
@Configuration
public class ApplicationContextConfig {
    @Bean
    @LoadBalanced //该注解表示开启均衡负载
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }
}
```
## Controller调用
```

@RestController
@Slf4j
public class OrderController {
    public static final String PAYMENT_URL = "http://CLOUD-PAYMENT-SERVICE";
    @Resource
    private RestTemplate restTemplate;

    @GetMapping("/consumer/payment/create")
    public CommonResult<Payment> create(Payment payment) {
        return restTemplate.postForObject(PAYMENT_URL + "/payment/create", payment, CommonResult.class);
    }

    /**
     * restTemplate.getForObject()
     * 该方法返回的是Json格式的数据
     */
    @GetMapping("/consumer/payment/get/{id}")
    public CommonResult<Payment> getPayment(@PathVariable Long id) {
        return restTemplate.getForObject(PAYMENT_URL + "/payment/get/" + id, CommonResult.class);
    }

    /**
     * restTemplate.getForEntity();
     * 该方法可以获取消息头，状态码相关信息
     */
    @GetMapping("/consumer/payment/get/{id}")
    public CommonResult<Payment> getPayment2(@PathVariable Long id) {
        ResponseEntity<CommonResult> entity = restTemplate.getForEntity(PAYMENT_URL + "/payment/get/" + id, CommonResult.class);
        if (entity.getStatusCode().is2xxSuccessful()) {
            return entity.getBody();
        }
        return new CommonResult<>(444, "操作失败");
    }
}

```
