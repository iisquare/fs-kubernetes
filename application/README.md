# k8s application

### 节点逻辑划分
- 基础服务节点：Elasticsearch、ZK、Kafka、RabbitMQ、MySQL、FS

  其中，ES的业务集群、日志集群、数据集群建议分开部署，IO密集型和计算密集型服务可分配到不同的节点上。

- 计算服务节点：Hadoop、HDFS、HBASE、Flink

  其中，Flink on Yarn为当前优选方案，可视Flink on K8S的成熟程度确定最终选型。Hadoop集群建议在独立节点上进行部署，方便水平拓展和伸缩节点数量。

- 动态共享节点：Web、Ingress

  其中，Ingress可根据内部和外部访问策略部署两套服务，端口暴漏方式根据外部LBS方案就行选择。

- 静态共享节点：Kibana、Prometheus、Grafana
- 功能测试节点：独立容器或GPU服务
