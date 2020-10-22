# harbor
仓库文件目前保存在NFS中，若熟悉Ceph运维，可迁移到更合适的方案上。

### 安装说明
- 下载并解压[harbor-offline-installer-v2.1.0.tgz](https://github.com/goharbor/harbor/releases/tag/v2.1.0)
- 导入镜像
```
docker load -i ./harbor.v2.1.0.tar.gz
```
- 分配NFS存储
```
kubectl create -f nfs-pv.yaml
kubectl get pv
kubectl edit pv nfs-pv-harbor
```
- 通过helm安装
```
helm repo add harbor https://helm.goharbor.io
# Version:1.5.0, App Version:2.1.0
helm install nfs harbor/harbor \
  --version 1.5.0 \
  --create-namespace \
  --namespace lvs-app \
  --set expose.type=ingress \
  --set expose.tls.enabled=true \
  --set expose.tls.certSource=none \ # use default ingress ssl certificate
  --set expose.ingress.hosts.core=harbor.iisquare.com \
  --set expose.ingress.hosts.notary=notary.iisquare.com \
  --set expose.ingress.annotations.'kubernetes\.io/ingress\.class'=nginx-internal \
  --set internalTLS.enabled=false \
  --set persistence.enabled=true \
  --set persistence.persistentVolumeClaim.registry.storageClass=lvs-nfs-storage \
  --set persistence.persistentVolumeClaim.registry.size=50Gi \
  --set persistence.persistentVolumeClaim.chartmuseum.storageClass=lvs-nfs-storage \
  --set persistence.persistentVolumeClaim.jobservice.storageClass=lvs-nfs-storage \
  --set persistence.persistentVolumeClaim.database.storageClass=lvs-nfs-storage \
  --set persistence.persistentVolumeClaim.redis.storageClass=lvs-nfs-storage \
  --set persistence.persistentVolumeClaim.trivy.storageClass=lvs-nfs-storage \
  --set externalURL=harbor.iisquare.com \
  --set harborAdminPassword=admin888 \
```
- 卸载
```
helm uninstall nfs -n lvs-app
kubectl get pvc -n lvs-app
kubectl delete pvc --all -n lvs-app
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

### 参考
- [Installation & Configuration Guide](https://goharbor.io/docs/2.1.0/install-config/)
- [harbor-helm](https://github.com/goharbor/harbor-helm)
- [expose.tls.secretName try to volume mount to core pod](https://github.com/goharbor/harbor-helm/issues/261)
