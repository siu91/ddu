- reduce task数量：

 - 可通过job.setNumReduceTasks(n);设定。
 - reduce task的数量由mapred.reduce.tasks这个参数设定，默认值是1
 - 合适的reduce task数量是0.95或者0.75*( nodes * mapred.tasktracker.reduce.tasks.maximum), 其中，mapred.tasktracker.tasks.reduce.maximum的数量一般设置为各节点cpu core数量，即能同时计算的slot数量。对于0.95，当map结束时，所有的reduce能够立即启动；对于1.75，较快的节点结束第一轮reduce后，可以开始第二轮的reduce任务，从而提高负载均衡
 增加task的数量，一方面增加了系统的开销，另一方面增加了负载平衡和减小了任务失败的代价；

- map task的数量:
 - 即mapred.map.tasks的参数值，用户不能直接设置这个参数。Input Split的大小，决定了一个Job拥有多少个map。默认input split的大小是64M（与dfs.block.size的默认值相同）。然而，如果输入的数据量巨大，那么默认的64M的block会有几万甚至几十万的Map Task，集群的网络传输会很大，最严重的是给Job Tracker的调度、队列、内存都会带来很大压力。mapred.min.split.size这个配置项决定了每个 Input Split的最小值，用户可以修改这个参数，从而改变map task的数量。
 - 一个恰当的map并行度是大约每个节点10-100个map，且最好每个map的执行时间至少一分钟。
