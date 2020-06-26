**请将Redis的密码设置复杂** (上次设置复杂后就没有问题了)

1. 检查资源占用最高的进程
```
top -H / top -c
```
2. 杀掉进程，删除文件
```
kdevtmpfsi 有守护进程 kinsing，单独kill掉 kdevtmpfsi 无用。查看进程号后再kill，并清理掉文件。一般在 /tmp 及 /var/tmp/下

1. ps -ef | grep kinsing
2. ps -ef | grep kdevtmpfsi
```
3. 清理定时
```
因为挂载Yarn用户下，检查 crontab 下是否有其他定时，清除掉。

crontab -e -u yarn

```
4. 清理启动项
```
检查是否有可疑启动项，清除。
	1. cd /etc/rc.d/
	2. # 及目录下 /etc/rc0.d/、/etc/rc1.d/、/etc/rc2.d/、/etc/rc3.d/、/etc/rc4.d/、/etc/rc5.d/、/etc/rc6.d/
	3. 
	4. cat /etc/rc.local
	5. cat /etc/inittab

```
5. 清理公钥
```
检查是否有可疑公钥。
cat ~/.ssh/authoruzed_keys
```
6. 修复
```
根据实际情况，修复被利用的漏洞，或设置定向访问，或配置权限，或修复防火墙等等。
```
