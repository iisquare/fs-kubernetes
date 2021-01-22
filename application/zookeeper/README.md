# zookeeper

### 运行方式
- 通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 清理
```
kubectl delete -f zookeeper.yaml
rm -rf /data/k8s-pv/zookeeper
```
- 创建命名空间
```
kubectl create ns app-svr
```
- 应用配置清单
```
kubectl create -f zookeeper.yaml
```

### 注意事项
- 自身节点的ZOO_SERVERS需要配置为0.0.0.0，否则会绑定端口失败
```
java.net.BindException: Cannot assign requested address (Bind failed)
        at java.base/java.net.PlainSocketImpl.socketBind(Native Method)
        at java.base/java.net.AbstractPlainSocketImpl.bind(Unknown Source)
        at java.base/java.net.ServerSocket.bind(Unknown Source)
        at java.base/java.net.ServerSocket.bind(Unknown Source)
```

### 参考链接
