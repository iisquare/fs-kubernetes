FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.3

COPY analysis-ik-online-0.0.1.zip .
RUN unzip analysis-ik-online-0.0.1.zip -d /usr/share/elasticsearch/plugins/analysis-ik-online/
RUN rm analysis-ik-online-0.0.1.zip

EXPOSE 9200 9300
