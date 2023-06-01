# k8s application

### 管理备忘
```
  k8s.iisquare.com         dashboard token
  harbor.iisquare.com      私有docker仓库 admin admin888
  notary.iisquare.com      docker签名认证
  prometheus.iisquare.com  监控采集
  grafana.iisquare.com     监控面板 admin grafana
  istio.iisquare.com       测试用例
  jaeger.iisquare.com      链路跟踪
  kiali.iisquare.com       微服务治理
  rabbitmq.iisquare.com    消息队列 admin admin888
  kibana.iisquare.com      搜索引擎
  nebula.iisquare.com      图数据库 user:password@192.168.2.78:3699
  kafka.iisquare.com       消息队列
```

### 节点逻辑划分
- 基础服务节点：Elasticsearch、ZK、Kafka、RabbitMQ、MySQL、FS

  其中，ES的业务集群、日志集群、数据集群建议分开部署，IO密集型和计算密集型服务可分配到不同的节点上。

- 计算服务节点：Hadoop、HDFS、HBASE、Flink

  其中，Flink on Yarn为当前优选方案，可视Flink on K8S的成熟程度确定最终选型。Hadoop集群建议在独立节点上进行部署，方便水平拓展和伸缩节点数量。

- 动态共享节点：Web、Ingress

  其中，Ingress可根据内部和外部访问策略部署两套服务，端口暴漏方式根据外部LBS方案就行选择。

- 静态共享节点：Kibana、Prometheus、Grafana
- 功能测试节点：独立容器或GPU服务

### 注意事项
- 当节点内存不足，Container不断被系统Kill掉，对应的Pod可能会被直接删除，采用kind: Pod方式部署的应用将无法被拉起。

## 最佳实践

### Service

当Service的spec.type设置为ClusterIP类型，且spec.clusterIP值为None时，被称为"Headless Service"。此时，它并不提供负载均衡功能，也不会自动轮询访问后端Pod，仅提供DNS解析。
```
dig -t A <service>.<namespace>.svc.cluster.local
```
若需要自动处理负载均衡，则不可将spec.clusterIP设为None值，Service将过代理转发流量到后端Pod。
若已启用负载均衡，但需要用会话粘性（Session Affinity），将同客户端的请求路由到同一个后端Pod，则可将spec.sessionAffinity设为ClientIP，通spec.sessionAffinityConfig.clientIP.timeoutSeconds设置会话停留时间。


## 参考
- [Docker Hub](https://hub.docker.com/)
- [Helm Charts](https://hub.helm.sh/)
