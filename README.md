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
kubectl explain service --recursive
```
- 节点标签
```
kubectl get node --show-labels=true
kubectl label nodes <node_name> key1=val1 key2=val2 # add
kubectl label nodes <node_name> key1- key2- # delete
```
- 污点和容忍度
```
kubectl get nodes -o json | jq '.items[].spec.taints'
# effect:NoSchedule | PreferNoSchedule | NoExecute
kubectl taint node <node-name> key=value:<effect> # add
kubectl taint node <node-name> key- # delete
kubectl taint node <node-name> key:<effect>- # delete
```
- ConfigMap
```
kubectl create configmap <map-name> --from-file=/path/to/file
kubectl describe configmaps <map-name>
kubectl get configmaps <map-name> -o yaml
```
- 证书管理
```
kubeadm alpha certs check-expiration
```
- 端口转发（临时调试）
```
kubectl port-forward --address 0.0.0.0 -n <namespace> <pod-name> <port>:<port>
```

### 参考链接
- [gcr.io_mirror](https://github.com/anjia0532/gcr.io_mirror)
- [尚硅谷Kubernetes教程](https://www.bilibili.com/video/BV1w4411y7Go)
- [尚硅谷Kubernetes教程新版](https://www.bilibili.com/video/BV1GT4y1A756)
- [九析带你轻松完爆 istio 系列](https://www.bilibili.com/video/BV1vE411p7wX)
