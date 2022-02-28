# Kubernetes Install
K8S高可用集群安装说明，未采用独立ETCD集群。

### 节点信息
| 节点 | 角色 | IP | 系统 | 说明 |
| :----- | :----- | :----- | :----- | :----- |
| node74 | master | 192.168.2.74 | CentOS7.8.2003 | 无 |
| node75 | master | 192.168.2.75 | CentOS7.8.2003 | 无 |
| node76 | master | 192.168.2.76 | CentOS7.8.2003 | 无 |
| virtual77 | lvs | 192.168.2.77 | - |
| node78 | worker | 192.168.2.78 | CentOS7.8.2003 | 无 |
| node79 | worker | 192.168.2.79 | CentOS7.8.2003 | 无 |
| node80 | worker | 192.168.2.80 | CentOS7.8.2003 | 无 |
| node92 | manage | 192.168.2.92 | CentOS7.8.2003 | 控制节点，应用程序打包部署 |

### 系统环境
[centos7.md](./centos7.md)

### 共享存储和LVS
[nfs.md](./nfs.md)

### 安装K8S-LVS主节点
- 查看版本
```
yum list kubelet --showduplicates | sort -r
```
- 工具安装
```
yum install -y kubelet-1.18.9 kubeadm-1.18.9 kubectl-1.18.9
systemctl enable kubelet && systemctl start kubelet
echo "source <(kubectl completion bash)" >> ~/.bash_profile
source ~/.bash_profile
```
- 版本确认
```
docker --version
kubelet --version
kubectl version
kubeadm version
```
- 手动导入镜像
```
kubeadm config images list --kubernetes-version=1.18.9
docker pull xxx-name-version
docker save -o k8s-1.18.9.tar xxx-id yyy-id
tar -czvf k8s-1.18.9.tar.gz k8s-1.18.9.tar
tar -xzvf k8s-1.18.9.tar.gz
docker load < k8s-1.18.9.tar
docker tag xxx-id xxx-name-version
```
- 初始化主节点
```
# 可通过--image-repository=参数指定镜像地址
kubeadm init --config=/data/nfs/kubernetes/docs/files/kubeadm-config.yaml
```
- 记录kubeadm的输出信息
- 失败重置
```
kubeadm reset
rm -rf $HOME/.kube/config
```
- 加载环境变量
```
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
source ~/.bash_profile
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```
- 安装[flannel](https://github.com/coreos/flannel/)网络
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### 加入control plane节点
- 通过主节点颁发证书
```
sh /data/nfs/kubernetes/docs/files/cert-master.sh target-ip
```
- 加入集群
```
kubeadm join 192.168.2.77:6443 --token wwxdsz.9lcdmiqy53u8292f \
  --discovery-token-ca-cert-hash sha256:7d71515e92af012f187ce26b12470741ad602ddc604bd8ff41a783435bca2c85 \
  --control-plane 
```
- 加载环境变量用于执行kubectl命令
```
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
source ~/.bash_profile
```
- 查看状态
```
kubectl get nodes
kubectl get po -o wide -n kube-system
```

### 加入工作节点
- 工具安装
```
yum install -y kubelet-1.18.9 kubeadm-1.18.9 kubectl-1.18.9
systemctl enable kubelet && systemctl start kubelet
```
- 加入集群
```
kubeadm join 192.168.2.77:6443 --token wwxdsz.9lcdmiqy53u8292f \
    --discovery-token-ca-cert-hash sha256:7d71515e92af012f187ce26b12470741ad602ddc604bd8ff41a783435bca2c85
```

### 加入管理客户端节点
- 配置kubernetes源
- 安装kubectl
```
yum install -y kubectl-1.18.9
```
- 命令补全
```
yum -y install bash-completion
source /etc/profile.d/bash_completion.sh
```
- 拷贝授权文件
```
scp master-ip:/etc/kubernetes/admin.conf /etc/kubernetes/
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
source ~/.bash_profile
```
- 环境变量
```
echo "source <(kubectl completion bash)" >> ~/.bash_profile
source ~/.bash_profile
```

### 重置集群节点
- 下线集群节点
```
kubectl cordon node-name # 设置为不可调度
kubectl drain node-name # 驱逐节点上Pod
kubectl uncordon node-name # 恢复调度
kubectl delete node node-name
```
- 移除etcd集群（若为独立集群可忽略）
```
docker exec -it $(docker ps -f name=etcd_etcd -q) /bin/sh
etcdctl --endpoints 127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member list
etcdctl --endpoints 127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member remove etcd-node-id
```
- 重置过期Token
```
kubeadm token create
kubeadm token list
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```
- 重置并重新加入

### 更新证书
- 查看证书过期时间
```
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text |grep ' Not '
kubeadm alpha certs check-expiration
```
- 更新前备份
```
cp -rp /etc/kubernetes /etc/kubernetes.back
cp -rp /var/lib/kubelet /var/lib/kubelet.back
```
- 更新证书过期时间
```
rm -f /etc/kubernetes/*.conf
# rm -rf /var/lib/kubelet/pki/
kubeadm alpha certs renew all --config=/data/nfs/dev-ops/docs/files/kubeadm-config.yaml
kubeadm init phase kubeconfig all --config=/data/nfs/dev-ops/docs/files/kubeadm-config.yaml
cp /etc/kubernetes/admin.conf ~/.kube/config
```
- 顺序重启全部节点
```
# docker restart $(docker ps -q)
systemctl restart kubelet
```
- 更新管理节点
```
scp master-ip:/etc/kubernetes/admin.conf /etc/kubernetes/
```

### 强制启用交换分区
```
vim /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
#kubeadm init with --ignore-preflight-errors=Swap
```

### 参考
- [Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://www.kubernetes.org.cn/6632.html)
- [将 master 节点服务器从 k8s 集群中移除并重新加入](https://www.cnblogs.com/dudu/p/12173867.html)
- [kubeadm 生成的token过期后，集群增加节点](https://blog.csdn.net/mailjoin/article/details/79686934)
- [k8s过期证书解决方案](https://blog.51cto.com/zyxjohn/2471985)
- [部署k8s不关闭swap](https://blog.csdn.net/qq_42362811/article/details/103362514)
