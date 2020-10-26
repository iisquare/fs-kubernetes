# kibana

### 如何使用
- 导入配置文件
```
kubectl create configmap kibana --from-file=kibana.yml --from-file=node.options -n svr-app
```
- 应用配置清单
```
kubectl create -f kibana.yaml
```

### 参考链接
- [Install Kibana with Docker](https://www.elastic.co/guide/en/kibana/7.9/docker.html)
