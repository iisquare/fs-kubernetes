# ceph

## 运行方式
- KV_IP仅支持单个IP，采用KV_TYPE=etcd存在单点问题，故采用NFS共享配置信息。
- OSD存储必须是独立块设备，如果无可用硬盘或分区，可采用虚拟硬盘方式进行挂载。
- MGR的dashboard只有activate节点可正常访问，standby节点返回500并根据standby_behaviour策略默认跳转至主节点。

## 使用说明
### 清理
```
rm -rf /data/nfs/ceph/
```
### 命名空间
```
kubectl create ns ceph
```
### Monitor
- 启动mon服务
```
kubectl create -f monitor.yaml
kubectl -n ceph get pod
```
#### Manager
- 启动mgr服务
```
kubectl create -f manager.yaml
```
- 启用控制面板
```
ceph mgr module enable dashboard
ceph dashboard create-self-signed-cert
ceph dashboard set-login-credentials admin admin888
ceph config set mgr mgr/dashboard/server_addr 0.0.0.0
ceph config set mgr mgr/dashboard/server_port 16789
ceph config set mgr mgr/dashboard/ssl false
# ceph config set mgr mgr/dashboard/standby_behaviour "error"
# - 其他配置
ceph config set mon mon_allow_pool_delete true
# -
ceph config dump
ceph mgr services
kubectl replace -f manager.yaml --force
ceph mgr services
```
- 配置ingress
```
vim ingress.yaml
# -
# Endpoints.subsets.addresses.ip
# -
kubectl create -f ingress.yaml
```
### Storage
- 挂载硬盘
```
fdisk -l
mkfs.xfs -f /dev/sdb
xfs_repair /dev/sdb
mkdir -p /data/osd
mount /dev/sdb /data/osd
ls -alh /data/osd
vim /etc/fstab
# -
# /dev/sdb    /data/osd   xfs    defaults     1 1
# -
```
- 分发授权文件
```
ceph auth get client.bootstrap-osd -o /var/lib/ceph/bootstrap-osd/ceph.keyring
```
- 启动osd服务
```
kubectl create -f storage.yaml
```
### StorageClass
- 配置[Provisioner提供者](https://github.com/kubernetes-retired/external-storage)
```
kubectl create -f rbac.yaml
kubectl create -f provisioner.yaml
```
- 获取keyring文件
```
grep key /data/nfs/ceph/etc/ceph.client.admin.keyring |awk '{printf "%s", $NF}'|base64
# -
# QVFCcEpRbGdMdlkzTVJBQUhhankxR1N3OGN1eG5iNnFkM2puekE9PQ==
# -
```
- 配置Secret密钥
```
vim secret.yaml
kubectl create -f secret.yaml
```
- 配置Pool存储池
```
ceph osd pool create rbd 128 replicated # 推荐采用dashboard操作
```
- 配置StorageClass存储类
```
kubectl create -f storage-class.yaml
```
- 执行PVC测试
```
kubectl create -f test-pvc.yaml
kubectl -n ceph describe pvc ceph-test
```

## 问题及解决方案

### failed to create rbd image: executable file not found in $PATH, command output

使用动态存储时controller-manager需要使用rbd命令创建image，但官方controller-manager镜像里没有rbd命令。

## 参考
- [Ceph介绍及原理架构分享](https://www.jianshu.com/p/cc3ece850433)
- [ceph-deploy部署ceph集群](https://www.kancloud.cn/willseecloud/ceph/1788301)
- [使用docker快速部署Ceph集群 arm64 or x86](https://www.jianshu.com/p/ff3be28a1015)
- [Linux创建、挂载、格式化虚拟磁盘](https://blog.csdn.net/pkgfs/article/details/8498667)
- [配置StorageClass](https://www.kancloud.cn/willseecloud/ceph/1788306)
- [Kubernetes 文档/概念/存储/存储类](https://kubernetes.io/zh/docs/concepts/storage/storage-classes/#ceph-rbd)
- [Ceph 存储集群/集群运维/存储池](http://docs.ceph.org.cn/rados/operations/pools/)
- [Kubernetes配置Ceph RBD StorageClass](https://www.cnblogs.com/ltxdzh/p/9173570.html)
- [k8s storageclass-ceph持久化存储](https://llussy.github.io/2019/01/26/storageclass-ceph/)
