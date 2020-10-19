# redis

### 运行方式
- 三主三从，通过绑定节点挂载本地硬盘方式运行

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
```


### 参考链接
- [在K8S上搭建Redis集群](https://juejin.im/post/6844903806719754254)
