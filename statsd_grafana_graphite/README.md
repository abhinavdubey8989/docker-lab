

# Overview
- This directory is for running a monitoring setup
- This setup includes : `statsd`, `graphite`, `grafana`

# Conventions
- As a convention, the `_volume` dir is used to store any data produced by the container
    - This data can be later used to inspect or observer any behaviour

- If any data is to be supplied from the host to docker, it is done via dedicated
    - Eg: statsd config is supplied from Host machine
    - This config is present in `./statsd/config.js` & supplied in the volumn of statsd service