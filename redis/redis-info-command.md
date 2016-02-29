| 大项  | 小项 |  介绍|
| :------------ | :----------- | ------------------- |
|**server**||                                                                                                                                    |
||	redis_version             |    Redis 服务器版本                                                                                          |
||	redis_git_sha1            |    Git SHA1                                                                                                  |
||	redis_git_dirty           |    Git dirty flag                                                                                            |
||	os                        |    Redis 服务器的宿主操作系统                                                                                |
||	arch_bits                 |    架构（32 或 64 位）                                                                                       |
||	multiplexing_api          |    Redis 所使用的事件处理机制                                                                                |
||	gcc_version               |    编译 Redis 时所使用的 GCC 版本                                                                            |
||	process_id                |    服务器进程的 PID                                                                                          |
||	run_id                    |    Redis 服务器的随机标识符（用于 Sentinel 和集群）                                                          |
||	tcp_port                  |    TCP/IP 监听端口                                                                                           |
||	uptime_in_seconds         |    自 Redis 服务器启动以来，经过的秒数                                                                       |
||	uptime_in_days            |    自 Redis 服务器启动以来，经过的天数                                                                       |
||	lru_clock                 |    以分钟为单位进行自增的时钟，用于 LRU 管理                                                                 |
|**clients**||
||	connected_clients         |    已连接客户端的数量（不包括通过从属服务器连接的客户端）                                                    |
||	client_longest_output_list|    当前连接的客户端当中，最长的输出列表                                                                      |
||	client_longest_input_buf  |    当前连接的客户端当中，最大输入缓存                                                                        |
||	blocked_clients           |    正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量                                                |
|**memory**||                                                                                                                                    |
||	used_memory               |    由 Redis 分配器分配的内存总量，以字节（byte）为单位                                                       |
||	used_memory_human         |    以人类可读的格式返回 Redis 分配的内存总量                                                                 |
||	used_memory_rss           |    从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）。这个值和 top 、 ps 等命令的输出一致。    |
||	used_memory_peak          |    Redis 的内存消耗峰值（以字节为单位）                                                                      |
||	used_memory_peak_human    |    以人类可读的格式返回 Redis 的内存消耗峰值                                                                 |
||	used_memory_lua           |    Lua 引擎所使用的内存大小（以字节为单位）                                                                  |
||	mem_fragmentation_ratio                   |    used_memory_rss 和 used_memory 之间的比率                                                 |
||	mem_allocator             |    在编译时指定的， Redis 所使用的内存分配器。可以是 libc 、 jemalloc 或者 tcmalloc 。                       |
|	**persistence ** ||     RDB 和 AOF 的相关信息|
|	**stats       ** ||     一般统计信息         |
|	**replication ** ||     主/从复制信息        |
|	**cpu         ** ||     CPU 计算量统计信息   |
|	**commandstats** ||     Redis 命令统计信息   |
|	**cluster     ** ||     Redis 集群信息       |
|	**keyspace    ** ||     数据库相关的统计信息 |
