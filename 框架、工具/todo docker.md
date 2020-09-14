[toc]



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

