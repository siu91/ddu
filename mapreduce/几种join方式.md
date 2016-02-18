## 概述
在传统数据库（如：MYSQL）中，JOIN操作是非常常见且非常耗时的。而在HADOOP中进行JOIN操作，同样常见且耗时，由于Hadoop的独特设计思想，当进行JOIN操作时，有一些特殊的技巧。
本文首先介绍了Hadoop上通常的JOIN实现方法，然后给出了几种针对不同输入数据集的优化方法。
## 常见的join方法介绍
假设要进行join的数据分别来自File1和File2.
### reduce side join
reduce side join是一种最简单的join方式，其主要思想如下：
在map阶段，map函数同时读取两个文件File1和File2，为了区分两种来源的key/value数据对，对每条数据打一个标签（tag）,比如：tag=0表示来自文件File1，tag=2表示来自文件File2。即：map阶段的主要任务是对不同文件中的数据打标签。
在reduce阶段，reduce函数获取key相同的来自File1和File2文件的value list， 然后对于同一个key，对File1和File2中的数据进行join（笛卡尔乘积）。即：reduce阶段进行实际的连接操作。
REF：hadoop join之reduce side join
http://blog.csdn.net/huashetianzu/article/details/7819244
### map side join
之所以存在reduce side join，是因为在map阶段不能获取所有需要的join字段，即：同一个key对应的字段可能位于不同map中。Reduce side join是非常低效的，因为shuffle阶段要进行大量的数据传输。
Map side join是针对以下场景进行的优化：两个待连接表中，有一个表非常大，而另一个表非常小，以至于小表可以直接存放到内存中。这样，我们可以将小表复制多份，让每个map task内存中存在一份（比如存放到hash table中），然后只扫描大表：对于大表中的每一条记录key/value，在hash table中查找是否有相同的key的记录，如果有，则连接后输出即可。
为了支持文件的复制，Hadoop提供了一个类DistributedCache，使用该类的方法如下：
（1）用户使用静态方法DistributedCache.addCacheFile()指定要复制的文件，它的参数是文件的URI（如果是HDFS上的文件，可以这样：hdfs://namenode:9000/home/XXX/file，其中9000是自己配置的NameNode端口号）。JobTracker在作业启动之前会获取这个URI列表，并将相应的文件拷贝到各个TaskTracker的本地磁盘上。（2）用户使用DistributedCache.getLocalCacheFiles()方法获取文件目录，并使用标准的文件读写API读取相应的文件。
REF：hadoop join之map side join
http://blog.csdn.net/huashetianzu/article/details/7821674
### Semi Join
Semi Join，也叫半连接，是从分布式数据库中借鉴过来的方法。它的产生动机是：对于reduce side join，跨机器的数据传输量非常大，这成了join操作的一个瓶颈，如果能够在map端过滤掉不会参加join操作的数据，则可以大大节省网络IO。
实现方法很简单：选取一个小表，假设是File1，将其参与join的key抽取出来，保存到文件File3中，File3文件一般很小，可以放到内存中。在map阶段，使用DistributedCache将File3复制到各个TaskTracker上，然后将File2中不在File3中的key对应的记录过滤掉，剩下的reduce阶段的工作与reduce side join相同。
更多关于半连接的介绍，可参考：半连接介绍：http://wenku.baidu.com/view/ae7442db7f1922791688e877.html
REF：hadoop join之semi join
http://blog.csdn.net/huashetianzu/article/details/7823326
### reduce side join + BloomFilter
在某些情况下，SemiJoin抽取出来的小表的key集合在内存中仍然存放不下，这时候可以使用BloomFiler以节省空间。
BloomFilter最常见的作用是：判断某个元素是否在一个集合里面。它最重要的两个方法是：add() 和contains()。最大的特点是不会存在 false negative，即：如果contains()返回false，则该元素一定不在集合中，但会存在一定的 false positive，即：如果contains()返回true，则该元素一定可能在集合中。
因而可将小表中的key保存到BloomFilter中，在map阶段过滤大表，可能有一些不在小表中的记录没有过滤掉（但是在小表中的记录一定不会过滤掉），这没关系，只不过增加了少量的网络IO而已。
更多关于BloomFilter的介绍，可参考：http://blog.csdn.net/jiaomeng/article/details/1495500
## 二次排序
在Hadoop中，默认情况下是按照key进行排序，如果要按照value进行排序怎么办？即：对于同一个key，reduce函数接收到的value list是按照value排序的。这种应用需求在join操作中很常见，比如，希望相同的key中，小表对应的value排在前面。
有两种方法进行二次排序，分别为：buffer and in memory sort和 value-to-key conversion。
对于buffer and in memory sort，主要思想是：在reduce()函数中，将某个key对应的所有value保存下来，然后进行排序。 这种方法最大的缺点是：可能会造成out of memory。
对于value-to-key conversion，主要思想是：将key和部分value拼接成一个组合key（实现WritableComparable接口或者调用setSortComparatorClass函数），这样reduce获取的结果便是先按key排序，后按value排序的结果，需要注意的是，用户需要自己实现Paritioner，以便只按照key进行数据划分。Hadoop显式的支持二次排序，在Configuration类中有个setGroupingComparatorClass()方法，可用于设置排序group的key值，具体参考：http://www.cnblogs.com/xuxm2007/archive/2011/09/03/2165805.html
## 后记
最近一直在找工作，由于简历上写了熟悉Hadoop，所以几乎每个面试官都会问一些Hadoop相关的东西，而 Hadoop上Join的实现就成了一道必问的问题，而极个别公司还会涉及到DistributedCache原理以及怎样利用DistributedCache进行Join操作。为了更好地应对这些面试官，特整理此文章。

5. 参考资料
（1） 书籍《Data-Intensive Text Processing with MapReduce》 page 60~67 Jimmy Lin and Chris Dyer，University of Maryland, College Park
（2） 书籍《Hadoop In Action》page 107~131
（3） mapreduce的二次排序 SecondarySort：http://www.cnblogs.com/xuxm2007/archive/2011/09/03/2165805.html
（4） 半连接介绍：http://wenku.baidu.com/view/ae7442db7f1922791688e877.html
（5） BloomFilter介绍：http://blog.csdn.net/jiaomeng/article/details/1495500
（6）本文来自：http://dongxicheng.org/mapreduce/hadoop-join-two-tables/
————————————————————————————————————————————————
看完了上面的 hadoop 中 MR 常规 join 思路，下面我们来看一种比较极端的例子，大表 join 小表，而小表的大小在 5M 以下的情况：
之所以我这里说小表要限制 5M 以下，是因为我这里用到的思路是 ：
file-》jar-》main String configuration -》configuration map HashMap
步骤：
1、从jar里面读取的文件内容以String的形式存在main方法的 configuration context 全局环境变量里
2、在map函数里读取 context 环境变量的字符串，然后split字符串组建小表成为一个HashMap
     这样一个大表关联小表的例子就ok了，由于context是放在namenode上的，而namenode对内存是有限制的，
所以你的小表文件不要太大，这样我们可以比较的方便的利用 context 做join了。
这种方式其实就是 2.2 map side join 的一种具体实现而已。
Talk is cheap, show you the code~
```java
publicclassTest {

    publicstaticclassMapperClass extends
            Mapper<LongWritable, Text, Text, Text> {

        Configuration config = null;
        HashSet<String> idSet = newHashSet<String>();
        HashMap<String, String> cityIdNameMap = newHashMap<String, String>();
        Map<String, String> houseTypeMap = newHashMap<String, String>();

        publicvoidsetup(Context context) {
            config = context.getConfiguration();
            if(config == null)
                return;
            String idStr = config.get("idStr");
            String[] idArr = idStr.split(",");
            for(String id : idArr) {
                idSet.add(id);
            }

            String cityIdNameStr = config.get("cityIdNameStr");
            String[] cityIdNameArr = cityIdNameStr.split(",");
            for(String cityIdName : cityIdNameArr) {
                cityIdNameMap.put(cityIdName.split("\t")[0],
                        cityIdName.split("\t")[1]);
            }

            houseTypeMap.put("8", "Test");

        }

        publicvoidmap(LongWritable key, Text value, Context context)
                throwsIOException, InterruptedException {

            String[] info = value.toString().split("\\|");
            String insertDate = info[InfoField.InsertDate].split(" ")[0]
                    .split("-")[0]; // date: 2012-10-01
            insertDate = insertDate
                    + info[InfoField.InsertDate].split(" ")[0].split("-")[1]; // date:201210

            String userID = info[InfoField.UserID]; // userid
            if(!idSet.contains(userID)) {
                return;
            }

            String disLocalID = "";
            String[] disLocalIDArr = info[InfoField.DisLocalID].split(",");
            if(disLocalIDArr.length >= 2) {
                disLocalID = disLocalIDArr[1];
            } else{
                try{
                    disLocalID = disLocalIDArr[0];
                } catch(Exception e) {
                    e.printStackTrace();
                    return;
                }
            }
            String localValue = cityIdNameMap.get(disLocalID);
            disLocalID = localValue == null? disLocalID : localValue; // city

            String[] cateIdArr = info[InfoField.CateID].split(",");
            String cateId = "";
            String secondType = "";
            if(cateIdArr.length >= 3) {
                cateId = cateIdArr[2];
                if(houseTypeMap.get(cateId) != null) {
                    secondType = houseTypeMap.get(cateId); // secondType
                } else{
                    return;
                }
            } else{
                return;
            }

            String upType = info[InfoField.UpType];
            String outKey = insertDate + "_"+ userID + "_"+ disLocalID + "_"
                    + secondType;
            String outValue = upType.equals("0") ? "1_1": "1_0";
            context.write(newText(outKey), newText(outValue));
        }
    }

    publicstaticclassReducerClass extends
            Reducer<Text, Text, NullWritable, Text> {

        publicvoidreduce(Text key, Iterable<Text> values, Context context)
                throwsIOException, InterruptedException {
            intpv = 0;
            intuv = 0;

            for(Text val : values) {
                String[] tmpArr = val.toString().split("_");
                pv += Integer.parseInt(tmpArr[0]);
                uv += Integer.parseInt(tmpArr[1]);
            }

            String outValue = key + "_"+ pv + "_"+ uv;
            context.write(NullWritable.get(), newText(outValue));

        }
    }

    publicString getResource(String fileFullName) throwsIOException {
        // 返回读取指定资源的输入流
        InputStream is = this.getClass().getResourceAsStream(fileFullName);
        BufferedReader br = newBufferedReader(newInputStreamReader(is));
        String s = "";
        String res = "";
        while((s = br.readLine()) != null)
            res = res.equals("") ? s : res + ","+ s;
        returnres;
    }

    publicstaticvoidmain(String[] args) throwsIOException,
            InterruptedException, ClassNotFoundException {
        Configuration conf = newConfiguration();
        String[] otherArgs = newGenericOptionsParser(conf, args)
                .getRemainingArgs();
        if(otherArgs.length != 2) {
            System.exit(2);
        }

        String idStr = newTest().getResource("userIDList.txt");
        String cityIdNameStr = newTest().getResource("cityIdName.txt");
        conf.set("idStr", idStr);
        conf.set("cityIdNameStr", cityIdNameStr);
        Job job = newJob(conf, "test01");
        // job.setInputFormatClass(TextInputFormat.class);
        job.setJarByClass(Test.class);
        job.setMapperClass(Test.MapperClass.class);
        job.setReducerClass(Test.ReducerClass.class);
        job.setNumReduceTasks(25);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, newPath(otherArgs[0]));
        org.apache.hadoop.mapreduce.lib.output.FileOutputFormat.setOutputPath(
                job, newPath(otherArgs[1]));

        System.exit(job.waitForCompletion(true) ? 0: 1);
    }
}
```
说明：
1、getResource() 方法指定了可以从jar包中读取配置文件，并拼接成一个String返回。
2、setup() 方法起到一个mapreduce前的初始化的工作，他的作用是从 context 中
获取main中存入的配置文件字符串，并用来构建一个hashmap，放在map外面，
每个node上MR前只被执行一次。
3、注意上面代码的第 125、126 行，conf.set(key, value) 中的 value 大小是由限制的，
在 0.20.x 版本中是 5M 的大小限制，如果大于此大小建议采用分布式缓存读文件的策略。
参考：解决 hadoop jobconf 限制为5M的问题
http://my.oschina.net/132722/blog/174601
推荐阅读：
使用HBase的MAP侧联接

 http://blog.sina.com.cn/s/blog_ae33b83901016lkq.html

PS：关于如何从jar包中读取配置文件，请参考：
（1）深入jar包：从jar包中读取资源文件      
     http://www.iteye.com/topic/483115
（2）读取jar内资源文件     
     http://heipark.iteye.com/blog/1439114
（3）Java相对路径读取资源文件    
         http://lavasoft.blog.51cto.com/62575/265821/
（4）Java加载资源文件时的路径问题   
         http://www.cnblogs.com/lmtoo/archive/2012/10/18/2729272.html
         如何优雅读取properties文件
         http://blogread.cn/it/article/3262?f=wb
注意：
不能先 getResource()  获取路径然后读取内容，
因为".../ResourceJar.jar!/resource/...."并不是文件资源定位符的格式。
所以，如果jar包中的类源代码用File f=new File(相对路径);的形式，是不可能定位到文件资源的。
这也是为什么源代码打包成jar文件后，调用jar包时会报出FileNotFoundException的症结所在了。
但可以通过Class类的getResourceAsStream()方法来直接获取文件内容 ，
这种方法是如何读取jar中的资源文件的，这一点对于我们来说是透明的。
而且 getResource() 和 getResourceAsStream() 在 maven 项目下对于相对、绝对路径的寻找规则貌似还不一样：
System.out.println(QQWryFile.class.getResource("/qqwry.dat").getFile());
System.out.println(QQWryFile.class.getClassLoader().getResourceAsStream("/qqwry.dat"));
System.out.println(QQWryFile.class.getClassLoader().getResourceAsStream("qqwry.dat"));

System.out.println(QQWryFile.class.getResourceAsStream("/qqwry.dat"));
System.out.println(QQWryFile.class.getResourceAsStream("qqwry.dat"));
TIPS：Class和ClassLoader的getResourceAsStream()方法的区别：
这两个方法还是略有区别的， 以前一直不加以区分，直到今天发现要写这样的代码的时候运行
错误， 才把这个问题澄清了一下。

基本上，两个都可以用于从 classpath 里面进行资源读取，  classpath包含classpath中的路径
和classpath中的jar。

两个方法的区别是资源的定义不同， 一个主要用于相对与一个object取资源，而另一个用于取相对于classpath的
资源，用的是绝对路径。

在使用Class.getResourceAsStream 时， 资源路径有两种方式， 一种以 / 开头，则这样的路径是指定绝对
路径， 如果不以 / 开头， 则路径是相对与这个class所在的包的。

在使用ClassLoader.getResourceAsStream时， 路径直接使用相对于classpath的绝对路径。

举例，下面的三个语句，实际结果是一样的：
```java
   com.explorers.Test.class.getResourceAsStream("abc.jpg")
= com.explorers.Test.class.getResourceAsStream("/com/explorers/abc.jpg")
= ClassLoader.getResourceAsStream("com/explorers/abc.jpg")
```
http://macrochen.iteye.com/blog/293918
http://blogread.cn/it/article/3262?f=wb
