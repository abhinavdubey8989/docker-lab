# Containerized setup : Apache-kafka, with Kafka-exporter for monitoring & schema-registry


## Aim
- Run Apache-Kafka using Docker Compose along with schema registry
- Use Kafka exporter for kafka-cluster monitoring
- The grafana dashboard JSON can be found at : `grafana/dashboards/kafka-exporter-v1.json`
- Kafka CLI commands can be found at : `flink/README.md`


## Docker image(s) reference
- [apache/kafka](https://hub.docker.com/r/apache/kafka)
- [schema registry](https://hub.docker.com/r/confluentinc/cp-schema-registry)
- [Kafka exporter](https://github.com/danielqsj/kafka_exporter)


## Schema-registry cURLs

- List all subjects
```
curl -X GET http://localhost:8081/subjects
```


- Get all versions of a subject
```
curl -X GET http://localhost:8081/subjects/<subject-name>/versions
```


- Get latest schema for a subject
```
curl -X GET http://localhost:8081/subjects/<subject-name>/versions/latest

# Get by version
curl -X GET http://localhost:8081/subjects/<subject-name>/versions/
```


- Check compatibility of a schema
```
curl -X POST http://localhost:8081/compatibility/subjects/<subject-name>/versions/latest \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"int\"}]}"
  }'
```


- Register new schema
```
curl -X POST http://localhost:8081/subjects/user-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"int\"},{\"name\":\"name\",\"type\":\"string\"}]}"
  }'
```
