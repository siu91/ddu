# Table of Contents (目录)

- [28.1. Reindexing (重建索引)](#28.1.)
 - [28.1.1. Overview (概述)](#28.1.1.)
 - [28.1.2. Prior to Reindex (重建索引之前)](#28.1.2.)
 - [28.1.3. Preparing to Reindex (准备重建索引)](#28.1.3.)
 - [28.1.4. Executing a Reindex Job on MapReduce (MapReduce重建索引)](# 28.1.4.)
 - [28.1.5. Executing a Reindex job on TitanManagement(TitanManagement重建索引)](#28.1.5.TitanManagement重建索引)
- 28.2. Index Removal
 - 28.2.1. Overview (概述)
 - 28.2.2. Preparing for Index Removal
 - 28.2.3. Executing an Index Removal Job on MapReduce
 - 28.2.4. Executing an Index Removal job on TitanManagement
- 28.3. Common Problems with Index Management
 - 28.3.1. IllegalArgumentException when starting job
 - 28.3.2. Could not find index
 - 28.3.3. Cassandra Mappers Fail with "Too many open files"




## 28.1. Reindexing (重建索引)
```
Section 8.1, “Graph Index” and Section 8.2,
“Vertex-centric Index” describe how to build graph-global
and vertex-centric indexes to improve query performance.
These indexes are immediately available
if the indexed keys or labels have been newly defined
in the same management transaction. In this case,
there is no need to reindex the graph and this section can be skipped.
If the indexed keys or labels already existed prior to
index construction it is necessary to reindex the entire graph
in order to ensure that the index contains previously added elements.
This section describes the reindexing process.
```
```
8.1节,“Graph Index”和8.2节,“Vertex-centric Index”描述了
如何构建graph-global和Vertex-centric索引来提高查询性能。
如果索引键或标签是在相同的管理事务中被新建的，这些索引会立即生效。
在这种情况下,不需要重建索引图,可以跳过这一节。
如果索引键或标签已经创建过，就需要在整个图中重建索引,以确保索引包含以前添加的元素。
本节就是描述重建索引的过程。
```
```
Warning
Reindexing is a manual process comprised of multiple steps.
These steps must be carefully followed in
the right order to avoid index inconsistencies
```
```
警告
重建索引是由多个步骤组成的手动过程。这些步骤必须按照正确的顺序执行,以避免索引不一致。
```

### 28.1.1. Overview (概述)

```
Titan can begin writing incremental index updates right
after an index is defined. However, before the index is complete and usable,
Titan must also take a one-time read pass over all existing
graph elements associated with the newly indexed schema type(s).
Once this reindexing job has completed, the index is fully populated
and ready to be used. The index must then be enabled to be
used during query processing.
```
```
Titan 可以在索引定义之后写入增量的索引更新。
然而,在索引是完成并可用之前,Titan还必须采取一次性读过
所有（已经存在于图中的）与新索引模式类型有关的元素。
一旦这重建索引的工作完成,该索引是完整的,就可以使用了。
在查询过程中，这个索引必须启用。
```

### 28.1.2. Prior to Reindex (重建索引之前)

```
The starting point of the reindexing process is the construction of an index.
Refer to Chapter 8, Indexing for better Performance for a complete discussion
of global graph and vertex-centric indexes.
Note, that a global graph index is uniquely identified by its name.
A vertex-centric index is uniquely identified by the combination of
its name and the edge label or property key on which the index
is defined - the name of the latter is referred to
as the index type in this section and only applies to vertex-centric indexes.

After building a new index against existing schema elements
it is recommended to wait a few minutes for the index
to be announced to the cluster. Note the index name
(and the index type in case of a vertex-centric index)
since this information is needed when reindexing.
```
```
重建索引过程的第一步是建设一个索引。
参阅 第八章、索引为更好的性能的完整讨论【Graph 索引】和【vertex-centric索引】。
注意：
一个全局的【Graph 索引】由它的名称唯一标识。
一个【vertex-centric 索引】是由它的名字和边的标签或属性键（这个索引已经定义的）惟一标识的,
后者的名字被称为索引类型在这一节和只适用于【vertex-centric索引】。

在新的索引建立之后，针对已经存在的模式元素，需要等待几分钟让集群知道这个索引。
注意索引名称(在vertex-centric索引中称为索引类型)自重建索引时需要这些信息。
```

### 28.1.3. Preparing to Reindex (准备重建索引)

```
There is a choice between two execution frameworks for reindex jobs:
- MapReduce
- TitanManagement

Reindex on MapReduce supports large, horizontally-distributed databases.
Reindex on TitanManagement spawns a single-machine OLAP job.
This is intended for convenience and speed on those databases
small enough to be handled by one machine.

Reindexing requires:
- The index name (a string — the user provides this to Titan when building a new index)
- The index type (a string — the name of the edge label or property key on which the vertex-centric index is built).
This applies only to vertex-centric indexes - leave blank for global graph indexes.
```
```
对于重建索引工作有两个执行框架供选择:
- MapReduce
- TitanManagement
MapReduce支持大型重建索引,horizontally-distributed(水平分布)数据库。
TitanManagement重建索引以单机OLAP的方式，这样很便捷，只要数据能在单机中放得下。

重建索引需要:
- 索引名称(字符串-用户提供了这种泰坦在构建一个新的索引)
- 索引类型(字符串-边的标签名或属性键(vertex-centric索引建立的))。
  这只适用于vertex-centric，对于全局图索引这项留空
```

### 28.1.4. Executing a Reindex Job on MapReduce (MapReduce重建索引)

```
The recommended way to generate and run a reindex job on MapReduce is through the MapReduceIndexManagement class. Here is a rough outline of the steps to run a reindex job using this class:

- Open a TitanGraph instance
- Pass the graph instance into MapReduceIndexManagement's constructor
- Call updateIndex(<index>, SchemaAction.REINDEX) on the MapReduceIndexManagement instance
- If the index has not yet been enabled, enable it through TitanManagement

This class implements an updateIndex method that supports only
the REINDEX and REMOVE_INDEX actions for its SchemaAction parameter.
The class starts a Hadoop MapReduce job using the Hadoop configuration
and jars on the classpath. Both Hadoop 1 and 2 are supported.
This class gets metadata about the index and storage backend
(e.g. the Cassandra partitioner) from the TitanGraph
instance given to its constructor.
```
```
在MapReduce上创建并执行重建索引工作，推荐用MapReduceIndexManagement类。 下面是一个大概的步骤：
- 打开一个TitanGraph实例
- 将图实例传到MapReduceIndexManagement的构造函数中
- 调用 MapReduceIndexManagement.updateIndex(<index>, SchemaAction.REINDEX)方法
- 如果该索引尚未启用,通过TitanManagement启用它

这个类实现了一个updateIndex方法只支持REINDEX和REMOVE_INDEX actions ，即SchemaAction参数。例如：updateIndex(REINDEX)
这个类启动一个Hadoop MapReduce job通过classpath下的Hadoop配置文件和jars包。
Hadoop 1.x和2.x都支持。
这个类从TitanGraph实例给它的构造函数获取元数据：索引和存储后端(如Cassandra partitioner)。
```
```shell
graph = TitanFactory.open(...)
mgmt = graph.openManagement()
mr = new MapReduceIndexManagement(graph)
mr.updateIndex(mgmt.getRelationIndex(mgmt.getRelationType("battled"), "battlesByTime"), SchemaAction.REINDEX).get()
mgmt.commit()
```

#### 28.1.4.1. Reindex Example on MapReduce (MapReduce重建索引的例子)

```
The following Gremlin snippet outlines all steps of
the MapReduce reindex process in one self-contained
example using minimal dummy data against the
Cassandra storage backend.
```
```
以下是一个自带的Gremlin 脚本示例，用少量的样例数据和Cassandra为存储后端，列出了MapReduce重建索引的所有步骤
```
```shell
// Open a graph
graph = TitanFactory.open("conf/titan-cassandra-es.properties")
g = graph.traversal()

// Define a property
mgmt = graph.openManagement()
desc = mgmt.makePropertyKey("desc").dataType(String.class).make()
mgmt.commit()

// Insert some data
graph.addVertex("desc", "foo bar")
graph.addVertex("desc", "foo baz")
graph.tx().commit()

// Run a query -- note the planner warning recommending the use of an index
g.V().has("desc", containsText("baz"))

// Create an index
mgmt = graph.openManagement()

desc = mgmt.getPropertyKey("desc")
mixedIndex = mgmt.buildIndex("mixedExample", Vertex.class).addKey(desc).buildMixedIndex("search")
mgmt.commit()

// Rollback or commit transactions on the graph which predate the index definition
graph.tx().rollback()

// Block until the SchemaStatus transitions from INSTALLED to REGISTERED
report = mgmt.awaitGraphIndexStatus(graph, "mixedExample").call()

// Run a Titan-Hadoop job to reindex
mgmt = graph.openManagement()
mr = new MapReduceIndexManagement(graph)
mr.updateIndex(mgmt.getGraphIndex("mixedExample"), SchemaAction.REINDEX).get()

// Enable the index
mgmt = graph.openManagement()
mgmt.updateIndex(mgmt.getGraphIndex("mixedExample"), SchemaAction.ENABLE_INDEX).get()
mgmt.commit()

// Block until the SchemaStatus is ENABLED
mgmt = graph.openManagement()
report = mgmt.awaitGraphIndexStatus(graph, "mixedExample").status(SchemaStatus.ENABLED).call()
mgmt.rollback()

// Run a query -- Titan will use the new index, no planner warning
g.V().has("desc", containsText("baz"))

// Concerned that Titan could have read cache in that last query, instead of relying on the index?
// Start a new instance to rule out cache hits.  Now we're definitely using the index.
graph.close()
graph = TitanFactory.open("conf/titan-cassandra-es.properties")
g.V().has("desc", containsText("baz"))
```

### 28.1.5.TitanManagement重建索引

```
To run a reindex job on TitanManagement, invoke TitanManagement.
updateIndex with the SchemaAction.REINDEX argument. For example:
```
```
TitanManagement重建索引的工作,调用TitanManagement.updateIndex(index, SchemaAction.REINDEX)
例如:
```
```shell
m = graph.openManagement()
i = m.getGraphIndex('indexName')
m.updateIndex(i, SchemaAction.REINDEX).get()
m.commit()
```
#### 28.1.5.1. Example for TitanManagement (TitanManagement的例子)

```
The following loads some sample data into a BerkeleyDB-backed Titan database,
defines an index after the fact, reindexes using TitanManagement, and finally
enables and uses the index:
```
```
下面的一些示例数据装入一个BerkeleyDB-backed泰坦数据库,定义了索引后,使用TitanManagement重建索引,最后启用并使用索引:
```
```java
import com.thinkaurelius.titan.graphdb.database.management.ManagementSystem

// Load some data from a file without any predefined schema
graph = TitanFactory.open('conf/titan-berkeleyje.properties')
g = graph.traversal()
m = graph.openManagement()
m.makePropertyKey('name').dataType(String.class).cardinality(Cardinality.LIST).make()
m.makePropertyKey('lang').dataType(String.class).cardinality(Cardinality.LIST).make()
m.makePropertyKey('age').dataType(Integer.class).cardinality(Cardinality.LIST).make()
m.commit()
graph.io(IoCore.gryo()).readGraph('data/tinkerpop-modern.gio')
graph.tx().commit()

// Run a query -- note the planner warning recommending the use of an index
g.V().has('name', 'lop')
graph.tx().rollback()

// Create an index
m = graph.openManagement()
m.buildIndex('names', Vertex.class).addKey(m.getPropertyKey('name')).buildCompositeIndex()
m.commit()
graph.tx().commit()

// Block until the SchemaStatus transitions from INSTALLED to REGISTERED
ManagementSystem.awaitGraphIndexStatus(graph, 'names').status(SchemaStatus.REGISTERED).call()

// Reindex using TitanManagement
m = graph.openManagement()
i = m.getGraphIndex('names')
m.updateIndex(i, SchemaAction.REINDEX)
m.commit()

// Enable the index
ManagementSystem.awaitGraphIndexStatus(graph, 'names').status(SchemaStatus.ENABLED).call()

// Run a query -- Titan will use the new index, no planner warning
g.V().has('name', 'lop')
graph.tx().rollback()

// Concerned that Titan could have read cache in that last query, instead of relying on the index?
// Start a new instance to rule out cache hits.  Now we're definitely using the index.
graph.close()
graph = TitanFactory.open("conf/titan-berkeleyje.properties")
g = graph.traversal()
g.V().has('name', 'lop')
```

## 28.2. Index Removal (删除索引)

```
Warning
Index removal is a manual process comprised of multiple steps.
These steps must be carefully followed in the right order to avoid index inconsistencies.
```
```
警告
删除索引是一个由多个步骤组成的手动过程。
这些步骤必须按照正确的顺序执行,以避免索引不一致。
```

### 28.2.1. Overview (概述)

```
Index removal is a two-stage process. In the first stage,
one Titan signals to all others via the storage backend
that the index is slated for deletion.
This changes the index’s state to DISABLED.
At that point, Titan stops using the index
to answer queries and stops incrementally updating the index.
Index-related data in the storage backend remains present but ignored.

The second stage depends on whether the index is mixed or composite.
A composite index can be deleted via Titan.
As with reindexing, removal can be done through either MapReduce
or TitanManagement. However, a mixed index must be manually dropped
in the index backend; Titan does not provide an automated mechanism
to delete an index from its index backend.

Index removal deletes everything associated with the index
except its schema definition and its DISABLED state.
This schema stub for the index remains even after deletion,
sthough its storage footprint is negligible and fixed.
```
```
删除索引的过程分成两个阶段。
第一阶段,一个Titan信号通过存储后端告诉其他的？？索引将会被删除。
这时，索引的状态变为 DISABLED。
同时，Titan停止使用这个索引进行查询、立即停止更新索引。
与索引相关的数据存储后端仍存在,但忽略了。

第二阶段取决于是复合索引还是混合索引（ mixed or composite）。
一个复合索引可以通过泰坦被删除。在重建索引过程中,可以通过MapReduce或TitanManagement移除索引。
然而,混合索引必须手动在索引后端删除。
Titan不提供一个自动化的机制,从其索引后端删除索引。

索引移除会删除所有与之有关的，除了它的schema定义和它的DISABLED状态。
```

### 28.2.2. Preparing for Index Removal (准备删除索引)

```
If the index is currently enabled, it should first be disabled.
This is done through the ManagementSystem.
```
```
如果该索引当前是启用,它应该首先被禁用。
这是通过ManagementSystem。
```
```shell
mgmt = graph.openManagement()
rindex = mgmt.getRelationIndex(mgmt.getRelationType("battled"), "battlesByTime")
mgmt.updateIndex(rindex, SchemaAction.DISABLE_INDEX).get()
gindex = mgmt.getGraphIndex("byName")
mgmt.updateIndex(gindex, SchemaAction.DISABLE_INDEX).get()
mgmt.commit()
```
```·
Once the status of all keys on the index changes to DISABLED,
the index is ready to be removed.
A utility in ManagementSystem can automate the wait-for-DISABLED step:
```
```
一旦所有索引上的键都DISABLED，这个索引已经准备好被删除了。
在ManagementSystem中有一个工具可以自动wait-for-DISABLED:
```
```shell
ManagementSystem.awaitGraphIndexStatus(graph, 'byName').status(SchemaStatus.DISABLED).call()
```
```
After a composite index is DISABLED, there is a choice between two execution frameworks for its removal:

- MapReduce
- TitanManagement
Index removal on MapReduce supports large, horizontally-distributed databases.
Inedx removal on TitanManagement spawns a single-machine OLAP job.
This is intended for convenience and speed on those databases small enough
to be handled by one machine.

Index removal requires:

- The index name (a string — the user provides this to Titan when building a new index)
- The index type (a string — the name of the edge label or property key on which the vertex-centric index is built).
This applies only to vertex-centric indexes - leave blank for global graph indexes.

As noted in the overview, a mixed index must be manually dropped from the indexing backend.
Neither the MapReduce framework nor the TitanManagement framework will delete a mixed
backend from the indexing backend.
```
```
复合索引DISABLED(禁用)后,有两种方法移除索引:
- MapReduce
- TitanManagement
MapReduce支持大型重建索引,horizontally-distributed(水平分布)数据库。
TitanManagement重建索引以单机OLAP的方式，这样很便捷，只要数据能在单机中放得下。

索引删除要求:
- 索引名称(字符串-用户提供了这种泰坦在构建一个新的索引)
- 索引类型(字符串-边的标签名或属性键(vertex-centric索引建立的))。
  这只适用于vertex-centric，对于全局图索引这项留空
如上所概述的,混合索引必须手动从后端索引删除。
无论是MapReduce还是TitanManagement都会从索引后端删除混合后端。
```
