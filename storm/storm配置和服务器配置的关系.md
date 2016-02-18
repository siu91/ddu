- 按服务器的硬件配置可以计算：
 - worker和slot的数量关系是`1:1`，一个worker占用一个slot。(`计算集群worker和slot数量一般以每个服务器的CPU线程数来计算`)
 - spout并发数，`builder.setSpout("words",newKafkaSpout(kafkaConfig),10)`
(Spout线程数根据kafka topic的partition数量
来定，一般是`1:1`的关系)
 - bolt的并发数`builder.setBolt("words",newKafkaBolt(),10)`
(bolt的并发数量，决定了处理掉效率。数量依据数据量做测试)
