
# Create topic
sudo docker exec -e KAFKA_OPTS="" -it <container-name> /opt/kafka/bin/kafka-topics.sh \
  --create \
  --topic my-topic-1 \
  --bootstrap-server kafka:9092 \
  --partitions 1 \
  --replication-factor 1


# List topics
sudo docker exec -e KAFKA_OPTS="" -it <container-name> /opt/kafka/bin/kafka-topics.sh \
  --list \
  --bootstrap-server kafka:9092


# Describe a topic
sudo docker exec -e KAFKA_OPTS="" -it <container-name> /opt/kafka/bin/kafka-topics.sh \
  --describe \
  --topic my-topic-1 \
  --bootstrap-server kafka:9092