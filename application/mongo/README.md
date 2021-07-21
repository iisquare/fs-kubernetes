# mongo

### 运行方式
- 3节点副本集方式运行

### 如何使用
- 创建命名空间
```
kubectl create ns app-svr
```
- 应用配置清单
```
kubectl create -f mongo.yaml
```
- 配置副本集
```
rs.initiate()
rs.add("<hostname>:27017")
rs.add("<hostname>:27017")
rs.conf()
```

### 参考链接
- [高可用的MongoDB集群](https://www.jianshu.com/p/2825a66d6aed)
