## 超级管理员登录
```bash
cassandra-cli -u cassandra -pw cassandra;
```
# 命令帮助
```bash
Commands:
assume                  Apply client side validation.
connect                 Connect to a Cassandra node.
consistencylevel        Sets consisteny level for the client to use.
count                   Count columns or super columns.
create column family    Add a column family to an existing keyspace.
create keyspace         Add a keyspace to the cluster.
del                     Delete a column, super column or row.
decr                    Decrements a counter column.
describe cluster        Describe the cluster configuration.
describe                Describe a keyspace and its column families or column fa
mily in current keyspace.
drop column family      Remove a column family and its data.
drop keyspace           Remove a keyspace and its data.
drop index              Remove an existing index from specific column.
get                     Get rows and columns.
incr                    Increments a counter column.
list                    List rows in a column family.
set                     Set columns.
show api version        Show the server API version.
show cluster name       Show the cluster name.
show keyspaces          Show all keyspaces and their column families.
show schema             Show a cli script to create keyspaces and column familie
s.
truncate                Drop the data in a column family.
update column family    Update the settings for a column family.
update keyspace         Update the settings for a keyspace.
use                     Switch to a keyspace.
```
