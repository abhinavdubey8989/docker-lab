{
  "port": 8125,
  "flushInterval": 10000,
  "percentThreshold": [90, 95, 99],
  "debug": true,
  "backends": ["./backends/console.js" , "./backends/graphite.js"],
  "console": {
    "prettyprint": true
  },
  "graphiteHost": "host.docker.internal",
  "graphitePort": 2003
}
