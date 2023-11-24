# minio s3 provisioner

### 前置要求
- 创建命名空间
```
kubectl create ns app-lvs
```
### 安装使用
- 创建凭据
```
kubectl create -f secret.yaml
```
- 安装csi驱动
```
kubectl apply -f provisioner.yaml
kubectl apply -f attacher.yaml
kubectl apply -f csi-driver-s3.yaml
kubectl apply -f psp.yaml
```
- 创建storageclass
```
kubectl apply -f storageclass.yaml
```
- 创建pvc测试
```
kubectl apply -f test-pvc.yaml
```

### 参考链接
- [使用s3(minio)为kubernetes提供pv存储](https://www.lishuai.fun/2021/12/31/k8s-pv-s3/)
