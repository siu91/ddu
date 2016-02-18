*2016/01/30 星期六 15:50:43*

----------
## 检查环境 ##
- 确保系统安装zlib,否则gem install会报(no such file to load -- zlib)
- 安装ruby
- 安装rubygem  
 [离线安装](https://rubygems.global.ssl.fastly.net/rubygems/rubygems-2.4.8.tgz "rubygems-2.4.8.tgz")

	    cd /path/gem  
	    sudo ruby setup.rb  
	    sudo cp bin/gem /usr/local/bin
- 安装gem-redis  
[离线安装](https://rubygems.global.ssl.fastly.net/gems/redis-3.2.1.gem "redis-3.2.1.gem")  

	    gem install -l /path/redis-3.2.1.gem  

## 编译安装包 ##
- 解压redis安装包、`make install`最后出现下面信息，编译成功。

	    make[1]: Leaving directory `/usr/lib/redis/redis-3.0.1/src'
- 将编译好的文件分发到各物理机  

## 构建集群  
***相关脚本和参考配置：***[quick-build-redis-cluster](https://github.com/gongice/quick-build-redis-cluster.git "quick-build-redis-cluster.git")  
### 生成配置文件   
	    $ ./bin/build-conf.sh port_list  
### 初始化节点   
	    $ ./bin/init-single-node.sh port_list  
### 远程主机上生成配置文件和初始化节点  
	    $ ./running-script-on-remote-machines.sh hostname script port_list  
### 构建集群   
	    $ ./bin create-cluster.sh master slave port  
### 交流   
[http://gshiwen.com](http://gshiwen.com)
