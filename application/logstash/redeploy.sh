#!/bin/bash

kubectl delete -f logstash.yaml
kubectl delete configmaps logstash-config -n log-app
kubectl delete configmaps logstash-pipeline -n log-app

kubectl create configmap logstash-config --from-file=config -n log-app
kubectl create configmap logstash-pipeline --from-file=pipeline -n log-app

kubectl create -f logstash.yaml
