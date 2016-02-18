- hadoop shell * 通配符
```
hadoop fs -ls "/gn_finish/*201503*"
```
- hadoop shell查看文件夹下文件个数
```
hadoop fs -ls /gn_finish/ |grep "gn_data" | wc -l
```
- hadoop shell 判断文件是否存在
```
hadoop fs -test -e /dir/filename
```
