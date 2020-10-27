# 分布式共享存储
rsync+inotify+nfs+keepalived+lvs

### 节点说明
可在专用服务器上独立安装，也可以安装在k8s的主节点上。
| 节点 | 角色 | 说明 |
| :----- | :----- |:----- |
| node74 | master | - |
| node75 | master | - |
| node76 | master | - |
| virtual77 | lvs | - |


### 架构说明
- 通过rsync+inotify实现多节点双向同步。
- 在每个节点上安装nfs服务，共享同步目录。
- 在每个节点上安装keepalived+lvs，共享同一个虚拟IP地址。
- 客户端通过虚拟IP挂载nfs目录，实际对应为虚拟IP主节点。

### 安装rsync
- 安装
```
yum install -y rsync
```
- 运行模式

  当前采用SSH免密登录方式，不再单独配置rsyncd服务。

- 创建同步目录
```
mkdir -p /data/nfs
```

### 安装inotify
- 下载安装包
```
https://centos.pkgs.org/7/epel-x86_64/inotify-tools-3.14-9.el7.x86_64.rpm.html
```
- 安装RPM文件
```
yum install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/i/inotify-tools-3.14-9.el7.x86_64.rpm
```
- 部署脚本（注意脚本中的IP需要与SSH授权的一致）
```
cd /data/nfs
git clone https://github.com/iisquare/kubernetes
cp /data/nfs/kubernetes/docs/files/inotify.service /etc/systemd/system/
chmod 754 /etc/systemd/system/inotify.service
systemctl daemon-reload
systemctl start inotify
systemctl enable inotify
```
- 日志
```
journalctl -u inotify
```

### 安装nfs
- 安装
```
yum -y install nfs-utils
```
- 共享
```
echo "/data/nfs *(rw,no_root_squash,sync)" >> /etc/exports
exportfs -r
exportfs
```
- 服务
```
systemctl restart rpcbind && systemctl enable rpcbind
systemctl restart nfs && systemctl enable nfs
```
- 状态
```
rpcinfo -p localhost
showmount -e localhost
```
- 客户端挂载
```
yum -y install nfs-utils
mount -t nfs lvs-virtual-ip:/data/nfs /path/to/mounted
```

### 安装keepalived
- 安装
```
yum -y install keepalived
```
- 配置
```
ip addr # 查看网卡名称
cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak
vim /etc/keepalived/keepalived.conf
```
其中node_host为节点名称，ens_name为网卡名称，192.168.2.77为虚拟IP地址，若state设置为MASTER则在各节点权重相同时优先选为主节点，建议每个节点的priority优先级设置为不同的值，同一集群的virtual_router_id的值必须一致。
```
! Configuration File for keepalived
global_defs {
   router_id node_host
}
vrrp_instance VI_1 {
    state BACKUP
    interface ens_name
    virtual_router_id 50
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.2.77
    }
}
```
- 服务
```
systemctl start keepalived
systemctl enable keepalived
```
- 日志
```
tail -f /var/log/messages 
```

### 注意事项
- 重启后，请确保当前节点与在运行节点的同步目录下的数据一致。
- 在数据同步完成之前，请勿将未同步节点设置为虚拟IP的主节点。
- 请确保集群节点之间通信正常，若出现脑裂现象（如多个节点绑定了同一个虚拟IP），可尝试修改防火墙策略。

### 参考
- [rsync + inotify 实现文件实时双向自动同步](https://juejin.im/post/6844903989801123853)
- [kubernetes部署NFS持久存储（静态和动态）](https://www.jianshu.com/p/5e565a8049fc)
- [Centos7.6部署k8s v1.16.4高可用集群(主备模式)](https://www.kubernetes.org.cn/6632.html)
