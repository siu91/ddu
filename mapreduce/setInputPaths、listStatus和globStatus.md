FileInputFormat.setInputPaths(job,paths) path可以给定给一个目录 系统会会从该目录下找打文件作为输入，但是如果给定的目录下面还有一层目录，则系统就不会再深入一层，并且可能会提示错误：
```java
13/01/22 18:12:56 WARN mapred.LocalJobRunner: job_local_0001
java.io.FileNotFoundException: File does not exist: /user/xxx/rule2/a
 at org.apache.hadoop.hdfs.DFSClient$DFSInputStream.openInfo(DFSClient.java:1843)
 at org.apache.hadoop.hdfs.DFSClient$DFSInputStream.<init>(DFSClient.java:1834)
 at org.apache.hadoop.hdfs.DFSClient.open(DFSClient.java:578)
 at org.apache.hadoop.hdfs.DistributedFileSystem.open(DistributedFileSystem.java:154)
 at org.apache.hadoop.fs.FileSystem.open(FileSystem.java:427)
 at org.apache.hadoop.mapreduce.lib.input.LineRecordReader.initialize(LineRecordReader.java:67)
 at org.apache.hadoop.mapred.MapTask$NewTrackingRecordReader.initialize(MapTask.java:522)
 at org.apache.hadoop.mapred.MapTask.runNewMapper(MapTask.java:763)
 at org.apache.hadoop.mapred.MapTask.run(MapTask.java:370)
 at org.apache.hadoop.mapred.LocalJobRunner$Job.run(LocalJobRunner.java:212)
 ```
那这种情况如何处理，能递归找出该目录下所有文件作为输入
这时候可以使用 如下方式 里递归找出目录下的文件
```java
FileSystem fs = FileSystem.get(URI.create(input), conf);
FileStatus[] status = fs.listStatus(in);
Path[] paths = FileUtil.stat2Paths(status);
FileInputFormat.setInputPaths(job, paths);
 ```
这种方式可行，真好用到了listStatus 递归找出目录 并且将paths 加入Input输入

但是又出现一个问题，如果我要用通配符来匹配我输入的路径，从而过滤我需要的一些路径那 最好的建议是用globStatus

这样可以讲 path 以正则表达式的方式列出，可以进一步深入目录 而又能过滤所需
Path in = new Path(“rule2/*”);
这样就把当前目录下一层的文件也取出。
