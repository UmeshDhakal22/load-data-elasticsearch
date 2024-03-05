FROM logstash:8.12.1

LABEL maintainer="dhakalumesh22@gmail.com"

WORKDIR /app

COPY logstash.conf /usr/share/logstash/logstash.conf
COPY logstash.conf /app/logstash.conf
COPY postgresql.jar /app/postgresql.jar

COPY --chown=1001 entrypoint.sh .
COPY --chown=1001 wait-for-it.sh .

CMD ["bash", "-c", "/app/wait-for-it.sh nominatim:5432 -t 0 -- /app/entrypoint.sh"]