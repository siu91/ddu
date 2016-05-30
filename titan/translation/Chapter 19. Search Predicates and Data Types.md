# Table of Contents (目录)

- [19.1. Compare Predicate](#191-compare-predicate-比较谓词)
- [19.2. Text Predicate](#192-text-predicate-文本谓词)
- [19.3. Geo Predicate](#193-geo-谓词)
- [19.4. Query Examples](#194-query-examples-查询示例)
- [19.5. Data Type Support](#195-data-type-support-支持的数据类型)
- [19.6. Geoshape Data Type](#196-geoshape-data-type-geoshape-类型)
- [19.7. Collections](#197-collections-集合)

这个页面列出了所有Titan在全局图搜索和局部遍历支持的比较谓词。

## 19.1. Compare Predicate (比较谓词)

索引查询支持以下谓词:

- eq (equal)
- neq (not equal)
- gt (greater than)
- gte (greater than or equal)
- lt (less than)
- lte (less than or equal)

## 19.2. Text Predicate (文本谓词)

有两种类型的文本谓词，用于查询匹配的文本或字符串值。

- 针对单词在文本中。这些谓词不区分大小写的。
 - textContains: true  文本字符串中至少包含一个单词与查询字符串匹配
 - textContainsPrefix: true 文本字符串中至少包含一个单词是beginWith(查询字符串)
 - textContainsRegex: true 文本字符串中至少包含一个单词是匹配给定的正则表达式

- 针对整个字符串。
 - textPrefix: true  如果整个字符串是beginWith(查询字符串)
 - textRegex: true 如果整个字符串是匹配给定的正则表达式
See Section 20.1, “Full-Text Search” for more information about full-text and string search.

*参见20.1节,“全文搜索”，获得更多关于全文搜索的信息。*

## 19.3. Geo 谓词

地理位置谓词geoWithin，适用于一个几何对象包含其他的几何对象（true）。？？？

## 19.4. Query Examples (查询示例)
下面这些查询示例演示了一些谓词的使用在教程图上。
```shell
g.V().has("name", "hercules")
// 2) Find all vertices with an age greater than 50
g.V().has("age", gt(50))
// or find all vertices between 1000 (inclusive) and 5000 (exclusive) years of age and order by increasing age
g.V().has("age", inside(1000, 5000)).order().by("age", incr)
// which returns the same result set as the following query but in reverse order
g.V().has("age", inside(1000, 5000)).order().by("age", decr)
// 3) Find all edges where the place is at most 50 kilometers from the given latitude-longitude pair
g.E().has("place", geoWithin(Geoshape.circle(37.97, 23.72, 50)))
// 4) Find all edges where reason contains the word "loves"
g.E().has("reason", textContains("loves"))
// or all edges which contain two words (need to chunk into individual words)
g.E().has("reason", textContains("loves")).has("reason", textContains("breezes"))
// or all edges which contain words that start with "lov"
g.E().has("reason", textContainsPrefix("lov"))
// or all edges which contain words that match the regular expression "br[ez]*s" in their entirety
g.E().has("reason", textContainsRegex("br[ez]*s"))
// 5) Find all vertices older than a thousand years and named "saturn"
g.V().has("age", gt(1000)).has("name", "saturn")
```

## 19.5. Data Type Support (支持的数据类型)

Titan的复合索引支持任何数据类型的存储，而混合索引只支持以下数据类型：

- Byte
- Short
- Integer
- Long
- Float
- Double
- Decimal
- Precision
- String
- Geoshape
- Date
- Instant

*将来会支持额外的数据类型。*

## 19.6. Geoshape Data Type (Geoshape 类型)

Geoshape数据类型支持代表一个点,一个环或box(一维、二维、三维？？？)。然而所有索引后端目前只支持索引点。地理空间索引查找仅支持通过混合索引。

构建一个Geoshape，使用以下方法:
```shell
//lat, lng
Geoshape.point(37.97, 23.72)
//lat, lng, radius in km
Geoshape.circle(37.97, 23.72, 50)
//SW lat, SW lng, NE lat, NE lng
Geoshape.box(37.97, 23.72, 38.97, 24.72)
```

此外当导入图通过GraphSON point 可以表示为:

```shell
/string
"37.97, 23.72"
//list
[37.97, 23.72]
//GeoJSON feature
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [125.6, 10.1]
  },
  "properties": {
    "name": "Dinagat Islands"
  }
}
//GeoJSON geometry
{
  "type": "Point",
  "coordinates": [125.6, 10.1]
}
```
GeoJSON可能指定为点,圆形或多边形。然而多边形必须形成一个box。注意,与Titan API不同GeoJSON指定坐标作为lng lat（经度、维度）。

## 19.7. Collections (集合)

如果使用的是Elasticsearch,你可以索引属性通过SET和LIST Cardinality(基数)。例如:

```shell
mgmt = graph.openManagement()
nameProperty = mgmt.makePropertyKey("names").dataType(String.class).cardinality(Cardinality.SET).make()
mgmt.buildIndex("search", Vertex.class).addKey(nameProperty, Mapping.STRING.asParameter()).buildMixedIndex("search")
mgmt.commit()
//Insert a vertex
person = graph.addVertex()
person.property("names", "Robert")
person.property("names", "Bob")
graph.tx().commit()
//Now query it
g.V().has("names", "Bob").count().next() //1
g.V().has("names", "Robert").count().next() //1
```

[原文](http://s3.thinkaurelius.com/docs/titan/1.0.0/search-predicates.html)
