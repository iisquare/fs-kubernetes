# Nebula Graph

### 运行说明
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
kubectl create configmap studio --from-file=nginx.conf -n nebula-graph
kubectl create -f nebula-web.yaml
```
- 配置ingress
```
kubectl create -f ingress.yaml
```

### 参考链接
- [图数据库对比：Neo4j vs Nebula Graph vs HugeGraph](https://my.oschina.net/u/4169309/blog/4532482)
- [nebula-docker-compose](https://github.com/vesoft-inc/nebula-docker-compose)
- [nebula-web-docker](https://github.com/vesoft-inc/nebula-web-docker)
