## 查看关闭端口占用

```
netstat -ano

netstat -aon|findstr "8080"

taskkill -PID 进程号 -F 
```

## 如何批量保存windows聚集壁纸.md

https://zhuanlan.zhihu.com/p/30914809

Step1 在文件夹地址中输入

```
%localappdata%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
```

Step2 在此路径中cmd输入命令

```
ren *.* *.jpg
```
