
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

# 安装docker

curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

# docker-redis
## 安装redis

```
mkdir -p /mydata/redis/conf
touch /home/data/redis/conf/redis.conf

docker run -p 6379:6739 \
-v /home/data/redis/conf/redis.conf:/etc/redis/redis.conf \
-v /home/data/redis/data/:/data --name redis -d redis:latest \
--requirepass "12*33KdwefaDIjAEfo" 

docker run -p 6379:6739 \
-v /home/data/redis/conf/redis.conf:/etc/redis/redis.conf \
-v /home/data/redis/data/:/data --name redis -d redis:latest \
--requirepass "mypassword"
redis-server /etc/redis/redis.conf
```
##  连接docker 中的reids
```
docker exec -it redis redis-cli

set a b 
get a 
"b"
```
redis 持久化数据

修改redis.conf 添加appendonly yes 表示 持久化数据

redis 可配置的内容有很多我们可以看redis的官方文档.

https://redis.io/topics/config

redis工具

为了方便开发最好安装一些redis可视化工具.
mac 可以安装 another redis desktop manager
windows 可以安装 redis desktop manager
# 删除容器shell

```
#!/bin/sh
NAME=$1
ID=`docker ps -a |grep "$NAME" | awk '{print $1}'`
for id in $ID 
do
docker stop $id 
docker rm $id 
echo 'rm' $id
done 
```

# 删除镜像shell

```

#!/bin/sh
NAME=$1
ID=`docker images | grep "$NAME" | awk '{print $1}'`
for id in $ID
do
docker rmi $id
echo 'rmi' $id
docker ps images
done
```

