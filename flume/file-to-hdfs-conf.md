```bash
######################################anget-1###################################
##########
#channels#
##########
agent-1.channels=ch-1
################################################################################
agent-1.channels.ch-1.type=file
agent-1.channels.ch-1.checkpointDir=/home/hadoop/flume_test/checkpoint
agent-1.channels.ch-1.dataDirs=/home/hadoop/flume_test/data
################################################################################
#########
#sources#
#########
agent-1.sources=src-1
################################################################################
agent-1.sources.src-1.type=spooldir
agent-1.sources.src-1.channels=ch-1
agent-1.sources.src-1.spoolDir=/home/hadoop/flume_test/log
agent-1.sources.src-1.deletePolicy=never
agent-1.sources.src-1.fileHeader= true
#【1】
agent-1.sources.src-1.interceptors=i1
#【2】
#agent-1.sources.src-1.interceptors.i1.type=timestamp
#过滤不读取tmp后缀的文件（避免采集文件存在同时读写造成agent挂了）
agent-1.sources.src-1.ignorePattern = ^(.)*\\.tmp$
#【3】
agent-1.sources.src-1.basenameHeader = true
#【4】
agent-1.sources.src-1.basenameHeaderKey = basename
################################################################################
#######
#sinks#
#######
agent-1.sinks=sink_hdfs
################################################################################
agent-1.sinks.sink_hdfs.channel=ch-1
agent-1.sinks.sink_hdfs.type=hdfs
#这样配置【目录自动生成功能（按天：%Y-%m-%d  按小时：/%y-%m-%d/%H）】可能出现：java.lang.NullPointerException: Expected timestamp in the Flume event headers, but it was null
#需要配置【1】和【2】或者【5】
agent-1.sinks.sink_hdfs.hdfs.path=hdfs://mycluster:8020/user/hadoop/events/%Y-%m-%d
#agent-1.sinks.sink_hdfs.hdfs.filePrefix=logs
#文件前缀以原文件命名，需要配置【3】和【4】
agent-1.sinks.sink_hdfs.hdfs.filePrefix=%{basename}
#避免文件在写入hdfs被使用（当文件写入hdfs时是以tmp文件结尾的），可以配置在写的过程中前缀以"."开始的
agent-1.sinks.sink_hdfs.hdfs.inUsePrefix=.
agent-1.sinks.sink_hdfs.hdfs.rollInterval=30
agent-1.sinks.sink_hdfs.hdfs.rollSize=0
agent-1.sinks.sink_hdfs.hdfs.rollCount=0
agent-1.sinks.sink_hdfs.hdfs.batchSize=1000
agent-1.sinks.sink_hdfs.hdfs.writeFormat=text
agent-1.sinks.sink_hdfs.hdfs.fileType=DataStream
#【5】
#agent-1.sinks.sink_hdfs.hdfs.useLocalTimeStamp = true
#agent-1.sinks.sink_hdfs.hdfs.fileType=CompressedStream
#agent-1.sinks.sink_hdfs.hdfs.codeC=lzop
################################################################################
```
```bash
flume-ng agent -c /home/hadoop/flume_test/conf -f /home/hadoop/flume_test/conf/f1.conf -n agent-1 > /home/hadoop/flume_test/logfile 2>&1 &
```
