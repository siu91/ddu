## 设置 HTTP/HTTPS代理
```shell
git config --global http.proxy http://proxyuser:proxypwd@proxy.server.com:8080
git config --global https.proxy https://proxyuser:proxypwd@proxy.server.com:8080
change proxyuser to your proxy user
change proxypwd to your proxy password
change proxy.server.com to the URL of your proxy server
change 8080 to the proxy port configured on your proxy server
```
## 设置SSL
```shell
git config --global http.sslVerify "false"
git config --global https.sslVerify "false"
```
## 取消设置
```shell
git config --global --unset http.proxy
git config --global --unset https.proxy
```
## 检查配置
```shell
git config --global --get http.proxy
git config --global --get https.proxy
git config --global --get http.sslVerify
git config --global --get https.sslVerify
```
