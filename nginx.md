## 图片转发
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
