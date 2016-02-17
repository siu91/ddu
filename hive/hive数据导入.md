## Hive的几种常见的数据导入方式
1. 从本地文件系统中导入
1. 从HDFS上导入
1. 从其他表中查询并插入
1. 创建表时从其他表中查询并插入

### 从本地文件系统中导入
- 从本地文件系统中导入数据到Hive表
先在Hive里面创建好表，如下：
```bash
hive> create table test_table
    > (id int, name string,
    > age int, tel string)
    > ROW FORMAT DELIMITED
    > FIELDS TERMINATED BY '\t'
    > STORED AS TEXTFILE;
OK
Time taken: 2.832 seconds
```
- 本地文件系统里`/home/test_table/test_table.txt`文件，内容如下：
```bash
[test_table@master ~]$ cat test_table.txt
1       test_table     25      13188888888888
2       test    30      13888888888888
3       zs      34      899314121
```

- `test_table.txt`文件中的数据列之间是使用`\t`分割的。
- 可以通过下面的语句将这个文件里面的数据导入到test_table表里面，操作如下：
```bash
hive> load data local inpath 'test_table.txt' into table test_table;
Copying data from file:/home/test_table/test_table.txt
Copying file: file:/home/test_table/test_table.txt
Loading data to table default.test_table
Table default.test_table stats:
[num_partitions: 0, num_files: 1, num_rows: 0, total_size: 67]
OK
Time taken: 5.967 seconds
```
- 这样就将`test_table.txt`里面的内容导入到`test_table`表里面去了，可以到`test_table`表的数据目录下查看，如下命令：
```bash
hive> dfs -ls /user/hive/warehouse/test_table ;
Found 1 items
-rw-r--r--3 test_table supergroup 67 2014-02-19 18:23 /hive/warehouse/test_table/test_table.txt
```
- Hive并不支持INSERT INTO …. VALUES形式的语句。

### HDFS上导入数据到Hive表
-  从本地文件系统中将数据导入到Hive表的过程中，其实是先将数据临时复制到HDFS的一个目录下（典型的情况是复制到上传用户的HDFS home目录下,比如/home/test_table/），然后再将数据从那个临时目录下移动（注意，这里说的是移动，不是复制！）到对应的Hive表的数据目录里面。既然如此，那么Hive肯定支持将数据直接从HDFS上的一个目录移动到相应Hive表的数据目录下，假设有下面这个文件/home/test_table/add.txt，具体的操作如下：
```bash
[test@master /home/q/hadoop-2.2.0]$ bin/hadoop fs -cat /home/test_table/add.txt
5       test_table1    23      131212121212
6       test_table2    24      134535353535
7       test_table3    25      132453535353
8       test_table4    26      154243434355
```

- 上面是需要插入数据的内容，这个文件是存放在HDFS上/home/test_table目录（和一中提到的不同，一中提到的文件是存放在本地文件系统上）里面，我们可以通过下面的命令将这个文件里面的内容导入到Hive表中，具体操作如下：
```bash
hive> load data inpath '/home/test_table/add.txt' into table test_table;
Loading data to table default.test_table
Table default.test_table stats:
[num_partitions: 0, num_files: 2, num_rows: 0, total_size: 215]
OK
Time taken: 0.47 seconds
```
```bash
hive> select * from test_table;
OK
5       test_table1    23      131212121212
6       test_table2    24      134535353535
7       test_table3    25      132453535353
8       test_table4    26      154243434355
1       test_table     25      13188888888888
2       test    30      13888888888888
3       zs      34      899314121
Time taken: 0.096 seconds, Fetched: 7 row(s)
```

### 从别的表中查询出相应的数据并导入到Hive表中

- 假设Hive中有test表，其建表语句如下所示：
```bash
hive> create table test(
    > id int, name string
    > ,tel string)
    > partitioned by
    > (age int)
    > ROW FORMAT DELIMITED
    > FIELDS TERMINATED BY '\t'
    > STORED AS TEXTFILE;
OK
Time taken: 0.261 seconds
```
- 下面语句就是将test_table表中的查询结果并插入到test表中:
```bash
hive> insert into table test
    > partition (age='25')
    > select id, name, tel
    > from test_table;
OK
Time taken: 19.125 seconds
```
```bash
hive> select * from test;
OK
5       test_table1    131212121212    25
6       test_table2    134535353535    25
7       test_table3    132453535353    25
8       test_table4    154243434355    25
1       test_table     13188888888888  25
2       test    13888888888888  25
3       zs      899314121       25
Time taken: 0.126 seconds, Fetched: 7 row(s)
```


- 通过上面的输出，我们可以看到从test_table表中查询出来的东西已经成功插入到test表中去了！如果目标表（test）中不存在分区字段，可以去掉partition (age=’25′)语句。当然，我们也可以在select语句里面通过使用分区值来动态指明分区：
```bash
hive> set hive.exec.dynamic.partition.mode=nonstrict;
hive> insert into table test
    > partition (age)
    > select id, name,
    > tel, age
    > from test_table;
OK
Time taken: 17.712 seconds
```
```bash
hive> select * from test;
OK
5       test_table1    131212121212    23
6       test_table2    134535353535    24
7       test_table3    132453535353    25
1       test_table     13188888888888  25
8       test_table4    154243434355    26
2       test    13888888888888  30
3       zs      899314121       34
Time taken: 0.399 seconds, Fetched: 7 row(s)
```

- 这种方法叫做动态分区插入，但是Hive中默认是关闭的，所以在使用前需要先把hive.exec.dynamic.partition.mode设置为nonstrict。当然，Hive也支持insert overwrite方式来插入数据，从字面我们就可以看出，overwrite是覆盖的意思，是的，执行完这条语句的时候，相应数据目录下的数据将会被覆盖！而insert into则不会，注意两者之间的区别。例子如下：
```bash
hive> insert overwrite table test
    > PARTITION (age)
    > select id, name, tel, age
    > from test_table;
```

- 更可喜的是，Hive还支持多表插入，什么意思呢？在Hive中，我们可以把insert语句倒过来，把from放在最前面，它的执行效果和放在后面是一样的，如下:

```bash
hive> show create table test3;
OK
CREATE  TABLE test3(
  id int,
  name string)
Time taken: 0.277 seconds, Fetched: 18 row(s)

hive> from test_table
    > insert into table test
    > partition(age)
    > select id, name, tel, age
    > insert into table test3
    > select id, name
    > where age>25;

hive> select * from test3;
OK
8       test_table4
2       test
3       zs
Time taken: 4.308 seconds, Fetched: 3 row(s)
```

- 可以在同一个查询中使用多个insert子句，这样的好处是我们只需要扫描一遍源表就可以生成多个不相交的输出。这个很酷吧！

### 在创建表的时候通过从别的表中查询出相应的记录并插入到所创建的表中
在实际情况中，表的输出结果可能太多，不适于显示在控制台上，这时候，将Hive的查询输出结果直接存在一个新的表中是非常方便的，我们称这种情况为`CTAS (create table .. as select)`如下：
```bash
hive> create table test4
    > as
    > select id, name, tel
    > from test_table;

hive> select * from test4;
OK
5       test_table1    131212121212
6       test_table2    134535353535
7       test_table3    132453535353
8       test_table4    154243434355
1       test_table     13188888888888
2       test    13888888888888
3       zs      899314121
Time taken: 0.089 seconds, Fetched: 7 row(s)
```
