## 区别
- hive表分为内部表和外部表。
 - 外部表在删除时并不会删除hdfs文件,建议使用外部表进行操作。
 - 内部表在删除时会删除掉hdfs中的文件，所以一般用于创建临时表，这样临时表在删除后，也会删除掉hdfs中的数据。

## 测试
### 创建内部表
```
//创建内部表
CREATETABLE tmp.pvlog(ip STRING,CURRENT_DATE STRING,userinfo STRING) partitioned BY(ptDate STRING)ROW format delimited FIELDSTERMINATEDBY'\t' ;
//上传数据
LOADDATALOCAL INPATH '/home/user/logs/log2012-08-14.txt'INTOTABLE tmp.pvlog partition(ptdate='2012-08-14');
LOADDATALOCAL INPATH '/home/user/logs/log2012-08-15.txt'INTOTABLE tmp.pvlog partition(ptdate='2012-08-15');
//修改为外部表
USE tmp ;
ALTERTABLE pvlog SET TBLPROPERTIES ('EXTERNAL'='TRUE');
//查询
SELECT ptdate,COUNT(1)FROM tmp.pvlog  GROUPBY ptdate ;
# 能查询出数据
//删除该表
DROPTABLE pvlog ;
//查询hdfs中的数据
bin/hadoop dfs -ls /USER/hive/warehouse/tmp.db/pvlog/ptdate=*
# 能查询到数据。
ALTERTABLE pvlog ADD partition(ptdate='2012-08-14');
ALTERTABLE pvlog ADD partition(ptdate='2012-08-15');
```
结论：hdfs中的数据不会被删除。
