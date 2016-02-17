```sql
hive> select * from test1;
111111
222222
888888
hive> select * from test2;
111111
333333
444444
888888
hive> select * from test1 join test2 on test1.uid = test2.uid;
111111  111111
888888  888888
hive> select * from test1 left outer join test2 on test1.uid = test2.uid;
111111  111111
222222  NULL
888888  888888
hive> select * from test1 right outer join test2 on test1.uid = test2.uid;
NULL
111111  111111
NULL    333333
NULL    444444
888888  888888
hive> select * from test1 full outer join test2 on test1.uid = test2.uid;
NULL
111111  111111
222222  NULL
NULL    333333
NULL    444444
888888  888888
hive> select * from test1 left semi join test2 on test1.uid = test2.uid;
111111  111111
888888  888888

```
