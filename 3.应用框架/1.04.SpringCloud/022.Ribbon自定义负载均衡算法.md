## IRule
Ribbon核心组件IRule：根据特定算法从服务列表中选择一个要访问的服务
### 分类
- com.netflix.loadbalancer.RoundRobinRule 轮询
- com.netflix.loadbalancer.RandomRule 随机 
- com.netflix.loadbalancer.RetryRule 先按照RoundRobinRule的策略获取服务，如果获取服务失败则再指定时间内重试，获取可用服务
- WeightResponseTimeRule 对RoundRobinRule的扩展，响应速度越快的实例选择权重越大
- BestAvailableRule 会先过滤掉由于多次访问故障而处于断路器跳闸状态的服务，然后选择一个并发量最小的服务
- AvailabilityFilterRule 先过滤掉故障实例，再选择并发较小的实例
- ZoneAvoidanceRule 默认规则，复合判断server所在区域的性能和server的可用性选择服务器

### 如何替换
修改cloud-consumer-order80

Step1
```
创建 com.eiletxie.myrule  
/**
 * @author myrita
 * @date 2020/7/9 15:15
 */
@Configuration
public class MySelfRule {
    @Bean
    public IRule myRUle() {
        return new RandomRule();
    }
}
```
注意 MySelfRule不能和OrderMan80在同一个包下。

Step2 OrderMan80 添加 @RibbonClient
```
@SpringBootApplication
@EnableEurekaClient
@RibbonClient(name = "CLOUD-PAYMENT-SERVICE", configuration = MySelfRule.class)
public class OrderMan80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderMan80.class, args);
    }
}

```
