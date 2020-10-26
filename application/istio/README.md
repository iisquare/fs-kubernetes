# istio

### 组件定位
- 仅用于内部服务治理，不作为暴露内部服务的入口

### 安装说明
- 下载并安装[istio-1.7.3-linux-amd64.tar.gz](https://github.com/istio/istio/releases/tag/1.7.3)
```
tar -xzvf istio-1.7.3-linux-amd64.tar.gz
mv istio-1.7.3 /opt/
echo 'export PATH=/opt/istio-1.7.3/bin:$PATH' >> ~/.bash_profile 
source ~/.bash_profile
```
- 配置
```
istioctl manifest install -f k8s.yaml
kubectl get svc -n istio-system
kubectl get pods -n istio-system
```
- 自动注入
```
kubectl label namespace <namespace> istio-injection=enabled
```
- 手动注入
```
istioctl kube-inject -f <your-app-spec>.yaml | kubectl apply -f -
```
- 卸载
```
istioctl manifest generate -f k8s.yaml | kubectl delete -f -
```

### 服务监控
- 集成prometheus
```
kubectl create -f prometheus.yaml
kubectl create -f /opt/istio-1.7.3/samples/addons/extras/prometheus-operator.yaml
```
- 配置[grafana](https://istio.io/latest/docs/ops/integrations/grafana/)
```
yum install epel-release
yum install jq
sh grafana.sh
```

### 服务治理
- 安装jaeger
```
kubectl create -f pvc-jaeger.yaml
kubectl create -f jaeger.yaml
```
- 安装Kiali
```
kubectl create -f kiali-secret.yaml
kubectl create -f kiali.yaml
# run again to fixed: no matches for kind "MonitoringDashboard" in version "monitoring.kiali.io/v1alpha1"
kubectl apply -f kiali.yaml
```
- 配置ingress
```
kubectl create -f ingress.yaml
```

### [Bookinfo](https://istio.io/latest/zh/docs/examples/bookinfo/)
- 创建命名空间
```
kubectl create ns test-bookinfo
```
- 自动注入
```
kubectl label namespace test-bookinfo istio-injection=enabled
```
- 创建实例
```
kubectl apply -n test-bookinfo -f /opt/istio-1.7.3/samples/bookinfo/platform/kube/bookinfo.yaml
```
- 访问测试
```
kubectl get services -n test-bookinfo
kubectl get pods -n test-bookinfo
kubectl exec -it $(kubectl get pod -n test-bookinfo -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -n test-bookinfo -- curl productpage:9080/productpage | grep -o "<title>.*</title>"
```
- 配置网关
```
kubectl apply -n test-bookinfo -f /opt/istio-1.7.3/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get Gateway -n test-bookinfo
curl -s http://istio.iisquare.com/productpage | grep -o "<title>.*</title>"
```
- 应用规则
```
kubectl apply -n test-bookinfo -f /opt/istio-1.7.3/samples/bookinfo/networking/destination-rule-all.yaml
kubectl get destinationrules -n test-bookinfo -o yaml
```
- 清理
```
sh /opt/istio-1.7.3/samples/bookinfo/platform/kube/cleanup.sh
```

### 参考
- [istio.io/latest/zh](https://istio.io/latest/zh/docs/setup/getting-started/)
- [istio-handbook](https://www.servicemesher.com/istio-handbook/concepts/architecture-overview.html)
