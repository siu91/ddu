# 启动Storm各个后台进程：
## 主控节点上启动nimbus：
`$ storm nimbus >/dev/null 2>&1 &`
## 在Storm各个工作节点上运行：
`$ storm supervisor >/dev/null 2>&1 &`
## 在Storm主控节点上启动ui：
`$ storm ui >/dev/null 2>&1 &`
## 在Storm所有工作节点上启动logview：
`$ storm logviewer >/dev/null 2>&1 &`
# 停止Storm各个后台进程：
## 关闭nimbus相关进程:
```bash
kill `ps aux | egrep '(daemon\.nimbus)|(storm\.ui\.core)' | fgrep -v egrep | awk '{print $2}'`
```
## 干掉supervisor上的所有storm进程:
```bash
kill `ps aux | fgrep storm | fgrep -v 'fgrep' | awk '{print $2}'`
```
