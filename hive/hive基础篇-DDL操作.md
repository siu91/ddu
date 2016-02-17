## 认识hive
Hive 是基于Hadoop 构建的一套数据仓库分析系统，它提供了丰富的SQL查询方式来分析存储在Hadoop 分布式文件系统中的数据，可以将结构化的数据文件映射为一张数据库表，并提供完整的SQL查询功能，可以将SQL语句转换为MapReduce任务进行运行，通过自己的SQL 去查询分析需要的内容，这套SQL 简称Hive SQL，使不熟悉mapreduce 的用户很方便的利用SQL 语言查询，汇总，分析数据。而mapreduce开发人员可以把
己写的mapper 和reducer 作为插件来支持Hive做更复杂的数据分析。它与关系型数据库的SQL 略有不同，但支持了绝大多数的语句如DDL、DML以及常见的聚合函数、连接查询、条件查询。HIVE不适合用于联机事务处理，也不提供实时查询功能。它最适合应用在基于大量不可变数据的批处理作业。 HIVE的特点：可伸缩（在Hadoop的集群上动态的添加设备），可扩展，容错，输入格式的松散耦合。

## DDL 操作
- 创建简单表
`hive> CREATE TABLE pokes (foo INT, bar STRING);`
- 创建外部表：
```sql
CREATE EXTERNAL TABLE page_view(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User',
     country STRING COMMENT 'country of origination')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
STORED AS TEXTFILE
LOCATION '<hdfs_location>';
```
- 建分区表:
```sql
CREATE TABLE par_table(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(date STRING, pos STRING)
ROW FORMAT DELIMITED ‘\t’
   FIELDS TERMINATED BY '\n'
STORED AS SEQUENCEFILE;
```
- 建Bucket表
```sql
CREATE TABLE par_table(viewTime INT, userid BIGINT,
     page_url STRING, referrer_url STRING,
     ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(date STRING, pos STRING)
CLUSTERED BY(userid) SORTED BY(viewTime) INTO 32 BUCKETS
ROW FORMAT DELIMITED ‘\t’
   FIELDS TERMINATED BY '\n'
STORED AS SEQUENCEFILE;
```
- 创建表并创建索引字段ds  
```sql
hive> CREATE TABLE invites (foo INT, bar STRING) PARTITIONED BY (ds STRING);
```

- 复制一个空表
```sql
CREATE TABLE empty_key_value_store LIKE key_value_store;
```
- 显示所有表
```sql
hive> SHOW TABLES;
```
- 按正条件（正则表达式）显示表
```sql
hive> SHOW TABLES '.*s';
```
[下一篇：修改表结构](hive基础篇-修改表结构.md)
