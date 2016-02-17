- 表添加一列
```sql
hive> ALTER TABLE pokes ADD COLUMNS (new_col INT);
```
- 添加一列并增加列字段注释
```sql
hive> ALTER TABLE invites ADD COLUMNS (new_col2 INT COMMENT 'a comment');
```
- 增加、删除分区
 - 增加
 ```sql
ALTER TABLE table_name ADD [IF NOT EXISTS] partition_spec [ LOCATION 'location1' ] partition_spec [ LOCATION 'location2' ] ...
      partition_spec:
  : PARTITION (partition_col = partition_col_value, partition_col = partiton_col_value, ...)
```
 - 删除
 ```sql
ALTER TABLE table_name DROP partition_spec, partition_spec,...
```
- 重命名表
```sql
ALTER TABLE table_name RENAME TO new_table_name
```
- 修改列的名字、类型、位置、注释：
```sql
ALTER TABLE table_name CHANGE [COLUMN] col_old_name col_new_name column_type [COMMENT col_comment] [FIRST|AFTER column_name]
```
- 表添加一列
```sql
hive> ALTER TABLE pokes ADD COLUMNS (new_col INT);
```
- 添加一列并增加列字段注释
```sql
hive> ALTER TABLE invites ADD COLUMNS (new_col2 INT COMMENT 'a comment');
```

- 增加/更新列
```sql
ALTER TABLE table_name ADD|REPLACE COLUMNS (col_name data_type [COMMENT col_comment], ...)  
```
*ADD是代表新增一字段，字段位置在所有列后面(partition列前),REPLACE则是表示替换表中所有字段*

- 增加表的元数据信息
```sql
ALTER TABLE table_name SET TBLPROPERTIES table_properties table_properties::[property_name = property_value…..]
```
*用户可以用这个命令向表中增加metadata*

- 改变表文件格式与组织
```sql
ALTER TABLE table_name SET FILEFORMAT file_format
ALTER TABLE table_name CLUSTERED BY(userid) SORTED BY(viewTime) INTO num_buckets BUCKETS
```
*这个命令修改了表的物理存储属性*

- 创建／删除视图
```sql
CREATE VIEW [IF NOT EXISTS] view_name [ (column_name [COMMENT column_comment], ...) ][COMMENT view_comment][TBLPROPERTIES (property_name = property_value, ...)] AS SELECT
DROP VIEW view_name
```

- 创建数据库
```sql
CREATE DATABASE name
```

- 显示命令
```sql
show tables;
show databases;
show partitions ;
show functions
describe extended table_name dot col_name
```
