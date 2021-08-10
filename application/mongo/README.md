# mongo

### 运行方式
- 3节点副本集方式运行

### 如何使用
- 清理
```
kubectl delete -f mongo.yaml
kubectl delete configmaps mongo -n app-svr
rm -rf /data/k8s-pv/mongo
```
- 创建命名空间
```
kubectl create ns app-svr
```
- 创建keyfile认证文件
```
openssl rand -base64 90 -out ./mongodb-keyfile
```
- 导入配置文件
```
kubectl create configmap mongo --from-file=mongodb-keyfile -n app-svr
```
- 临时停用集群认证
```
# 注释掉如下指令：
# - "--auth"
# - "--keyFile"
# - "/etc/mongodb-keyfile"
```
- 应用配置清单
```
kubectl create -f mongo.yaml
```
- 配置副本集
```
mongo --host <ip-address>
rs.initiate()
rs.status()
rs.add("<ip-address>:27017")
rs.add("<ip-address>:27017")
rs.conf()
rs.status()
```
- 创建管理用户
```
use admin
db.createUser({
  user: "root",
  pwd: 'admin888',
  roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
})
db.grantRolesToUser("root", ["clusterAdmin"])
```
- 恢复配置，启动认证
```
kubectl delete -f mongo.yaml
 - "--auth"
 - "--keyFile"
 - "/etc/mongodb-keyfile"
kubectl create -f mongo.yaml
```
- 可用性测试，登入任意节点
```
use admin
db.auth('root', 'admin888')
show dbs
rs.secondaryOk() # 临时允许读副本
db.getCollectionNames()
```

### 参考链接
- [高可用的MongoDB集群](https://www.jianshu.com/p/2825a66d6aed)
- [MONGODB MANUAL - Enable Access Control](https://docs.mongodb.com/manual/tutorial/enable-authentication/)
