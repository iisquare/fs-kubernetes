# Kubernetes Install
K8S高可用集群安装说明，未采用独立ETCD集群。

### 节点信息
| 节点 | 角色 | IP | 系统 |
| :----- | :----- | :----- | :----- |
| node74 | master | 192.168.2.74 | CentOS7.8.2003 |
| node75 | master | 192.168.2.75 | CentOS7.8.2003 |
| node76 | master | 192.168.2.76 | CentOS7.8.2003 |
| virtual77 | lvs | 192.168.2.77 | - |
| node78 | worker | 192.168.2.78 | CentOS7.8.2003 |
| node79 | worker | 192.168.2.79 | CentOS7.8.2003 |
| node80 | worker | 192.168.2.80 | CentOS7.8.2003 |

### 系统环境
[centos7.md](./centos7.md)

### 共享存储和LVS
[nfs.md](./nfs.md)

### 安装K8S
- 查看版本
```
yum list kubelet --showduplicates | sort -r
```
- 管理节点工具安装
```
yum install -y kubelet-1.18.9 kubeadm-1.18.9 kubectl-1.18.9
systemctl enable kubelet && systemctl start kubelet
echo "source <(kubectl completion bash)" >> ~/.bash_profile
source ~/.bash_profile
```
- 工作节点工具安装
```
yum install -y kubelet-1.18.9
systemctl enable kubelet && systemctl start kubelet
```




### 参考
- [Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://www.kubernetes.org.cn/6632.html)
