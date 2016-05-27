## 28.1. Reindexing(重建索引)
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
