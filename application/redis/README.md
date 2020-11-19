# redis

### 运行方式
- 三主三从，通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 创建命名空间
```
kubectl create ns svr-app
```
- 导入配置文件
```
kubectl create configmap redis --from-file=redis.conf -n svr-app
```
- 应用配置清单
```
kubectl create -f redis.yaml
```
- 初始化集群
```
redis-cli --cluster create 192.168.2.74:6379 192.168.2.75:6379 192.168.2.76:6379
redis-cli --cluster add-node 192.168.2.78:6379 192.168.2.74:6379 --cluster-slave --cluster-master-id 2f871fe865c1ca38214d564a2dc89ee04d2e4127
redis-cli --cluster add-node 192.168.2.79:6379 192.168.2.75:6379 --cluster-slave --cluster-master-id 1da75d2b05eab4fc8ad30d6bb7b88f156bae9d94
redis-cli --cluster add-node 192.168.2.80:6379 192.168.2.76:6379 --cluster-slave --cluster-master-id 1ce0c48a2fa0ee4e1dabafd92b83ab3291c9ebc8
```
- 修改nodes.conf文件，将myself更改为节点IP地址
```
vim /data/k8s-pv/redis/nodes.conf
```
- 重启服务
```
kubectl replace --force -f redis.yaml
```
- 客户端连接
```
redis-cli -c # 指定集群模式
```

### 参考链接
- [在K8S上搭建Redis集群](https://juejin.im/post/6844903806719754254)
- [redis Waiting for the cluster to join](https://my.oschina.net/chrisforbt/blog/2980875)
