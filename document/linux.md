## 服务器之间文件拷贝

scp -P 8631 xahot.zip root@45.10.210.181:/root/

## 打包、觖压

- 打包 zip -q -r xahot.zip ./
- 解压 tar -zxf XXX.tar.gz -C 解压位置

## 常用命令

- lsof https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html
- 查看端口号占用情况 lsof -i
- 查看某个端口占用情况 lsof -i tcp:8080
- 查看进程占用的端口 netstat -nltp | grep 进程号
- 查询文件大小
    - ll -h
    - ls -lht
- 查看文件夹大小 du -h --max-depth=1 ./
- 设置时间 date -s 07:40:00

## 问题-ls cd失效解决方法

直接输入以下命令
`export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin`

## linux登录远程服务器

```
ssh-p端口号 服务器用户名@ip
ssh-p10088 root@104.233.193.161 
```

## linux 关闭进程

Kill -15 pid

|  代号   | 名称 | 内容|
|---|--- |---|
| 1  | SIGHUP |启动被终止的程序，可让该进程重新读取自己的配置文件，类似重新启动。
| 2  | SIGINT |相当于用键盘输入 [ctrl]-c 来中断一个程序的进行。
| 9  | SIGKILL | 代表强制中断一个程序的进行，如果该程序进行到一半，那么尚未完成的部分可能会有“半产品”产生，类似 vim会有 .filename.swp 保留下来。
| 15  | SIGTERM | 以正常的方式来终止该程序。由于是正常的终止，所以后续的动作会将他完成。不过，如果该程序已经发生问题，就是无法使用正常的方法终止时，输入这个 signal 也是没有用的。
| 19  | SIGSTOP | 相当于用键盘输入 [ctrl]-z 来暂停一个程序的进行。

## linux反选删除文件.md

打开extglob模式 extglob正则的意思

```
shopt -s extglob 
rm -rf !(filename) 
shopt -u extglob
```
## 远程下载

获取远程服务器上的文件

```
scp -P 2222 root@www.vpser.net:/root/lnmp0.4.tar.gz /home/lnmp0.4.tar.gz
```

获取远程服务器上的目录

```
scp -P 2222 -r root@www.vpser.net:/root/lnmp0.4/ /home/lnmp0.4/
```

## 远程上传

将本地文件上传到服务器上

```
scp -P 2222 /home/lnmp0.4.tar.gz root@www.vpser.net:/root/lnmp0.4.tar.gz
```

将本地目录上传到服务器上

```
scp -P 2222 -r /home/lnmp0.4/ root@www.vpser.net:/root/lnmp0.4/
```
