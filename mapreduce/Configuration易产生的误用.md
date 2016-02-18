Hadoop提供了一个扩展性极好的key/value格式的配置管理器Configuration，你可以设置任意的属性名，并通过Configuration对象获取对应的属性值。

Hadoop Common中定义了Configuration的基本实现，其他模块/系统，比如MapReduce，HDFS，YARN，HBase等，均在这个基础实现基础上，实现了自己的Configuration，比如MapReduce中叫JobConf，HDFS中叫HdfsConfiguration，YARN中交YarnConfiguration，HBase中叫HBaseConfiguration，这些Configuration实现非常简单，他们继承基类Configuration，然后加载自己的xml配置文件，通常这些配置文件成对出现，比如MapReduce分别为mapred-default.xml和mapred-site.xml，HDFS分别为hdfs-default.xml，hdfs-site.xml。

Configuraion允许你通过两种方式设置key/value格式的属性，一种是通过set方法，另一种通过addResouce(String name)，将一个xml文件加载到Configuration中。本文重点谈一下第二种使用过程中可能遇到的问题。大家请看下面一段代码：

1
2
3
4
Configuration conf = newConfiguration();
conf.set(“xicheng.dong.age”, “200”)
conf. addResource(“Xicheng.xml”); //Xicheng.xml中设置了xicheng.dong.age为300
System.out.println(conf.get(“xicheng.dong.age”));// 此处会打印几呢？
该程序最后会输出200，而不是xicheng.xml中设置的300，为什么呢？因为当一个配置属性是用户通过set方法设置的时，该属性的来源将被标注为“programatically”，这样的属性是不能被addResource方法覆盖的，必须通过set方法覆盖或修改。在addResource实现中，首先会用指定的xml文件覆盖包含的所有属性，之后再还原“programmatically”来源的那些属性。

那么问题来了，假设你的客户端core-site.xml（创建Configuration对象时，该配置文件会被默认加载）中配置了属性xicheng.dong.age为300，而staging-hbase-site.xml中将其设成了400，那么接下来一段代码会打印什么结果呢？
```java
Configuration conf = HBaseConfiguration.create(newConfiguration());
conf. addResource(“staging-hbase-site.xml”);
System.out.println(conf.get(“xicheng.dong.age”));// 此处会打印几呢？
```
最后结果将是300，而不是400。

如果你把第一句：
```java
Configuration conf = HBaseConfiguration.create(newConfiguration());
```
改为
```java
Configuration conf = HBaseConfiguration.create();
```
结果就是你预想的400，为什么呢？

这是由于HBaseConfiguration.create这个函数造成的，如果带了Configuration参数，则实现如下：
```java
publicstaticConfiguration create(finalConfiguration that) {
  Configuration conf = create();
  merge(conf, that);
  returnconf;
}

publicstaticvoidmerge(Configuration destConf, Configuration srcConf) {
  for(Entry<String, String> e : srcConf) {
    destConf.set(e.getKey(), e.getValue());
  }
}
```
返回的Configuration中所有属性均是通过set方法设置的，这些所有属性均变成了” programatically”来源，之后便不可以被addResource覆盖了。

如果不带Configuration参数，HBaseConfiguration.create实现如下：
```java
publicstaticConfiguration create() {
  Configuration conf = newConfiguration();
  returnaddHbaseResources(conf);
}
```
所有属性的来源均为某个xml文件，比如”core-site.xml”，“hdfs-site.xml”等，这类属性是可以被addResource覆盖的。

总结

使用Hadoop Configuration进行编程的时候，当使用addResource加载xml中配置文件时，一些属性有可能不会被覆盖掉（注意，final的属性总是不可以覆盖），此时一定要注意。你可以使用Configuration中的toString查看各个xml文件的加载顺序，使用dumpConfiguration打印每个属性的来源及isFinal属性值

[原文](http://dongxicheng.org/mapreduce-nextgen/hadoop-configuration-usage/)
