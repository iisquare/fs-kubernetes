# harbor
仓库文件目前保存在NFS中，若熟悉Ceph运维，可迁移到更合适的方案上。

### 安装说明
- 下载并解压[harbor-offline-installer-v2.1.1.tgz](https://github.com/goharbor/harbor/releases/tag/v2.1.1)
- 导入镜像
```
docker load -i ./harbor.v2.1.1.tar.gz
```
- 通过helm安装
```
helm repo add harbor https://helm.goharbor.io
# Version:1.5.1, App Version:2.1.1
helm install svr-harbor harbor/harbor \
  --version 1.5.1 \
  --create-namespace \
  --namespace lvs-app \
  --set expose.type=ingress \
  --set expose.tls.enabled=true \
  --set expose.tls.certSource=none \
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
  --set externalURL=https://harbor.iisquare.com \
  --set harborAdminPassword=admin888 \
```
- 卸载
```
helm uninstall svr-harbor -n lvs-app
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
- 资源清单imagePullSecrets
```
kubectl create secret docker-registry regcred \
  --docker-server=harbor.iisquare.com \
  --docker-username=admin \
  --docker-password=admin888 \
  --docker-email=
```

### 参考
- [Installation & Configuration Guide](https://goharbor.io/docs/2.1.1/install-config/)
- [harbor-helm](https://github.com/goharbor/harbor-helm)
- [expose.tls.secretName try to volume mount to core pod](https://github.com/goharbor/harbor-helm/issues/261)
- [从私有仓库拉取镜像](https://kubernetes.io/zh/docs/tasks/configure-pod-container/pull-image-private-registry/)
