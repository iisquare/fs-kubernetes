# Nebula Graph

### 运行说明
- 清理
```
kubectl delete ns nebula-graph
rm -rf /data/k8s-pv/nebula-graph/
kubectl get pod -n nebula-graph -o wide
```
- 创建命名空间
```
kubectl create ns nebula-graph
```
- 安装metad
```
kubectl create -f nebula-metad.yaml
```
- 安装storaged
```
kubectl create -f nebula-storaged.yaml
```
- 安装graphd
```
kubectl create -f nebula-graphd.yaml
```
- 安装studio
```
kubectl delete configmaps studio -n nebula-graph
kubectl create configmap studio --from-file=nginx.conf -n nebula-graph
kubectl create -f nebula-web.yaml
```
- 配置ingress
```
kubectl create -f ingress.yaml
```
- 登录测试[user:password@192.168.2.78:3699](http://nebula.iisquare.com/)

### 踩坑指南
- metad：local_ip在集群中必须唯一，且与meta_server_addrs中的一致，不然会导致选举失败。
- metad：选举成功后，节点状态端口会绑定在ws_ip指定的IP上。
- metad：选举端口为服务端口+1，请保持这两个端口开放。

### 参考链接
- [图数据库对比：Neo4j vs Nebula Graph vs HugeGraph](https://my.oschina.net/u/4169309/blog/4532482)
- [nebula-docker-compose](https://github.com/vesoft-inc/nebula-docker-compose)
- [nebula-web-docker](https://github.com/vesoft-inc/nebula-web-docker)
