# Table of Contents

- 22.1. Elasticsearch Configuration Overview
- 22.2. The interface Configuration Track
 - 22.2.1. Common Options
 - 22.2.2. Transport Client Options
 - 22.2.3. Node Client Options
- 22.3. The Legacy Configuration track
 - 22.3.1. Embedded JVM-local Node Configuration
 - 22.3.2. Transport Client Configuration
 - 22.3.3. Legacy Configuration Options
- 22.4. Secure Elasticsearch
- 22.5. Index Creation Options
 - 22.5.1. Embedding ES index creation settings with create.ext
- 22.6. Troubleshooting
 - 22.6.1. Connection Issues to remote Elasticsearch cluster
 - 22.6.2. Classpath or Field errors
- 22.7. Optimizing Elasticsearch
 - 22.7.1. Write Optimization
 - 22.7.2. Further Reading


 Elasticsearch是一个灵活且强大的开源、分布式、实时搜索和分析引擎。底层架构使用分布式
 环境必须保证可靠性和可伸缩性，架构的使用在分布式环境中可靠性和可伸缩性是必要条件,
 Elasticsearch提供了简便的全文搜索。

Titan 使用Elasticsearch 作为索引后端的支持。这里列出一些Titan提供的Elasticsearch的一些功能特性：

- Full-Text: Supports all Text predicates to search for text properties that matches a given word, prefix or regular expression.
- Geo: Supports the Geo.WITHIN condition to search for points that fall within a given circle. Only supports points for indexing and circles for querying.
- Numeric Range: Supports all numeric comparisons in Compare.
- Flexible Configuration: Supports embedded or remote operation, custom transport and discovery, and open-ended settings customization.
- TTL: Supports automatically expiring indexed elements.
- Collections: Supports indexing SET and LIST cardinality properties.
- Temporal: Nanosecond granularity temporal indexing.
