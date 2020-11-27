# logstash

### 运行方式
- Filebeat收集宿主机日志并写入到Kafka中
- Logstash读取Kafka中的日志，格式化并写入到Elasticsearch中
- 消费offset通过kafka的group_id进行记录，不再单独持久化logstash的data文件

### 如何使用
- 清理
```
kubectl delete -f logstash.yaml
kubectl delete configmaps logstash-pipeline -n log-app
rm -rf /data/k8s-pv/logstash
```
- 创建命名空间
```
kubectl create ns log-app
```
- 导入配置文件
```
kubectl create configmap logstash-pipeline --from-file=pipeline -n log-app
```
- 应用配置清单
```
kubectl create -f logstash.yaml
```

### 其他事项
- ingress-nginx-log-format
```
$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" $request_length $request_time [$proxy_upstream_name] [$proxy_alternative_upstream_name] $upstream_addr $upstream_response_length $upstream_response_time $upstream_status $req_id
```

### 模板管理
- 创建模板
```
PUT _index_template/template_xxx
```
- 删除模板
```
DELETE _index_template/template_xxx
```


### 参考链接
- [NGINX Ingress Controller ConfigMaps](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/)
- [Elasticsearch Reference Index templates](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/index-templates.html)
