```bash
[hadoop@hadoop01 demo]$ HADOOP_CONF_DIR=/usr/lib/hadoop/etc/hadoop spark-submit --class gsw.spark.Wordcount --master yarn-cluster --executor-memory 4G ./spark_demo1.jar
15/07/22 09:45:17 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
15/07/22 09:45:17 INFO RMProxy: Connecting to ResourceManager at hadoop04/192.168.1.104:8050
15/07/22 09:45:17 INFO Client: Requesting a new application from cluster with 2 NodeManagers
15/07/22 09:45:17 INFO Client: Verifying our application has not requested more than the maximum memory capability of the cluster (6144 MB per container)
15/07/22 09:45:17 INFO Client: Will allocate AM container, with 896 MB memory including 384 MB overhead
15/07/22 09:45:17 INFO Client: Setting up container launch context for our AM
15/07/22 09:45:17 INFO Client: Preparing resources for our AM container
15/07/22 09:45:18 WARN BlockReaderLocal: The short-circuit local reads feature cannot be used because libhadoop cannot be loaded.
15/07/22 09:45:18 INFO Client: Uploading resource file:/usr/lib/spark-1.4.0-bin-hadoop2.3/lib/spark-assembly-1.4.0-hadoop2.3.0.jar -> hdfs://mycluster/user/hadoop/.sparkStaging/application_1436749426812_0121/spark-assembly-1.4.0-hadoop2.3.0.jar
15/07/22 09:45:32 WARN BlockReaderLocal: The short-circuit local reads feature cannot be used because libhadoop cannot be loaded.
15/07/22 09:45:32 INFO Client: Uploading resource file:/home/hadoop/gsw/spark/app/demo/spark_demo1.jar -> hdfs://mycluster/user/hadoop/.sparkStaging/application_1436749426812_0121/spark_demo1.jar
15/07/22 09:45:32 WARN BlockReaderLocal: The short-circuit local reads feature cannot be used because libhadoop cannot be loaded.
15/07/22 09:45:32 INFO Client: Uploading resource file:/tmp/spark-cf225956-0609-4659-bdd6-06bfc64de8b7/__hadoop_conf__8590924949234930042.zip -> hdfs://mycluster/user/hadoop/.sparkStaging/application_1436749426812_0121/__hadoop_conf__8590924949234930042.zip
15/07/22 09:45:32 WARN BlockReaderLocal: The short-circuit local reads feature cannot be used because libhadoop cannot be loaded.
15/07/22 09:45:32 INFO Client: Setting up the launch environment for our AM container
15/07/22 09:45:32 INFO SecurityManager: Changing view acls to: hadoop
15/07/22 09:45:32 INFO SecurityManager: Changing modify acls to: hadoop
15/07/22 09:45:32 INFO SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(hadoop); users with modify permissions: Set(hadoop)
15/07/22 09:45:32 INFO Client: Submitting application 121 to ResourceManager
15/07/22 09:45:32 INFO YarnClientImpl: Submitted application application_1436749426812_0121
15/07/22 09:45:33 INFO Client: Application report for application_1436749426812_0121 (state: ACCEPTED)
15/07/22 09:45:33 INFO Client:
         client token: N/A
         diagnostics: N/A
         ApplicationMaster host: N/A
         ApplicationMaster RPC port: -1
         queue: root.default
         start time: 1437529532022
         final status: UNDEFINED
         tracking URL: http://hadoop04:8088/proxy/application_1436749426812_0121/
         user: hadoop
15/07/22 09:45:34 INFO Client: Application report for  application_1436749426812_0121 (state: ACCEPTED)
...
15/07/22 09:45:50 INFO Client: Application report for application_1436749426812_0121 (state: RUNNING)
15/07/22 09:45:50 INFO Client:
         client token: N/A
         diagnostics: N/A
         ApplicationMaster host: 192.168.1.104
         ApplicationMaster RPC port: 0
         queue: root.default
         start time: 1437529532022
         final status: UNDEFINED
         tracking URL: http://hadoop04:8088/proxy/application_1436749426812_0121/
         user: hadoop
15/07/22 09:45:51 INFO Client: Application report for
...
application_1436749426812_0121 (state: RUNNING)
15/07/22 09:46:02 INFO Client: Application report for application_1436749426812_0121 (state: FINISHED)
15/07/22 09:46:02 INFO Client:
         client token: N/A
         diagnostics: N/A
         ApplicationMaster host: 192.168.1.104
         ApplicationMaster RPC port: 0
         queue: root.default
         start time: 1437529532022
         final status: SUCCEEDED
         tracking URL: http://hadoop04:8088/proxy/application_1436749426812_0121/A
         user: hadoop
15/07/22 09:46:02 INFO Utils: Shutdown hook called
15/07/22 09:46:02 INFO Utils: Deleting directory /tmp/spark-cf225956-0609-4659-bdd6-06bfc64de8b7
```
