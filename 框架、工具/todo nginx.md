[toc]

# 转发

```
    location / {
        proxy_pass http://api.b9001.com:9001;#转发后访问的地址
    }
   
        location /payment {
     add_header 'Access-Control-Allow-Origin' '*';
        proxy_pass http://api.fhsearch.cn;
    }


    location / {
        proxy_pass http://api.b9001.com:9001;#转发后访问的地址
    }


    location / {
        proxy_pass http://104.233.193.161:9131;#转发后访问的地址
    }


    location /m {# 如果以/m结尾的全指定到/m/index.html下
  try_files $uri $uri/ /m/index.html;       
   }
```



#  过滤 js,css,img

```
    location ~ .*\.(js|css|jpg|jpeg|gif|png|ico|pdf|txt)$ {
        proxy_pass http://104.233.193.161:8082;
    }
```

# 开启跨域

```
    location / {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,Keep-Alive,User-Agent,Cache-Control,Content-Type,Authorization';
    if ($request_method = 'OPTIONS') {
        return 204;
    }   
        proxy_pass http://104.233.193.161:8082;#转发后访问的地址
    }
```

#       单页面刷新404 解决方案    

```
location / {
      try_files $uri $uri/ /index.html;
    }
```



# mac安装nginx

1. `brew install nginx`
2. 运行nginx `nginx`
3. 查看nginx配置文件`cd /usr/local/etc/nginx`

# 常用命令
- 重启 `nginx -s reload`

# nginx配置负载均衡
负载均衡 配置
```
   #  首先，你要有两台或以上可以提供相同服务的Web服务器,不然这个负载均衡配置就没有意义！
    #  在配置过程中只需要改代理服务器的配置就行，其他服务器不用管。
    -    vim /usr/local/nginx/conf/nginx.conf
        #   在http下添加如下代码
            upstream item { # item名字可以自定义
                server 192.168.101.60:81 参数;
                server 192.168.101.77:80 参数;
                # 负载均衡模式(非必选项)
            }
        #   在server 80下添加如下代码
            location /{
                proxy_pass http://item;     # item是在上面命名的
            }
    -   配置 'upstream' 的时候,可以把你的代理服务器也加在里面用来做 'web' 服务器, 但是端口就不用在用80了。
    -   重启你的nginx组件，现在负载均衡就已经可以用了

```
负载均衡 模式
```
    -   '默认轮询'
    #   默认轮询， 如果你是直接复制上面的upstream的话你使用的就是默认轮询方式，请求会随机派发到你配置的服务器上。
    -   '权重分配'
    #   配置方式：  
        upstream item { # item名字可以自定义
            server 192.168.101.60:81 weight=1; 
            server 192.168.101.77:80 weight=2;
        }
    #   weight的值越高被派发请求的概率也就越高，可以根据服务器配置的不同来设置。
    -   '哈希分配'
        upstream item { # item名字可以自定义
            ip_hash;
            server 192.168.101.60:81;
            server 192.168.101.77:80;
        }
    #  原理：他的根据客户端IP来分配服务器，比如我第一次访问请求被派发给了192.168.101.60这台服务器,那么我之后
    #  的请求就都会发送这台服务器上，这样的话session共享的问题也就解决了。
    -   '最少连接分配'
        upstream item { # item名字可以自定义
            least_conn;
            server 192.168.101.60:81;
            server 192.168.101.77:80;
        }
    #   原理：根据上添加的服务器判断哪台服务器分的连接最少就把请求给谁。
```

# nginx 完整配置文件

```
user www www;
worker_processes auto;

error_log /data/wwwlogs/error_nginx.log crit;
pid /var/run/nginx.pid;
worker_rlimit_nofile 51200;

events {
    use epoll;
    worker_connections 51200;
    multi_accept on;
}

http {
    include mime.types;
    default_type application/octet-stream;
    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 1024m;
    client_body_buffer_size 10m;
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 120;
    server_tokens off;
    tcp_nodelay on;

    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    fastcgi_intercept_errors on;

    #Gzip Compression
    gzip on;
    gzip_buffers 16 8k;
    gzip_comp_level 6;
    gzip_http_version 1.1;
    gzip_min_length 256;
    gzip_proxied any;
    gzip_vary on;
    gzip_types
    text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
    text/javascript application/javascript application/x-javascript
    text/x-json application/json application/x-web-app-manifest+json
    text/css text/plain text/x-component
    font/opentype application/x-font-ttf application/vnd.ms-fontobject
    image/x-icon;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    ##Brotli Compression
    #brotli on;
    #brotli_comp_level 6;
    #brotli_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript image/svg+xml;

    ##If you have a lot of static files to serve through Nginx then caching of the files' metadata (not the actual files' contents) can save some latency.
    #open_file_cache max=1000 inactive=20s;
    #open_file_cache_valid 30s;
    #open_file_cache_min_uses 2;
    #open_file_cache_errors on;

    ######################## default ############################
    server {
        listen 443 ssl;
        server_name api.iizvv.online;
        charset utf-8;
        ssl_certificate cert/api.iizvv.online.pem;
        ssl_certificate_key cert/api.iizvv.online.key;
        ssl_session_timeout 5m;
        # ssl_protocols  SSLv2 SSLv3 TLSv1;
        # ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_protocols TLSv1.2;
        ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        ssl_prefer_server_ciphers   on;
        location / {
            proxy_pass http://api.iizvv.online;
            add_header 'Access-Control-Allow-Origin' $http_origin always;
                add_header 'Access-Control-Allow-Credentials' 'true' always;
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
                add_header 'Access-Control-Allow-Headers' 'DNT,Authorization,Accept,Origin,Keep-Alive,User-Agent,X-Mx-ReqToken,X-Data-Type,X-Auth-Token,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range' always;
                add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range' always;
                if ($request_method = "OPTIONS") {
                    return 200;
                }
        }
    }


    server {
        listen 80;
        server_name api.iizvv.online;
        rewrite ^(.*)$ https://$host$1 permanent;
    }

    upstream  api.iizvv.online {
        server  127.0.0.1:8082;
    }

    server {
            listen 443 ssl;
            server_name auto.iizvv.online;
            charset utf-8;
            ssl_certificate cert/auto.iizvv.online.pem;
            ssl_certificate_key cert/auto.iizvv.online.key;
            ssl_session_timeout 5m;
            # ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
            # ssl_protocols SSLv2 SSLv3 TLSv1;
            ssl_protocols TLSv1.2;
            ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
            ssl_prefer_server_ciphers on;
            location / {
                root /html/h5;
                try_files $uri $uri/ /index.html;
            }  
        }

    server {
        listen  80;
        server_name  auto.iizvv.online;
        rewrite ^(.*)$ https://$host$1 permanent;   
    }

    server {
            listen 443 ssl;
            server_name cms.iizvv.online;
            charset utf-8;
            ssl_certificate cert/cms.iizvv.online.pem;
            ssl_certificate_key cert/cms.iizvv.online.key;
            ssl_session_timeout 5m;
            # ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
            # ssl_protocols SSLv2 SSLv3 TLSv1;
            ssl_protocols TLSv1.2;
            ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
            ssl_prefer_server_ciphers on;
            location / {
                root /html/cms;
                try_files $uri $uri/ /index.html;
gzip on;
gzip_min_length 1k;
gzip_buffers 4 16k;
gzip_comp_level 2;
gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
gzip_vary off;
gzip_disable "MSIE [1-6]\.";
            }  
        }

    server {
        listen  80;
        server_name  cms.iizvv.online;
        rewrite ^(.*)$ https://$host$1 permanent;   
    }
   
########################## vhost #############################
include vhost/*.conf;
}
```

