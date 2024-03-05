#!/bin/bash

echo "Loading Logstash..."

echo "Running logstash...."

logstash -f logstash.conf

exec "$@"