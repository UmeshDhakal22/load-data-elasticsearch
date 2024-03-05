FROM logstash:8.12.1

LABEL maintainer="dhakalumesh22@gmail.com"

WORKDIR /app

COPY logstash.conf /app/logstash.conf
COPY postgresql.jar /app/postgresql.jar



CMD ["bash", "-c", "sleep 6000" ]