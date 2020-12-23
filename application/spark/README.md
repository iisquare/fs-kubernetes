# spark on kubernetes

### 使用说明
- 下载并安装spark，根据官方预编译版本和hadoop发行说明，推荐采用scala2.12.x和hadoop2.7.x
```
wget https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.4.7/spark-2.4.7-bin-hadoop2.7.tgz
vim /etc/bashrc
export SPARK_HOME=/opt/spark-2.4.7-bin-hadoop2.7
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
./bin/docker-image-tool.sh -r harbor.iisquare.com/library -t 2.4.7 build
./bin/docker-image-tool.sh -r harbor.iisquare.com/library -t 2.4.7 push
```
- 环境准备
```
kubectl create ns spark
kubectl create serviceaccount spark -n spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=spark:spark --namespace=spark
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
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image=harbor.iisquare.com/library/spark:2.4.7 \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.4.7.jar
```


### 参考链接
- [Running Spark on Kubernetes](https://spark.apache.org/docs/2.4.7/running-on-kubernetes.html)
