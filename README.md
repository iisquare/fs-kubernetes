# Kubernetes
kubernetes cluster service

### 常用命令
- 通过清单创建和删除
```
kubectl create -f /path/to/template.yaml
kubectl delete -f /path/to/template.yaml
```
- Pod
```
kubectl get pods -n namespace -o wide
kubectl delete pods PODNAME -n namespace
kubectl describe pods PODNAME -n namespace
kubectl logs PODNAME -n namespace
docker exec -it {container-id} /bin/bash
```
- Ingress
```
kubectl get ingress --all-namespaces
```
- Resource
```
kubectl api-resources
kubectl api-resources --namespaced=true
```

### Habor管理
- 上传镜像
```
# 拉取镜像
docker pull k8s.gcr.io/kubernetes-zookeeper:1.0-3.4.10
# 生成标签
docker tag anjia0532/google-containers.kubernetes-zookeeper:1.0-3.4.10 harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
# 登录仓库
docker login --username=admin harbor.iisquare.com
# 推送镜像
docker push harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
```

### 参考链接
- [gcr.io_mirror](https://github.com/anjia0532/gcr.io_mirror)
