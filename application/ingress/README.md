# ingress

### 组件定位
- 采用ingress暴露内部服务，但不参与内部服务治理
- 采用多个ingress暴露不同的服务，隔离调试和真实访问请求
- 推荐采用节点绑定方式提供服务，避免多层转发，并基于外部LVS+LB实现高可用
- 内部测试可采用主节点的LVS避免单点故障，请求将全部落在主IP节点上

### 安装说明
- 下载[部署文件](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/cloud/deploy.yaml)
- NodePort方式参考[Bare-metal](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml)
- 拆分部署文件并安装
  - namespace：命名空间
  - rbac：权限控制
  - webhook：作业
  - internal：测试请求入口（node74、node75、node76、virtual77）
  - external：真实请求入口(node78、node79、node80)

### 参考
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx)
- [multiple-ingress](https://kubernetes.github.io/ingress-nginx/user-guide/multiple-ingress/)
- [Kubernetes的三种外部访问方式：NodePort、LoadBalancer 和 Ingress](http://dockone.io/article/4884)
