# Containerized setup : Apache-Flink

## Aim
Run Apache Flink locally using Docker Compose in session-mode with job-manager, task-manager setup, persistent checkpoints, Prometheus metrics, and external job JAR deployment support.


## Tech Stack
| Technology | Version |
|---|---|
| Apache Flink | 2.2 |
| Java | 21 |


## Directory Structure
```text
.
├── _volume
├── config
├── job-jars
└── docker-compose.yml
```

- `config` dir is to provide configs from host machine (eg: job-manager, task-manager flink-config etc)
- `job-jars` for user application JAR. Added as bind-mount to the containers


## UI links (if applicable)
- [Flink UI](http://localhost:8081/#/overview)


## Docker image(s) reference
- [apache/flink](https://hub.docker.com/r/apache/flink)


## Other References
- [Flink docker documentation](https://nightlies.apache.org/flink/flink-docs-stable/docs/deployment/resource-providers/standalone/docker/)


## Useful Commands

- Starting/stopping the setup
```
# cd into scripts dir & run below to start & stop respectively
./start_stop.sh <current-dir-name> 1
./start_stop.sh <current-dir-name> 0
```



- Submit the external job JAR
```
```