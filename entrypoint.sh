#!/bin/bash

echo "Loading Logstash..."

echo "Running logstash...."

/app/wait-for-it.sh elasticsearch:9200 -t 0

curl -X PUT "http://elasticsearch:9200/_template/nominatim_template" -H 'Content-Type: application/json' -d @template.json

logstash -f logstash.conf

exec "$@"