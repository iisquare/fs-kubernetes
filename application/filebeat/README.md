# filebeat

### 运行方式
- 采用DaemonSet在每台宿主机上运行一个filebeat副本
- 通过挂载宿主机/data/k8s-logs/filebeat/filebeat.yml读取配置

### 如何使用
- 清理
```
kubectl delete -f filebeat.yaml
rm -rf /data/k8s-pv/filebeat
```
- 创建命名空间
```
kubectl create ns log-app
```
- 创建配置文件
```
mkdir -p /data/k8s-pv/filebeat
scp -R filebeat.yml node-ip:/data/k8s-pv/filebeat/filebeat.yml
```
- 应用配置清单
```
kubectl create -f filebeat.yaml
chmod -R 777 /data/k8s-pv/filebeat/data /data/k8s-pv/filebeat/logs
# chmod go-w /data/k8s-pv/filebeat/filebeat.yml
```

### 参考链接
- [Filebeat Reference Directory layout](https://www.elastic.co/guide/en/beats/filebeat/current/directory-layout.html)
