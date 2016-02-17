Hive可以运行保存在文件里面的一条或多条的语句，只要用-f参数，一般情况下，保存这些Hive查询语句的文件通常用.q或者.hql后缀名，但是这不是必须的，你也可以保存你想要的后缀名。
- 假设test文件里面有一下的Hive查询语句：
```sql
select * from p limit 10;
select count(*) from p;
```
- 那么我们可以用下面的命令来查询：
```bash
$ bin/hive -f test
...
Time taken: 4.386 seconds, Fetched: 10 row(s)
OK
4000000
Time taken: 16.284 seconds, Fetched: 1 row(s)
```

- 如果你配置好了Hive shell的路径，你可以用SOURCE命令来运行那个查询文件:
```bash
$ hive
hive> source /home/hadoop/gsw/test;
...
Time taken: 4.386 seconds, Fetched: 10 row(s)
OK
4000000
Time taken: 16.284 seconds, Fetched: 1 row(s)
```
