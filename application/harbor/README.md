# harbor

### 独立安装-非K8S节点
- 下载并解压[harbor-offline-installer-v2.1.0.tgz](https://github.com/goharbor/harbor/releases/tag/v2.1.0)
- 修改配置文件
```
cp harbor.yml.tmpl harbor.yml
vim harbor.yml
hostname: localhost
# 注释掉https相关配置
```
- 执行安装脚本
```
./install.sh
```

### 安装说明
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
helm install svr-harbor harbor/harbor --version 1.5.0 \
  --set expose.type=ingress \
  --set expose.tls.enabled=false \
  --set expose.ingress.hosts.core=harbor.iisquare.com \
  --set expose.ingress.hosts.notary=notary.iisquare.com \
  --set expose.ingress.annotations.'kubernetes\.io/ingress\.class'=nginx-internal \
  --set internalTLS.enabled=false \
  --set persistence.enabled=true \
  --set persistence.persistentVolumeClaim.registry.storageClass=nfs-harbor \
  --set persistence.persistentVolumeClaim.registry.subPath=registry \
  --set persistence.persistentVolumeClaim.registry.size=100Gi \
  --set persistence.persistentVolumeClaim.chartmuseum.storageClass=nfs-harbor \
  --set persistence.persistentVolumeClaim.chartmuseum.subPath=chartmuseum \
  --set persistence.persistentVolumeClaim.jobservice.storageClass=nfs-harbor \
  --set persistence.persistentVolumeClaim.jobservice.subPath=jobservice \
  --set persistence.persistentVolumeClaim.database.storageClass=nfs-harbor \
  --set persistence.persistentVolumeClaim.database.subPath=database \
  --set persistence.persistentVolumeClaim.redis.storageClass=nfs-harbor \
  --set persistence.persistentVolumeClaim.redis.subPath=redis \
  --set externalURL=harbor.iisquare.com \
  --set harborAdminPassword=admin888 \
  --set database.type=external \
  --set database.external.host=192.168.2.78 \
  --set database.external.port=3306 \
  --set database.external.username=harbor \
  --set database.external.password=harbor \
  --set redis.type=external \
  --set redis.external.addr=192.168.2.74:6379,192.168.2.75:6379,192.168.2.76:6379 \
  --set redis.external.sentinelMasterSet= \
```
- 卸载
```
helm uninstall svr-harbor
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
