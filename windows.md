## 查看关闭端口占用
```
netstat -ano

netstat -aon|findstr "8080"

taskkill -PID 进程号 -F 
```
