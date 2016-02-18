今天在安装atom-beautify 时碰到了错误。先贴error：
```shell
$ apm install atom-beautify
Installing atom-beautify to /home/marcuslt/.atom/packages
gyp info it worked if it ends with ok
gyp info using node-gyp@1.0.2
gyp info using node@0.10.35 | linux | x64
gyp http GET https://atom.io/download/atom-shell/v0.34.5/node-v0.34.5.tar.gz
gyp WARN install got an error, rolling back install
gyp ERR! install error
```
执行 `apm install --check`，还是出现上面的错误。  
Google了一下，找到相似的[问题](https://github.com/atom/apm/issues/322#issuecomment-96430856)。  
摘录网友提供的解决方法。
```text
Seems that node-gyp isn't following the 302 Redirect sent by atom.io.
@fujisaks Thanks for pointing to the problem!
I've been able to workaround the issue by  env variable to the new url (after redirect ). This should also be working after you update Atom. However, remove the entry when the bug gets fixed!
Windows temporary:
set ATOM_NODE_URL=http://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist
Windows permanently:
setx ATOM_NODE_URL http://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist
Linux
export ATOM_NODE_URL=http://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist
```
还是无法下载`node-v0.34.5.tar.gz`  
在`Chrome`打开,发现通过代理可以下载到。  
于是，当然是给`atom`配置代理。我使用的是[XX-Net](https://github.com/XX-net/XX-Net)，怎么配置代理，自己看官网[文档](https://github.com/XX-net/XX-Net/wiki/%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95)，感觉速度还好。  
`atom`配置代理比较简单，只需要配置`C:\Users\{username}\.atom\.apmrc`文件。没有这个文件就自己创建一个。
```
http-proxy = http://127.0.0.1:8087/
https-proxy = http://127.0.0.1:8087/
strict-ssl = false
```
----------
*2016-02-01 星期一 16:50*
