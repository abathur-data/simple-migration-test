FROM docker.elastic.co/logstash/logstash:8.19.23
RUN bin/logstash-plugin install logstash-output-opensearch
COPY --chown=logstash:root ojdbc8.jar /usr/share/logstash/vendor/jar/jdbc/ojdbc8.jar
