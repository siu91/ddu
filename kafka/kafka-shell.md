## 启动
```bash
bin/kafka-server-start.sh config/server.properties >/dev/null 2>&1 &
```
## 停止
```bash
bin/kafka-server-stop.sh
```
## create topic
```bash
$KAFKA_HOME/kafka-topics.sh --create --zookeeper 192.168.1.55:2181,192.168.1.56:2181,192.168.1.57:2181,192.168.1.58:2181,192.168.1.59:2181,192.168.1.60:2181,192.168.1.61:2181 --replication-factor 3 --partitions 3 --topic MC_DATA
```
## describe topic
```bash
$KAFKA_HOME/kafka-topics.sh --describe --zookeeper --topic MC_DATA
```
## console producer
```bash
$KAFKA_HOME/kafka-console-producer.sh --broker-list 192.168.1.54:9092,192.168.1.55:9092,192.168.1.56:9092,192.168.1.57:9092,192.168.1.58:9092,192.168.1.59:9092,192.168.1.60:9092,192.168.1.61:9092 --topic MC_DATA
```
## console consumer
```bash
$KAFKA_HOME/kafka-console-consumer.sh --zookeeper 192.168.1.55:2181,192.168.1.56:2181,192.168.1.57:2181,192.168.1.58:2181,192.168.1.59:2181,192.168.1.60:2181,192.168.1.61:2181 --from-beginning --topic MC_DATA
```
