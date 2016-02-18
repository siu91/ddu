*2016/01/30 星期六 10:04:26*

----------
*Redis Cluster本身不支持pipe，但总有一些曲折的方法可以利用pipe来完成数据导入，即利用redis单机的pipe来导入数据，只需要在集群每一个节点对同一份数据做相同的导入。由于Redis Cluster的hash分布算法，一条数据只能存在于集群中的一个节点上，所以不用担心，数据会在每个节点上重复导入。*
## 导入方法 ##

### 以从数据库中导入为例，其他的从文本、日志等导入一样适用

```sql
CREATE TABLE "CFG_COVER_SCENARIOS" (
  "COVER_SCENARIOS_ID" varchar(64),
  "COVER_SCENARIOS" varchar(64) DEFAULT NULL,
  "REDIS_TABLENAME" varchar(65) DEFAULT NULL,
   PRIMARY KEY ("COVER_SCENARIOS_ID");
```

```sql
CREATE TABLE "cfg_base_station_info" (
  "CI" varchar(32) DEFAULT NULL,
  "CI_NAME" varchar(64) DEFAULT NULL,
  "COVER_SCENARIOS" varchar(64) DEFAULT NULL,
  "LAC" varchar(32) DEFAULT NULL);
```

```sql
SELECT CONCAT(
  '*4','\r\n',
  '$', LENGTH(redis_cmd), '\r\n',
  redis_cmd, '\r\n',
  '$', LENGTH(redis_key), '\r\n',
  redis_key, '\r\n',
  '$', LENGTH(hkey), '\r\n',
  hkey, '\r\n',
  '$', LENGTH(hval), '\r\n',
  hval)
FROM
(select
'HSET' as redis_cmd,
 t1.REDIS_TABLENAME as redis_key,
t2.LAC || t2.CI as hkey,
t2.CI_NAME as hval
from cfg_cover_scenarios t1
inner join cfg_base_station_info t2
on t1.COVER_SCENARIOS=t2.COVER_SCENARIOS
) t
```
*导出的文件：注意保存为dos文件*

### 导出的数据

```shell
[stormdev@hadoop01 pipe]$ more data.txt
*4
$4
HSET
$13
XJAE:CLE:CITY
$10
3920021393
$14
131团医院-3
*4
$4
HSET
$13
XJAE:CLE:CITY
$10
3920021392
$14
131团医院-2
```  

### 利用pipe在集群每一个节点执行导入数据：

```shell
[stormdev@hadoop01 pipe]$ cat data.txt | redis-cli -c -p 8001 --pipe
[stormdev@hadoop01 pipe]$ cat data.txt | redis-cli -c -p 8002 --pipe
[stormdev@hadoop01 pipe]$ cat data.txt | redis-cli -c -p 8003 --pipe
```

### 会出现错误：原因是这些数据CRC算法后不是分布在此节点，导入其他节点便可

```shell
Last reply received from server.
errors: 778, replies: 1000
```
