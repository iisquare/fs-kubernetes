# harbor

### 独立安装-非K8S节点
- 下载并解压[harbor-offline-installer-v2.1.0.tgz](https://github.com/goharbor/harbor/releases/tag/v2.1.0)
- 修改配置文件
```
cp harbor.yml.tmpl harbor.yml
vim harbor.yml
hostname: localhost
# 注释掉https相关配置
```
- 执行安装脚本
```
./install.sh
```

### 安装说明
- 导入镜像
```
docker load -i ./harbor.v2.1.0.tar.gz
```


### Habor管理
- 上传镜像
```
# 拉取镜像
docker pull k8s.gcr.io/kubernetes-zookeeper:1.0-3.4.10
# 生成标签
docker tag anjia0532/google-containers.kubernetes-zookeeper:1.0-3.4.10 harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
# 登录仓库
docker login --username=admin harbor.iisquare.com
# 推送镜像
docker push harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
```

### 参考
- [Installation & Configuration Guide](https://goharbor.io/docs/2.1.0/install-config/)
