# Containerized setup : Apache-Flink

## Aim
- Run Apache Flink locally using Docker Compose in session-mode with job-manager, task-manager setup, persistent checkpoints, and external job JAR deployment support
- Session Mode is a flink deployment mode where Flink cluster is started once and then multiple independent jobs are submitted to it
- This shared cluster stays running, waiting for new job submissions, even after a particular job has finished


## Tech Stack
| Technology | Version |
|---|---|
| Docker | 29.1.3 or later |
| Docker compose | v2 or later |
| Apache Flink | 2.2.0 |
| Java | 21 |
| Kafka (KRaft) | 4.3.0 |


## Directory Structure
```text
.
├── _volume
├── flink
├── job-jars
├── kafka
└── docker-compose.yml
```

- `flink` dir is to provide flink configs from host machine (needed for : job-manager, task-manager)
- `job-jars` for user application JAR. Added as bind-mount to the containers
- `kafka` dir is to provide kafka enviroment vars, to avoid clutter in the docker-compose file


## UI links (if applicable)
- [Flink UI](http://localhost:8081/#/overview)


## Docker image(s) reference
- [apache/flink](https://hub.docker.com/r/apache/flink)
- [apache/kafka](https://hub.docker.com/r/apache/kafka)


## Other References
- [Flink docker documentation](https://nightlies.apache.org/flink/flink-docs-stable/docs/deployment/resource-providers/standalone/docker/)
- [KRaft](https://kafka.apache.org/41/operations/kraft/)


## Useful Commands

- Starting/stopping the setup
```
# cd into scripts dir & run below to start & stop respectively
./start_stop.sh <current-dir-name> 1
./start_stop.sh <current-dir-name> 0
```


- Submit the external job JAR
```
# Step-1 : Place the Java JAR in job-jars. This can be done either when container are running or not (as its a bind-mount)
           This will result in the same JAR being available inside the job-manager container

# Step-2 : Run the below to submit the JAR to flink cluster
docker exec -it flink-jobmanager flink run /opt/flink/job-jars/your-jar-name.jar

# Expected behaviour is the log : Job has been submitted with JobID <job-id>
```

- Kafka CLI commands
```
# List the topics
docker exec -e KAFKA_OPTS="" -it kafka /opt/kafka/bin/kafka-topics.sh \
    --bootstrap-server kafka:9092 \
    --list


# Create a topic
docker exec -e KAFKA_OPTS="" -it kafka /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server kafka:9092 \
  --create --if-not-exists \
  --topic YOUR_TOPIC_NAME \
  --partitions 1 \
  --replication-factor 1


# Delete a topic
docker exec -e KAFKA_OPTS="" -it kafka /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server kafka:9092 \
  --delete \
  --topic YOUR_TOPIC_NAME


# Describe a topic
docker exec -it kafka /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server kafka:9092 \
  --describe \
  --topic YOUR_TOPIC_NAME



# Start console-producer on a topic
docker exec -e KAFKA_OPTS="" -it kafka /opt/kafka/bin/kafka-console-producer.sh \
  --bootstrap-server kafka:9092 \
  --topic YOUR_TOPIC_NAME



# Start console-consumer on a topic
docker exec -e KAFKA_OPTS="" -it kafka /opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server kafka:9092 \
  --topic YOUR_TOPIC_NAME \
  --group cli-group \
  --from-beginning

```