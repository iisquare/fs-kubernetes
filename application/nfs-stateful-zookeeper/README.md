# kubernetes-application-zookeeper

有状态集合测试用例

### 管理
- zkCli
```
kubectl exec -n bicluster -it pod/zk-0 zkCli.sh ls /
```

### 参考链接
- [运行 ZooKeeper， 一个 CP 分布式系统](https://kubernetes.io/zh/docs/tutorials/stateful-application/zookeeper/)
