# dashboard

### 安装说明
- 下载并安装
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
```
- 配置Ingress
```
kubectl create -f ingress.yaml
```
- 配置管理账号
```
kubectl create -f admin.yaml
```
- 查看状态
```
kubectl get all -n kubernetes-dashboard 
```
- 查看令牌
```
kubectl get secrets --all-namespaces
kubectl describe secrets -n kubernetes-dashboard dashboard-admin
```


### 参考
- [400 Error with nginx-ingress to Kubernetes Dashboard](https://serverfault.com/questions/1031810/400-error-with-nginx-ingress-to-kubernetes-dashboard)
- [Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://www.kubernetes.org.cn/6632.html)
