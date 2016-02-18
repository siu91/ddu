当我们执行 `storm kill topo_name`时，发现拓扑并不会马上被kill，有时是几十秒，有时几十分钟。这是由于整个拓扑由一个或几个工作逻辑（spout/bolt），这些工作逻辑又分布在一个或多个worker中。  
实际上当主动kill拓扑时，storm要先处理完已分配的任务（数据），然后kill所有worker，然后整个拓扑才会处于kill状态。而kill过程花费的时间取决于`TOPOLOGY_MESSAGE_TIMEOUT_SECS`的大小，storm会在`TOPOLOGY_MESSAGE_TIMEOUT_SECS`秒之前kill所有worker。
