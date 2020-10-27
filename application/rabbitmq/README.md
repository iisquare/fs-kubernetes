# rabbitmq

### 运行方式
- 采用statefulset方式进行部署，节点异常（未手动设置不可调度状态）时pod不会主动飘移

### 如何使用
- 执行安装
```
kubectl create -f rabbitmq.yaml
```
- 查看node78节点信息
```
kubectl -n svr-app logs rabbitmq-node78
# ---
# node           : rabbit@rabbitmq-node78
# home dir       : /var/lib/rabbitmq
# config file(s) : /etc/rabbitmq/rabbitmq.conf
# cookie hash    : Qr//p2qMSEvFzqV5B8CqCg==
# log(s)         : <stdout>
# database dir   : /var/lib/rabbitmq/mnesia/rabbit@rabbitmq-node78
# ---
```
- 将node79和node80上加入node78
```
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@rabbitmq-0.rabbitmq.svr-app.svc.cluster.local
rabbitmqctl start_app
rabbitmqctl cluster_status
```
- 移除节点
```
rabbitmqctl reset
```
- 镜像队列
```
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
```

### 参考链接
- [rabbitmq集群部署](https://my.oschina.net/attacker/blog/3222748)
- [Clustering Guide](https://www.rabbitmq.com/clustering.html)
