#!/bin/bash

FLAG_FILE="/app/logstash_started.flag"

# Check if Logstash has already been started
if [ ! -f "$FLAG_FILE" ]; then
    echo "Loading Logstash..."
    
    touch "$FLAG_FILE"

    echo "Running Logstash...."

    /app/wait-for-it.sh nominatim:8080 -t 0

    curl -X PUT "http://elasticsearch:9200/_template/nominatim_template" -H 'Content-Type: application/json' -d @template.json

    logstash -f logstash.conf
else
    echo "Logstash has already been started. Skipping..."
fi

exec "$@"
