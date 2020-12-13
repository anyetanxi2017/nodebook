[toc]


# 安装docker

curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

# docker-redis
## 安装redis

```
mkdir -p /mydata/redis/conf
touch /home/data/redis/conf/redis.conf

docker run -p 6379:6379 --name redis \
-v /home/redis/conf/:/home/redis/ \
-v /home/redis/data/:/home/redis/data \
--restart=always \
-d redis redis-server /home/redis/redis.conf 
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

