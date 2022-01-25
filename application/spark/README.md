# spark on kubernetes
通过挂载NFS本地目录，将作业历史写入到共享目录中；启动独立的history-server，用于监控业务运行状态；临时调试可采用port-forward查看对应的作业，作业执行完成后web-ui不可用。

### 使用说明
- 下载并安装spark，根据官方预编译版本和hadoop发行说明，推荐采用scala2.12.x和hadoop2.7.x
```
wget https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.2.0/spark-3.2.0-bin-hadoop2.7.tgz
vim /etc/bashrc
export SPARK_HOME=/opt/spark-3.2.0-bin-hadoop2.7
```
- 更改国内源
```
vim kubernetes/dockerfiles/spark/Dockerfile
# sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list && \
sed -i 's/http:\/\/\(deb\|security\)\.debian\.org/https:\/\/mirrors\.tuna\.tsinghua\.edu\.cn/g' /etc/apt/sources.list && \
```
- 构建镜像
```
docker pull openjdk:8-jdk-slim # 3.x is 8-jre-slim
docker rmi harbor.iisquare.com/library/spark:3.2.0
./bin/docker-image-tool.sh -r harbor.iisquare.com/library -t 3.2.0 build
./bin/docker-image-tool.sh -r harbor.iisquare.com/library -t 3.2.0 push
```
- 环境准备
```
kubectl create ns spark
kubectl create serviceaccount spark -n spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=spark:spark --namespace=spark
```
- 挂载NFS共享文件
```
mkdir -p /data/nfs/spark/spark-events
```
- 作业配置（镜像中不含conf目录，在提交作业时通过configmap挂载）
```
vim conf/spark-defaults.conf
vim conf/spark-env.sh
```
- 配置harbor的secret，确保k8s可正常拉取私有仓库中的镜像
```
kubectl create secret docker-registry harbor -n spark \
  --docker-server=harbor.iisquare.com \
  --docker-username=admin \
  --docker-password=admin888 \
  --docker-email=
```
- 作业测试
```
kubectl cluster-info
./bin/spark-submit \
    --master k8s://https://192.168.2.77:6443 \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=5 \
    --conf spark.kubernetes.namespace=spark \
    --conf spark.kubernetes.container.image.pullSecrets=harbor
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image=harbor.iisquare.com/library/spark:3.2.0 \
    --conf spark.kubernetes.driver.volumes.hostPath.data.mount.path=/data \
    --conf spark.kubernetes.driver.volumes.hostPath.data.mount.readOnly=false \
    --conf spark.kubernetes.driver.volumes.hostPath.data.options.path=/data/nfs/spark \
    --conf spark.kubernetes.executor.volumes.hostPath.data.mount.path=/data \
    --conf spark.kubernetes.executor.volumes.hostPath.data.mount.readOnly=false \
    --conf spark.kubernetes.executor.volumes.hostPath.data.options.path=/data/nfs/spark \
    local:///opt/spark/examples/jars/spark-examples_2.12-3.2.0.jar
```
- 临时查看运行中的作业
```
kubectl port-forward --address 0.0.0.0 -n spark <pod-name> 4040:4040
```

### 历史作业
- 清理
```
kubectl delete -f spark-history.yaml
kubectl delete configmaps spark-history -n spark
```
- 导入配置文件
```
kubectl create configmap spark-history --from-file=conf -n spark
```
- 应用配置清单
```
kubectl create -f spark-history.yaml
```

### 参考链接
- [Running Spark on Kubernetes](https://spark.apache.org/docs/3.2.0/running-on-kubernetes.html)
- [在Docker中运行Spark历史记录服务器以查看AWS Glue作业](https://stackoom.com/question/3yLOH/%E5%9C%A8Docker%E4%B8%AD%E8%BF%90%E8%A1%8CSpark%E5%8E%86%E5%8F%B2%E8%AE%B0%E5%BD%95%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%BB%A5%E6%9F%A5%E7%9C%8BAWS-Glue%E4%BD%9C%E4%B8%9A)
