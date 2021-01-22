#!/bin/bash

kubectl delete -f logstash.yaml
kubectl delete configmaps logstash-config -n app-log
kubectl delete configmaps logstash-pipeline -n app-log

kubectl create configmap logstash-config --from-file=config -n app-log
kubectl create configmap logstash-pipeline --from-file=pipeline -n app-log

kubectl create -f logstash.yaml
