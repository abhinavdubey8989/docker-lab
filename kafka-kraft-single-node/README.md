# Containerized setup : Apache-kafka, with Kafka-exporter for monitoring & schema-registry


## Aim
- Run Apache-Kafka using Docker Compose along with schema registry
- Use Kafka exporter for kafka-cluster monitoring
- The grafana dashboard JSON can be found at : `grafana/dashboards/kafka-exporter-v1.json`
- Kafka CLI commands can be found at : `flink/README.md`



## Why use Kafka-exporter & kafka-jmx exporter both? The difference
- They solve different layers of the Kafka observability problem


| Feature         | JMX Exporter            | Kafka Exporter      |
| --------------- | ----------------------- | ------------------- |
| Source          | Kafka JVM (broker)      | Kafka APIs          |
| Focus           | Broker health           | Consumer lag        |
| Level           | Infrastructure          | Data flow           |
| Metrics type    | Internal system metrics | Consumption metrics |
| Talks to Kafka? | ❌ No                   | ✅ Yes               |
| Talks to JVM?   | ✅ Yes                  | ❌ No                |

- To get full observability, use both : 
  - Broker health (JMX)
  - Consumer lag (Kafka exporter)

- One is not a substitute/replacement of the other


## Docker image(s) reference
- [apache/kafka](https://hub.docker.com/r/apache/kafka)
- [schema registry](https://hub.docker.com/r/confluentinc/cp-schema-registry)
- [Kafka exporter](https://github.com/danielqsj/kafka_exporter)


## Schema-registry cURLs

- List all subjects
```bash
curl -X GET http://localhost:8081/subjects
```


- Get all versions of a subject
```bash
curl -X GET http://localhost:8081/subjects/<subject-name>/versions
```


- Get latest schema for a subject
```bash
curl -X GET http://localhost:8081/subjects/<subject-name>/versions/latest | jq .

```


- Get latest schema for a subject (in-case you do not want the latest)
```bash
curl -X GET http://localhost:8081/subjects/<subject-name>/versions/:id | jq .

```


- Check compatibility of a schema
```bash
curl -X POST http://localhost:8081/compatibility/subjects/<subject-name>/versions/latest \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"int\"}]}"
  }'
```


- Register new schema
```bash
curl -X POST http://localhost:8081/subjects/user-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"int\"},{\"name\":\"name\",\"type\":\"string\"}]}"
  }'
```
