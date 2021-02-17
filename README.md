# 我的笔记本

## 语录
- 现在、当下、此时此刻，才是真正的时间的中心。它才是最重要的东西。所以当你活出了当下，其实就是活出了你的人生。因为你人生的过去是由现在决定的，你人生的未来仍然是由你的现在决定的。每一个不曾起舞的日子，都是对生命的一种辜负。
- 明天永远不会让你变得强壮，只有现在可以。
- 骐骥一跃，不能十步；驽马十架，功在不舍。锲而舍之，朽本不折；锲而不舍，金石可镂。
- 长久的幸福，从来都不能向外求得，而是要向内心索取。感恩和抱怨，贪婪与知足，有多少人分得清界限呢？无外乎就是，好好吃饭，好好劳作，有人爱就去爱，没人爱就爱自己。听风而生，饮雨而活，一餐一食，从容不迫，用切身感受，去思考万事万物。用辛勤劳作去抚平焦灼躁郁。从不依靠，从不寻找，自食其力，自然平静。


---

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
