# Table of Contents

- 33.1. BigTable Data Model
- 33.2. Titan Data Layout
- 33.3. Individual Edge Layout


Titan 存储图中邻接表(Adjacency list)的格式，这意味着一个图被存储为一个vertex和它的
邻接表的集合。一个vertex的邻接表包含所有vertex关联的edge（和属性）。

采用邻接表存储格式，Titan能确保所有edge的边和属性紧密地存储在后端存，利于加快遍历。
缺点是，每一个edge都要被存储两次（edge的两端都有vertex）。

此外，Titan通过排序sort key（定义的）和edge labels来维护的每个vertex 的邻接表。
用点中心索引时，排序可以高效地检索邻接表子集。

Titan存储邻接表表示一个图在任何后端存储（支持Bigtable的数据模型）。

## 33.1. BigTable Data Model

![BigTable Data Model](../images/bigtablemodel.png)

在Bigtable数据模型下，每一个表是一个行的集合。
每一行由一个键唯一标识。每一行由任意数量的cell（很大，但也有限制）组成。
每个cell由column和value组成。column唯一标识一个cell在给定的行中（key>column>value）。
在Bigtable模型中，行（Row）被称为 "wide rows"，因为他们包含大量的cell，这些cell的column不需要事先定义（关系型数据库中要）。

Titan对Bigtable数据模型有一个额外的要求：cell必须通过它们的column排序并且cell的子集指定的column范围必须能高效检索（例如：通过使用索引结构，跳表，或二进制搜索）。

此外，一个特定的Bigtable可以实现让行按key的排序存储。Titan可以利用这样的key-sort有效的partition the graph（分区），提供了更好的负载和更好的大图遍历性能。然而，这不是一个要求。

## 33.2. Titan Data Layout

![Titan Data Layout](../images/titanstoragelayout.png)

Titan在底层存储后端把每一个邻接表保存为一行（Row）。vertex id指向的行包含了这个vertex的邻接表 （vertex id，长度64bit，它是Titan唯一指定给每一个vertex）。在行中，每一个边和属性被存储在单独的cell，它们允许高效的插入和删除。对于一个特定的存储后端，行所允许的最大数量的cell，也就是Titan能承受vertex的最大程度。

如果存储后端支持key-sort，则邻接表将由点标识（vertex id）来排序，Titan可以指定vertex ids
，这样该图就可以有效地分区。Ids are assigned such that vertices which are frequently co-accessed have ids with small absolute difference.

## 33.3. Individual Edge Layout

![Individual Edge Layout](../images/relationlayout.png)

每一个edge和property被存储为一个cell在row里（与它相邻的点）。

[原文](http://s3.thinkaurelius.com/docs/titan/1.0.0/data-model.html)
