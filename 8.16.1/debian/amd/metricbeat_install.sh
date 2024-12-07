#!/bin/bash

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.16.1-amd64.deb
dpkg -i metricbeat-8.16.1-amd64.deb

metricbeat modules enable mysql
metricbeat modules enable nginx

# set metricbeat.yml
sed -i 's@^  hosts: \["localhost:9200"\]@  hosts: ['"${ELASTICSEARCH_URL}"']@g' /etc/metricbeat/metricbeat.yml
sed -i 's@^  #protocol: "https"@  protocol: "https"\
  ssl.verification_mode: none@g' /etc/metricbeat/metricbeat.yml
sed -i 's@^  #username: "elastic"@  username: "elastic"@g' /etc/metricbeat/metricbeat.yml
sed -i 's@^  #password: "changeme"@  password: '"${ELASTIC_PASSWORD}"'@g' /etc/metricbeat/metricbeat.yml
sed -i 's@^  #host: "localhost:5601"@  host: '"${KIBANA_URL}"'@g' /etc/metricbeat/metricbeat.yml

metricbeat test output
metricbeat setup --dashboards
