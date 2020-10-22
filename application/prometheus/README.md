# prometheus

### 安装说明
- 下载kube-prometheus release-0.6
```
git clone https://github.com/prometheus-operator/kube-prometheus.git
git checkout release-0.6
```
- 为grafana添加持久卷
```
kubectl create -f pvc-grafana.yaml
vim manifests/grafana-deployment.yaml 
# ---
# 122       - emptyDir: {}
# 123         name: grafana-storage
# ---
# 122       - name: grafana-storage
# 123         persistentVolumeClaim:
# 124           claimName: pvc-grafana
# ---
```
- 为prometheus添加持久卷
```
vim manifests/prometheus-prometheus.yaml 
# ---
# 14   image: quay.io/prometheus/prometheus:v2.20.0
# 15   storage:
# 16     volumeClaimTemplate:
# 17       spec:
# 18         storageClassName: lvs-nfs-storage
# 19         accessModes: ["ReadWriteOnce"]
# 20         resources:
# 21           requests:
# 22             storage: 10Gi
# 23   nodeSelector:
# ---
```
- 修改存储时长
```
vim manifests/setup/prometheus-operator-deployment.yaml
# ---
# 24       - args:
# 25         - storage.tsdb.retention.time=180d
# ---
```
- 执行安装
```
kubectl create -f manifests/setup/
kubectl create -f manifests/
```



### 参考
- [k8s安装prometheus并持久化数据](https://www.fenghong.tech/blog/kubernetes/kubernetes-promtheus-persist-storage/)
