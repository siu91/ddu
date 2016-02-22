eg: 
```sql
select  /*+parallel(t,10)*/count(distinct t.user_id) from xdmiddle.ft_mid_gn_client_flux_daily t where t.sum_date =20141105
```
```sql
1.查询
Sql代码  
SELECT /*+ Parallel(t,8) */ * FROM emp t;  
SELECT /*+ Parallel(8) */ * FROM emp t;  
SELECT /*+ Parallel */ * FROM emp t;         

2.创建索引
create index idx_emp_test on emp(empno,ename,job) nologging parallel 32;  
--创建索引的时候，如果有条件的话一定要加并行！客户这边的ExaData服务器，对运单表（5000多万记录，90多个字段，60多G数据）创建索引，索引字段包含6列，并行度开到64，创建索引耗时竟然只消耗13秒多点，把俺惊讶的……

3.执行表分析
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => 'scott',tabname => 'emp',    degree => 32,cascade => true);  

4.插入
INSERT /*+ append parallel(30) */   
INTO t_a  
SELECT /*+ parallel(30) */  
FROM t_b  

-- PS:个人在客户ExaData服务器上 使用insert select做测试, insert加 Append后, 加不加Parallel 效果没有什么差别,不知为何.  但后面的select 不加Parallel 差别太大了
```
