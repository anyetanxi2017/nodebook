## 图片转发 方式一
```
   location ~ .*\.(gif|jpeg|png) {  
            root /home/upload;#指定图片存放路径  
            proxy_store on;  
            proxy_store_access user:rw group:rw all:rw;  
            proxy_temp_path         /home/upload;#图片访问路径  
            proxy_redirect          off;  
            proxy_set_header        Host 127.0.0.1;  
            client_max_body_size    10m;  
            client_body_buffer_size 1280k;  
            proxy_connect_timeout   900;  
            proxy_send_timeout      900;  
            proxy_read_timeout      900;  
            proxy_buffer_size       40k;  
            proxy_buffers           40 320k;  
            proxy_busy_buffers_size 640k;  
            proxy_temp_file_write_size 640k;  
    } 
```
## 图片转发 方式二
```
        location / {
         	root C:/Users/admin/Desktop/learn/gin-vue-admin-master/server/rita_core;#指定图片存放路径  
            proxy_store on;  
            proxy_store_access user:rw group:rw all:rw;  
            proxy_temp_path         C:/Users/admin/Desktop/learn/gin-vue-admin-master/server/rita_core;#图片访问路径  
            proxy_redirect          off;  
            proxy_set_header        Host 127.0.0.1;  
            client_max_body_size    10m;  
            client_body_buffer_size 1280k;  
            proxy_connect_timeout   900;  
            proxy_send_timeout      900;  
            proxy_read_timeout      900;  
            proxy_buffer_size       40k;  
            proxy_buffers           40 320k;  
            proxy_busy_buffers_size 640k;  
            proxy_temp_file_write_size 640k;  
            index  index.html index.htm;
        }
```
## ip转发
```
    location / {
        proxy_pass http://103.49.60.130:8080/renren-fast/;
        proxy_set_header Host $host:$server_port; # 获取用户的真实ip
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Real-PORT $remote_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    } 
```
## windows nginx 命令
- 启动 `start nginx`
- 停止 `nginx.exe -s stop`
- 重新打开日志文件 `nginx.exe -s reopen`
- 查看nginx 版本 `nginx -v`
- 重新载入Nginx `nginx.exe -s reload`
