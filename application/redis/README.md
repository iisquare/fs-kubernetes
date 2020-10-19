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
redis-cli --cluster add-node 192.168.2.78:6379 192.168.2.74:6379 --cluster-slave --cluster-master-id 2ba0fac1a5842651dca7114b485787ab57f6a423
redis-cli --cluster add-node 192.168.2.79:6379 192.168.2.75:6379 --cluster-slave --cluster-master-id c22f3049632464b281b6214ea6e398693f8d6507
redis-cli --cluster add-node 192.168.2.80:6379 192.168.2.76:6379 --cluster-slave --cluster-master-id 2dd4f0a55d21707d311338417676d67fdca9ad41
```
- 客户端连接
```
redis-cli -c # 指定集群模式
```

### 参考链接
- [在K8S上搭建Redis集群](https://juejin.im/post/6844903806719754254)
- [redis Waiting for the cluster to join](https://my.oschina.net/chrisforbt/blog/2980875)
