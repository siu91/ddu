
# Chapter 8. Indexing for better Performance
索引获得更好的性能

```
Titan supports two different kinds of indexing to speed up query processing: graph indexes and
vertex-centric indexes. Most graph queries start the traversal from a list of vertices or edges that are
identified by their properties. Graph indexes make these global retrieval operations efficient on large
graphs. Vertex-centric indexes speed up the actual traversal through the graph, in particular when
traversing through vertices with many incident edges.
```
```
Titan支持两种不同的索引来加快查询处理:graph indexes和vertex-centric indexes.
大多数图形查询开始遍历从列表中顶点或边的属性。
图索引使这些全局检索在很大的图中操作有效 。
Vertex-centric索引加快遍历图,特别是当遍历顶点与许多事件的边缘。
```
## Graph Index
```
Graph indexes are global index structures over the entire graph which
allow efficient retrieval ofvertices or edges by their properties
for sufficiently selective conditions. For instance,
consider the following queries
```
```
在整个图中图索引是全局索引结构，如果想通过vertices或edges的属性高效检索，选择图索引。
例如,下面的查询
```
```shell
g.V.has('name','hercules')
g.E.has('reason',CONTAINS,'loves')
```
```
The first query asks for all vertices with the name hercules.
The second asks for all edges where the
property reason contains the word loves.
Without a graph index answering those queries would require a full
scan over all vertices or edges in the graph to find those that
match the given condition which is very
inefficient and infeasible for huge graphs.
```
```
第一个查询要求所有顶点中“name”是"hercules"。
第二个要求所有边中'reason'包含'loves'。
没有图索引这些查询需要一个完整的扫描图中所有顶点或边，在huge graphs中找到那些匹配给定的条件是非常困难并且低效的。
```
```
Titan distinguishes between two types of graph indexes: composite and mixed indexes.
Composite indexes are very fast and efficient but limited
to equality lookups for a particular, previously-defined combination of property keys.
Mixed indexes can be used for lookups on any combination
of indexed keys and support multiple condition predicates
in addition to equality depending on the backing index store.
```
```
Titan区分两种类型的图索引:Composite Index(复合索引)和Mixed Index(混合索引)。
复合索引是非常快和有效,但有限制只能查找已经定义属性的组合键，中等值查找。
混合索引可以用来查找任何索引键的组合,支持多个条件谓词,除了平等取决于索引存储的支持。
```
```
Both types of indexes are created through the Titan management system
and the index builder returned by TitanManagement.buildIndex(String,Class)
where the first argument defines the name of
the index and the second argument specifies the
type of element to be indexed (e.g. Vertex.class).
The name of a graph index must be unique. Graph indexes built against newly defined property
keys, i.e. property keys that are defined in the same management transaction as the index,
are immediately available. Graph indexes built against property keys that are already
in use require the execution of a reindex procedure to ensure that the index contains all previously added
elements. Until the reindex procedure has completed, the index will not be available.
It is encouraged to define graph indexes in the same transaction as the initial schema.
```
```
两种类型的索引创建通过Titan管理系统和返回的索引生成器TitanManagement.buildIndex(String,Class)
的第一个参数定义了索引的名称,第二个参数指定了类型的元素索引(例如Vertex.class)。
图索引的名称必须是唯一的。
图索引建立对新定义的属性键,即相同的管理事务中定义的属性键索引,是立即可用。
```

### Composite Index(复合索引)
```
Composite indexes retrieve vertices or edges by one or a (fixed) composition of multiple keys.
Consider the following composite index definitions.
```
```
复合索引的检索顶点或边的一个或多个键的(固定)组成。见以下复合索引的定义。
```
```shell
mgmt = g.getManagementSystem()
name = mgmt.makePropertyKey('name').dataType(String.class).make()
age = mgmt.makePropertyKey('age').dataType(Integer.class).make()
mgmt.buildIndex('byName',Vertex.class).addKey(name).buildCompositeIndex()
mgmt.buildIndex('byNameAndAge',Vertex.class).addKey(name).addKey(age).buildCompositeIndex()
mgmt.commit()
```
```
First, two property keys name and age are defined. Next,
a simple composite index on just the name property key is built.
Titan will use this index to answer the following query.
```
```
首先,定义了两个属性键'name'和'age'。
接下来,一个简单composite index 建立在刚才设置的'name'上。
Titan将使用这个索引来处理下列查询。
```
```shell
g.V.has('name','hercules')
```
```
The second composite graph index includes both keys.
Titan will use this index to answer the following query.
```
```
第二个复合图索引包含两个键。Titan将使用这个索引来处理下列查询。
```
```shell
g.V.has('age',30).has('name','hercules')
```
```
Note, that all keys of a composite graph index must be found in the
query’s equality conditions for this index to be used. For example, the
following query cannot be answered with either of the indexes because it
only contains a constraint on age but not name.
```
```
注意,在查询中使用的条件中使用到索引必须在复合图索引中完整定义了，
下面这个查询将不会用到任何索引，因为查询中的条件只有'age'并没有'name'。
```
```shell
g.V.has('age',30)
```
```
Also note, that composite graph indexes can only be used for equality
constraints like those in the queries above. The following query would be
answered with just the simple composite index defined on the name key because
the age constraint is not an equality constraint.
```
```
还要注意,复合图索引只能用于等值的查询。
下面的查询将只会用到'name'的索引,因为'age'不是一个等式约束。
```
```shell
g.V.has('name','hercules').interval('age',20,50)
```
```
Composite indexes do not require configuration of
an external indexing backend and are supported through the primary storage backend.
Hence,composite index modifications are persisted through
the same transaction as graph modifications which means that those changes are atomic
and/or consistent if the underlying storage backend supports atomicity and/or consistency.
```
```
复合索引不需要配置一个外部索引后端,通过主存储后端支持。
```
#### Index Uniqueness
```
Composite indexes can also be used to enforce property uniqueness in the graph.
If a composite graph index is defined as unique() there can be
at most one vertex or edge for any given concatenation of
property values associated with the keys of that index.
For instance, to enforce that names are unique across the entire graph
the following composite graph index would be defined.
```
```
复合索引也可以用来让图中的属性唯一。
如果一个复合图索引定义为unique(),最多可以有一个顶点或边对于任何给定的连接属性值与索引key相关。
例如,让'name'的unique()的复合图索引是是这样定义的。
```
```shell
mgmt = g.getManagementSystem()
name = mgmt.makePropertyKey('name').dataType(String.class).make()
mgmt.buildIndex('byName',Vertex.class).addKey(name).unique().buildCompositeIndex()
mgmt.commit()
```

### Mixed Index(混合索引)
```
Mixed indexes retrieve vertices or edges by any combination of previously added property keys.
Mixed indexes provide more flexibility than
composite indexes and support additional condition predicates beyond equality.
On the other hand, mixed indexes are slower for most equality queries than composite indexes.
```
```
混合索引检索顶点或边之前添加属性的任意组合键。
混合索引比复合索引提供更多的灵活性和支持等值之外附加条件。
另一方面,对于大多数等值查询来说，混合索引比复合索引慢。
```
```
Unlike composite indexes, mixed indexes require the configuration of
an indexing backend and use that indexing backend to execute lookup operations.
Titan can support multiple indexing backends in a single installation.
Each indexing backend must be uniquely identified by name in
the Titan configuration which is called the indexing backend name.
```
```
与复合索引不同,混合索引配置索引时，需要配置索引后端和使用索引后端来执行查询。
Titan可以支持多个索引后端安装在一起。
在Titan中每个索引后端必须惟一标识，称为索引后端名。
```
```shell
mgmt = g.getManagementSystem()
name = mgmt.makePropertyKey('name').dataType(String.class).make()
age = mgmt.makePropertyKey('age').dataType(Integer.class).make()
mgmt.buildIndex('nameAndAge',Vertex.class).addKey(name).addKey(age).buildMixedIndex("search")
mgmt.commit()
```
```
The example above defines a mixed index containing the property keys name and age.
The definition refers to the indexing backend name search
so that Titan knows which configured indexing backend it should use for this particular index.
While this index definition looks similar to the
composite index above, it provides greater query support and
can answer any of the following queries.
```
```
上面的例子定义了一个混合索引 包含属性key 'name'和'age'。
这个定义引用了‘search’这个索引后端名，以便Titan才知道哪个已经配置好的索引后端会被这个特定的索引使用。
虽然这个索引定义类似于上面的复合索引,但它提供了更强大的查询支持和能支持下列查询。
```
```shell
g.V.has('name',CONTAINS,'hercules').interval('age',20,50)
g.V.has('name',CONTAINS,'hercules')
g.V.has('age',LESS_THAN,50)
```
```
Mixed indexes support full-text search, range search,
geo search and others. Refer to Chapter 18, Search Predicates
for a list of predicates supported by a particular indexing backend.
Unlike composite indexes, mixed indexes do not support uniqueness.
```
```
混合索引支持全文搜索,搜索范围,地理搜索等等
与复合索引不同，混合索引不支持唯一性索引。
```

`未完成，待更新。。。`

[查看更新](https://github.com/gongice/ddu/blob/master/titan/titan_index.md)

[原文](http://s3.thinkaurelius.com/docs/titan/0.5.0/indexes.html)
