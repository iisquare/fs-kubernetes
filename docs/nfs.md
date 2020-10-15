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
- 部署脚本
```
cd /data/nfs
git clone https://github.com/iisquare/kubernetes
cp /data/nfs/kubernetes/docs/fiels/inotify.service /etc/systemd/system/
chmod 754 /etc/systemd/system/inotify.service
systemctl daemon-reload
systemctl start inotify
systemctl enable inotify
```


### 注意事项
- 重启后，请确保当前节点与在运行节点的同步目录下的数据一致。
- 在数据同步完成之前，请勿将未同步节点设置为虚拟IP的主节点。


### 参考
- [rsync + inotify 实现文件实时双向自动同步](https://juejin.im/post/6844903989801123853)

