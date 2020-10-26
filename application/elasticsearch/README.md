# elasticsearch

### 运行方式
- 通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 清理
```
kubectl delete -f elasticsearch.yaml
kubectl delete configmaps elasticsearch -n svr-app
rm -rf /data/k8s-pv/elasticsearch
```
- 创建命名空间
```
kubectl create ns svr-app
```
- 导入配置文件
```
kubectl create configmap elasticsearch --from-file=elasticsearch.yml --from-file=jvm.options --from-file=log4j2.properties -n svr-app
```
- 应用配置清单
```
kubectl create -f elasticsearch.yaml
```

### 参考链接
- [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/docker.html)
