说明：操作时是在本地电脑上，而不是在远程服务器上。

## 下载 
获取远程服务器上的文件
```
scp -P 2222 root@www.vpser.net:/root/lnmp0.4.tar.gz /home/lnmp0.4.tar.gz
```
获取远程服务器上的目录
```
scp -P 2222 -r root@www.vpser.net:/root/lnmp0.4/ /home/lnmp0.4/
```
## 上传
将本地文件上传到服务器上
```
scp -P 2222 /home/lnmp0.4.tar.gz root@www.vpser.net:/root/lnmp0.4.tar.gz
```
将本地目录上传到服务器上
```
scp -P 2222 -r /home/lnmp0.4/ root@www.vpser.net:/root/lnmp0.4/
```
