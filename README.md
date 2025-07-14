# Kubernetes
kubernetes cluster service

| 服务 | 入口 | 参数 |
| :----- | :----- | :----- |
| docker | ENTRYPOINT | CMD |
| docker-compose | entrypoint | command |
| kubernetes | command | args |

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
# 多容器POD日志，指定容器名称
kubectl logs PODNAME -n namespace -c CONTAINER_NAME
# 查看重启前的日志，对应POD所在NODE节点/var/log/pods/目录
kubectl logs PODNAME -n namespace --previous
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

### 常见问题
- 排查容器异常
```
# 查看 Events 部分，重点关注：
#    OOMKilled（内存溢出）
#    Liveness/Readiness Probe Failed（健康检查失败）
#    CrashLoopBackOff（容器持续崩溃）
#    ImagePullBackOff（镜像拉取失败）
kubectl describe pod <pod-name> -n <namespace>
# 查看前一次容器日志
kubectl logs <pod-name> -n <namespace> -p
# Kubelet 日志（在节点上执行）
journalctl -u kubelet --since "1 hour ago" | grep <pod-id>
# 容器运行时日志（如 Docker）
journalctl -u docker | grep <container-id>
# 系统内核日志（排查 OOM）
dmesg | grep -i "killed"
vi /var/log/messages
```

### 参考链接
- [gcr.io_mirror](https://github.com/anjia0532/gcr.io_mirror)
- [尚硅谷Kubernetes教程](https://www.bilibili.com/video/BV1w4411y7Go)
- [尚硅谷Kubernetes教程新版](https://www.bilibili.com/video/BV1GT4y1A756)
- [九析带你轻松完爆 istio 系列](https://www.bilibili.com/video/BV1vE411p7wX)
