- [mac安装nginx](#mac安装nginx)
- [nginx配置负载均衡](#nginx配置负载均衡)
- [常用命令](#常用命令)
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
