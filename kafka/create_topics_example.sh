./kafka-topics.sh --create --topic myTopic1 --partitions=12 --replication-factor 2 --zookeeper zookeeper1:2181
./kafka-topics.sh --describe --zookeeper zookeeper1:2181
