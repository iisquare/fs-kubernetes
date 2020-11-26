# kafka

### 运行方式
- 通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 清理
```
kubectl delete -f kafka.yaml
rm -rf /data/k8s-pv/kafka
./bin/zkCli.sh deleteall /kafka
```
- 创建命名空间
```
kubectl create ns svr-app
```
- 应用配置清单
```
kubectl create -f kafka.yaml
```
- 运行kafka-manager管理面板
```
kubectl create -f kafka-manager.yaml
```

### 参考链接
- [使用Docker部署Kafka时的网络应该如何配置](https://xinze.fun/2019/11/11/%E4%BD%BF%E7%94%A8Docker%E9%83%A8%E7%BD%B2Kafka%E6%97%B6%E7%9A%84%E7%BD%91%E7%BB%9C%E5%BA%94%E8%AF%A5%E5%A6%82%E4%BD%95%E9%85%8D%E7%BD%AE/)
