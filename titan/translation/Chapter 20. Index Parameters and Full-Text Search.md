# Table of Contents (目录)

- 20.1. Full-Text Search
- 20.1.1. Full-Text Search
- 20.1.2. String Search
- 20.1.3. Full text and string search
- 20.2. Field Mapping
- 20.2.1. Individual Field Mapping
- 20.2.2. Global Field Mapping

当定义一个混合索引，可以为每一个索引的属性键指定一个参数列表。
这些参数控制这些特定的键是如何被索引的。Titan能识别以下的索引参数。
是否支持这些参数取决于配置的索引后端。除了这里所列，特定的索引后端
可能还支持自定义参数。

## 20.1. Full-Text Search (全文搜索)

当索引字符串值，而属性键是String.class类型，一是选择当作文本来索引，或者当成由参数类型映射控制的character strings（字符序列）

当被当作文本来索引时，字符串被tokenized（分词）为很多单词，允许用户高效的查询匹配包含一个或多个单词。
这被称为全文搜索。当被当作character strings（字符序列）来索引时,字符串索引“原样”,没有
任何进一步的分析或标记。这有助于查询寻找一个精确的匹配字符序列。这是通常被称为字符串搜索。

### 20.1.1. Full-Text Search (全文搜索)

默认情况下,字符串被当成文本来索引。也可以显式指定。
```shell
mgmt = graph.openManagement()
summary = mgmt.makePropertyKey('booksummary').dataType(String.class).make()
mgmt.buildIndex('booksBySummary', Vertex.class).addKey(summary, Mapping.TEXT.asParameter()).buildMixedIndex("search")
mgmt.commit()
```
这是相同的，一个标准的混合索引通过唯一的一个额外的参数（在索引中指定了映射，在这个例子中是Mapping.TEXT）来定义。

这是相同的和唯一标准的混合索引定义添加一个额外的参数,指明该指数的映射——在这种情况下Mapping.TEXT。

当一个字符属性被当成文本索引，,字符串值tokenized（分词）成一些tokens。具体的分词方式取决于
索引后端及其配置。Titan默认分词方法是分割于non-alphanumeric characters（非字母数字的字符
），并且移除少于两个characters（字符）的token。索引后端采用的分词方法可能不同，
which can lead to minor differences in how full-text search queries are handled
 for modifications inside a transaction and committed data in the indexing backend.（这后半句什么意思？？！！）

当一个字符属性被当成文本索引，在图查询的索引后端仅支持全文搜索谓词。全文搜索是不区分大小写的。
- textContains: true  文本字符串中至少包含一个单词与查询字符串匹配
- textContainsPrefix: true 文本字符串中至少包含一个单词是beginWith(查询字符串)
- textContainsRegex: true 文本字符串中至少包含一个单词是匹配给定的正则表达式

字符搜索串谓词(见下文)可以在查询中使用,但这些需要过滤在内存中，开销很大。

### 20.1.2. String Search (字符搜索)

如果使用的是ElasticSearch，索引属性可以使用文本和字符串的所有谓词来精确和模糊匹配。

```shell
mgmt = graph.openManagement()
summary = mgmt.makePropertyKey('booksummary').dataType(String.class).make()
mgmt.buildIndex('booksBySummary', Vertex.class).addKey(summary, Mapping.TEXTSTRING.asParameter()).buildMixedIndex("search")
mgmt.commit()
```

注意,数据将被存储在索引两次,一次精确匹配、一次模糊匹配。

## 20.2. Field Mapping (字段映射)

### 20.2.1. Individual Field Mapping (特定字段映射)

默认情况下,在混合索引下，Titan 将加密属性键为属性键生成唯一字段的名称。如果想在外部索引
后端直接查询混合索引是非常难的。这个用例,字段名称可以通过显式地指定一个参数。

查询混合索引直接在外部索引后端很难处理和模糊不清,难以辨认。这个用例,字段名称可以通过一个
参数显式地指定。

```shell
mgmt = graph.openManagement()
name = mgmt.makePropertyKey('bookname').dataType(String.class).make()
mgmt.buildIndex('booksBySummary', Vertex.class).addKey(name, Parameter.of('mapped-name', 'bookname')).buildMixedIndex("search")
mgmt.commit()
```
由于这个字段映射定义为一个参数，在 booksBySummary索引中 Titan将使用相同的名称来表示这个字段
使用这个字段映射定义为一个参数,泰坦将使用相同的名称字段中创建外部booksBySummary指数指标体系的关键属性。注意,必须保证给定的字段名称索引中是独一无二的。

### 20.2.2. Global Field Mapping
