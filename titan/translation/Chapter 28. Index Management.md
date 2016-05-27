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
重建索引是一个由多个步骤组成的手动过程。这些步骤必须按照正确的顺序执行，以避免索引不一致。
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
