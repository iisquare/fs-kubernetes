# elasticsearch

### 运行方式
- 通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 宿主机环境
```
sysctl -a|grep vm.max_map_count # 查看当前配置
sysctl -w vm.max_map_count=262144 # 临时修改
echo "vm.max_map_count=262144" >> /etc/sysctl.conf # 持久化修改
sysctl -p # 重新加载文件，立即生效
```
- 清理
```
kubectl delete -f elasticsearch.yaml
kubectl delete configmaps elasticsearch -n app-svr
rm -rf /data/k8s-pv/elasticsearch
```
- 创建命名空间
```
kubectl create ns app-svr
```
- 导入配置文件
```
kubectl create configmap elasticsearch --from-file=elasticsearch.yml --from-file=jvm.options --from-file=log4j2.properties -n app-svr
```
- 应用配置清单
```
kubectl create -f elasticsearch.yaml
```
- 修改目录权限
```
chmod -R 777 /data/k8s-pv/elasticsearch/
```

### 参考链接
- [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/docker.html)
