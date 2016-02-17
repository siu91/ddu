# 创建双分区
```sql
create EXTERNAL table IF NOT EXISTS sdc_data_prase (date string,time string,cookie string,msisdn string,ip string,gps string,sdc_name string,uri string,event_name string,product_name string,bussi_name string,bussi_step string,adid string,adname string,keyword string,active_ad string,error_code string,cs_uri_query string) partitioned by (pt_month bigint,pt_date bigint) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
```
- 添加分区
```sql
ALTER TABLE sdc_data_prase ADD PARTITION (pt_month=201601,pt_date=20160112) location '/sdc_data_prase/201601/';
```

# 创建单分区
```sql
create EXTERNAL table IF NOT EXISTS sdc_data_prase (date string,time string,cookie string,msisdn string,ip string,gps string,sdc_name string,uri string,event_name string,product_name string,bussi_name string,bussi_step string,adid string,adname string,keyword string,active_ad string,error_code string,cs_uri_query string) partitioned by (pt_month bigint) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
  ```
- 添加分区
```sql
ALTER TABLE sdc_data_prase ADD PARTITION (pt_month=201601,pt_date=20160112) location '/sdc_data_prase/201601/';
```

## LOAD数据
```sql
LOAD DATA INPATH '/sdc_data_prase/201601/' INTO TABLE sdc_data_prase PARTITION (pt_month=201601);
```
