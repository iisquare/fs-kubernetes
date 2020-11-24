# CentOS Environment
操作系统环境准备，仅主节点之间进行SSH免密登录授权。机器配置要求CPU2核+，内存2GB+；selinux是用来加强安全性的一个组件，但非常容易出错且难以定位，安装时禁用；swap在内存不足时会将部分内存数据存放到磁盘中，为性能考虑建议关掉。

### 修改主机名称
```
hostnamectl set-hostname hostname
```

### 增加域名解析或更改/etc/hosts文件
```
192.168.2.77 virtual77
192.168.2.74 node74
192.168.2.75 node75
192.168.2.76 node76
192.168.2.78 node78
192.168.2.79 node79
192.168.2.80 node80
192.168.2.92 node92
```

### 禁用swap交换空间
```
free -h # 当前内存状态
swapoff -a # 临时禁用
cat /etc/fstab # 当前文件挂载项
sed -i.bak '/swap/s/^/#/' /etc/fstab # 注释掉swap所在行
cat /etc/fstab # 修改后的文件挂载项
free -h # 修改后的内存状态
```

### 修改内核参数供flannel网络使用
```
lsmod |grep br_netfilter
modprobe br_netfilter
cat > /etc/rc.sysinit << EOF
#!/bin/bash
for file in /etc/sysconfig/modules/*.modules ; do
[ -x $file ] && $file
done
EOF
cat > /etc/sysconfig/modules/br_netfilter.modules << EOF
modprobe br_netfilter
EOF
chmod 755 /etc/sysconfig/modules/br_netfilter.modules
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf
```

### 修改防火墙配置
```
systemctl stop firewalld 
systemctl disable firewalld
```

### 设置Kubernetes源
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum clean all
yum -y makecache
```

### 仅主节点之间免密登录
- 创建密钥
```
ssh-keygen -t rsa -C root@node-ip
```
- 节点之间共享公有密钥
```
ssh-copy-id -i /root/.ssh/id_rsa.pub root@target-ip
```
- 节点之间免密登录测试
```
ssh root@target-ip
```
- 查看目标机器的授权文件
```
cat /root/.ssh/authorized_keys
```

### 安装Docker
- 安装依赖
```
yum install -y yum-utils device-mapper-persistent-data lvm2
```
- 设置Docker源
```
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
- 查看Docker版本
```
yum list docker-ce --showduplicates | sort -r
```
- 安装Docker
```
yum install docker-ce-18.09.9 docker-ce-cli-18.09.9 containerd.io -y
```
- 启动Docker
```
systemctl start docker
systemctl enable docker
systemctl status docker
```
- 镜像加速
```
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com"
  ]
}
EOF
systemctl daemon-reload
systemctl restart docker
```
- 修改Cgroup Driver
```
vim /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
systemctl daemon-reload
systemctl restart docker
```

### 命令补全
```
yum -y install bash-completion
source /etc/profile.d/bash_completion.sh
```

### 参考
- [Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://www.kubernetes.org.cn/6632.html)
