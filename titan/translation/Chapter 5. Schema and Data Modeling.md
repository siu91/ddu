# Table of Contents

- 5.1. Defining Edge Labels
 - 5.1.1. Edge Label Multiplicity
- 5.2. Defining Property Keys
 - 5.2.1. Property Key Data Type
 - 5.2.2. Property Key Cardinality
- 5.3. Relation Types
- 5.4. Defining Vertex Labels
- 5.5. Automatic Schema Maker
- 5.6. Changing Schema Elements

每一个Titan graph都有一个由edge label、property key、verter label组成的schema。
Titan schema可以被显式或隐式定义。鼓励用户在应用程序开发过程中显式定义graph schema。
一个明确定义的schema是一个强大的graph应用程序的重要组成部分，大大提高了协同软件开发。
值得注意的是，Titan schema 可以随时间而演化而不中断正常的数据库操作。扩展schema不减慢查询响应，不需要数据库停机。


schema类型-即edge label, property key, 或 vertex label-



被分配给元素的图形-即边缘，属性或顶点-当他们第一次创建。指定的模式类型不能更改为特定元素。这确保了一个稳定的类型系统，这是很容易的原因。
除了在本节中解释的架构定义选项外，架构类型提供在第25章中讨论的性能调整选项，高级模式。
