[toc]



## 创建文件

echo
```
echo "this is my first test" > a.txt
cat a.txt
```
cat
```
cat>b.txt<<<EOF
a
b
c
d
EOF
cat b.txt
```
> EOF 表示当再次遇见EOF时结束输入
## echo 追加
```
echo "this is my second add" >>a.txt
cat a.txt

```
## sed 插入删除文件内容

```
sed -i '1i server.prot=9013' a.txt # 在第一行上方 插入
sed -i '1a server.port=9013' a.txt # 在第一行下方 插入
sed -i '1d' a.txt # 删除第一行
```


vim /home/rita/rita-core/src/main/resources/application-pro.properties

## sh文件接收参数

```
cat>a.sh
echo "这是第一个参数 $1"
echo "这是第二个参数 $2"


sh a.sh 1 2
这是第一个参数 1
这是第二个参数 2
```



```shell
port=$1
file=/home/rita/rita-core/src/main/resources/application-pro.properties
sed -i '1d' $file # 删除这个文件里面的第一行
sed -i '1i server.port='$port $file   # 在这个文件中第一行位置添加 
echo 'file update finished'
echo 'begin mvn package'
cd /home/rita/    # 移动到 /home/rita
mvn clean package # 使用 mvn 打包
echo 'package finished! begin copy jar'
name='rita-core-'$1 
cd /home/docker-file/rita-core  #移动到该文件夹
cp /home/rita/rita-core/target/rita-core-0.0.1-SNAPSHOT.jar ./ # 复制文件到
echo 'copy finished'
sh ../utils/rm.sh $name  # 删除容器
sh ../utils/rmi.sh $name # 删除镜像 
docker build -t $name . # 创建镜像
rm -rf rita-core-0.0.1-SNAPSHOT.jar # 删除jar 
docker run -p $port:$port --name $name --net host -d -v /home/logs:/home/logs -v /home/upload:/home/upload $name  # 制作容器并运行
docker logs -f --tail=20 $name
```

