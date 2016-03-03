废话不说，直接上sql。
```sql
CREATE TABLE "RPT_SDC_TOPO_INFO" (
  "TOPO_ID" bigint,
  "CURRENT_COUNT" bigint DEFAULT NULL,
  "CURRENT_APPEND_CNT" bigint DEFAULT NULL,
  "CURRENT_APPEND_SIZE" bigint DEFAULT NULL,
  "CURRENT_COST_TIME" bigint DEFAULT NULL,
  "INSERT_TIME" datetime DEFAULT NULL,
   PRIMARY KEY ("TOPO_ID")
) ENGINE=EXPRESS REPLICATED  DEFAULT CHARSET=utf8 TABLESPACE='sys_tablespace';
```
按照`TOPO_ID`分组，`INSERT_TIME`排序，取每组的***top1***

```sql
select A.* from RPT_SDC_TOPO_INFO A where A.insert_time=(select max(insert_time) from RPT_SDC_TOPO_INFO where topo_id=A.topo_id)
```
