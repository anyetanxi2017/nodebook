
## 进入容器
```
docker exec -it web bash
```

## docker修改日志默认存储路径
https://blog.csdn.net/zhangjunli/article/details/106716800
## 安装redis
下载redis
```
docker pull redis
```
创建相关文件
```
mkdir -p /mydata/redis/conf
touch /mydata/redis/conf/redis.conf

appendonly yes
requirepass 12*33KdwefaDIjAEfo
bind 0.0.0.0
```
> 更多配置 看这里 https://redis.io/topics/config

制作镜像
```
docker run -p 6379:6379 --name redis \
-v /mydata/redis/conf/redis.conf:/etc/redis/redis.conf \
-v /mydata/redis/data/:/data \
--restart=always \
-d redis redis-server /etc/redis/redis.conf 
```
连接
```
docker exec -it redis redis-cli
```
