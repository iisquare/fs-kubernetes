# GitLab Runner

## 节点说明
| 节点 | 角色 | 说明 |
| :----- | :----- |:----- |
| node92 | manage | 控制节点，应用程序打包部署 |

## 安装配置

### 准备一台编译打包专用机器
```
vim /etc/bashrc
export JAVA_HOME=/opt/jdk1.8.0_111
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export ANT_HOME=/opt/apache-ant-1.10.3
export MAVEN_HOME=/opt/apache-maven-3.6.3
export GRADLE_HOME=/opt/gradle-6.7
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin
```
### 将该节点设置为k8s的管理客户端
### 拷贝授权文件至root家目录，确保sudo方式正常执行
```
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo kubectl get nodes
# ---
# fixed:The connection to the server localhost:8080 was refused - did you specify the right host or port
# ---
```
### 配置GitlabRunner环境，采用shell方式运行
```
 curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash
 yum install gitlab-runner
 gitlab-runner register
```
### 为gitlab-runner用户添加免密sudo执行权限
```
vim /etc/sudoers
## Allow root to run any commands anywhere 
root              ALL=(ALL)       ALL
gitlab-runner     ALL=(ALL)       NOPASSWD: ALL
```
### 登录harbor，确保该节点可正常拉取和推送私有仓库
```
docker login harbor.iisquare.com -u gitlab -p Gitlab888
cat /root/.docker/config.json
# ---
# 确保helm harbor的externalURL参数配置为完整URL
# fixed:Error response from daemon schema empty
# ---
```
### 编译并推送自定义JDK镜像
### 准备待部署项目的Dockerfile文件
### 配置harbor的secret，确保k8s可正常拉取私有仓库中的镜像
```
kubectl create secret docker-registry harbor -n demo-java \
  --docker-server=harbor.iisquare.com \
  --docker-username=admin \
  --docker-password=admin888 \
  --docker-email=
```
### 准备待部署项目的资源清单，确保imagePullSecrets与上述参数一致且在同一命名空间下
```
metadata:
  namespace: demo-java
spec:
  template:
    spec:
      imagePullSecrets:
        - name: harbor
```
### 编写deploy.sh部署脚本
### 编写.gitlab-ci.yml配置文件

## IDEA远程调试Java应用

### 配置IDEA在Edit Configurations...中增加Remove应用
### 编辑Deployments增加启动参数
```
command:
  - java
  - '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005'
  - '-jar'
args:
  - /app.jar
  - '--server.port=8080'
```
### 编辑Deployments暴漏调试端口
```
- name: debug
  containerPort: 5005
  hostPort: 5005
```
### 调试完成后清理以上参数


## 参考
- [报错：The connection to the server localhost:8080 was refused](https://blog.csdn.net/M82_A1/article/details/99671934)
- [GitLab持续集成--配置Runner](https://blog.csdn.net/frankcheng5143/article/details/79838414)
- [CentOS下sudo免密配置](https://www.jianshu.com/p/22effba56f7e)
- [Intellij IDEA基于Springboot的远程调试](https://blog.csdn.net/wo541075754/article/details/75008617)
