```sql
create index
bishow.IND_qry_web_analyze_list_daily
on BISHOW.qry_web_analyze_list_daily (class1_name,class2_name,url_name)
local parallel 16 ;
```
