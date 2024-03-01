#!/bin/bash

# Usage: ./wait-for-it.sh host:port [-s] [-t timeout] [-- command args]
#   -s: Use strict mode, fail if the host is unreachable instead of waiting for the timeout
#   -t timeout: Timeout in seconds, defaults to 15 seconds

strict_mode=false
timeout=15

while [[ $# -gt 0 ]]
do
    case "$1" in
        -s)
        strict_mode=true
        shift
        ;;
        -t)
        timeout="$2"
        shift 2
        ;;
        --)
        shift
        break
        ;;
        *)
        break
        ;;
    esac
done

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 host:port [-s] [-t timeout] [-- command args]"
    exit 1
fi

hostport=$1
shift

host=$(echo "$hostport" | cut -d: -f1)
port=$(echo "$hostport" | cut -d: -f2)

start_ts=$(date +%s)
while true
do
    (echo > /dev/tcp/$host/$port) >/dev/null 2>&1
    result=$?
    if [[ $result -eq 0 ]]; then
        end_ts=$(date +%s)
        echo "Service is available after $(($end_ts - $start_ts)) seconds"
        break
    fi
    sleep 1
    current_ts=$(date +%s)
    if [[ $(($current_ts - $start_ts)) -gt $timeout ]]; then
        echo "Timeout reached, service $hostport is not available"
        if [[ $strict_mode == true ]]; then
            exit 1
        else
            break
        fi
    fi
done

exec "$@"
