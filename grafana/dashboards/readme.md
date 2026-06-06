# Containerized setup : Grafana


## Aim
- Run Grafana using Docker Compose & visualise various metrics
- Also, save the JSON of dashboards in `dashboards` dir for re-usability


## Save dashboard JSON

### node-exporter-v1.json
- Host machine monitoring (comparative) using node-exporter
- It is subset of standard grafana-dashboard [#1860](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- Before importing in grafana, update the values for : `PUBLIC_IP` & `ip-172-31-22-105`


### kafka-exporter-v1.json
- Monitoring kafka-cluster using kafka-exporter
