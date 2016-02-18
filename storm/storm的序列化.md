今天调试代码的时候,`java.io.NotSerializableException`,给相关类加上了序列化接口, 还是抛`java.io.NotSerializableException`, 说另外一个依赖jar中的类需要实现序列化接口,没法修改代码。 在[google group](http://groups.google.com/group/storm-user) 发现类似的问题,storm的作者[Nathan Marz](http://nathanmarz.com)针对这个问题给出了解释:
```text
The lifecycle of a bolt or spout is as follows:

1. Created on client side (from where you submit the topology) and
serialized using Java serialization
2. Serialized component is sent to all the tasks
3. Each task executing that component deserializes the component
4. The task calls "prepare" (for bolts) or "open" (for spouts) on the
component before it starts executing.

So if you need to do something like connect to a database, you should do
that in the "prepare" or "open" method.
```

spout/bolt的生命周期如下:
```text
1.在提交了一个topology之后(是在nimbus所在的机器么?), 创建spout/bolt实例(spout/bolt在storm中统称为component)并进行序列化.
2.将序列化的component发送给所有的任务所在的机器
3.在每一个任务上反序列化component.
4.在开始执行任务之前, 先执行component的初始化方法(bolt是prepare, spout是open).
```

因此component的初始化操作应该在prepare/open方法中进行, 而不是在实例化component的时候进行。
