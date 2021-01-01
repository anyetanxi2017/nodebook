# nodebook
我的笔记本

## Linux
### 服务器之间文件拷贝
scp -P 8631 xahot.zip root@45.10.210.181:/root/
### 打包、觖压
- 打包 zip -q -r xahot.zip ./
- 解压 tar -zxf XXX.tar.gz -C 解压位置
## Docker
### docker修改日志默认存储路径
https://blog.csdn.net/zhangjunli/article/details/106716800
### 安装redis
下载redis
```
docker pull redis
```
创建相关文件
```
mkdir -p /mydata/redis/conf
touch /mydata/redis/conf/redis.conf
```
> 修改redis.conf 添加appendonly yes 表示 持久化数据 <br>
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
