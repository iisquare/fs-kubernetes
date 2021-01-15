# Docker for Kubernetes

## 常用命令
- 转移镜像
```
docker pull openjdk:8
docker pull openjdk:8-jdk-slim
docker pull openjdk:8-jre-slim
docker save -o openjdk-8.tar 89f100fa8f9f cd08b38dfcae fe56938077d4
tar -czvf openjdk-8.tar.gz openjdk-8.tar
tar -xzvf openjdk-8.gz
docker load < openjdk-8.tar
docker tag 89f100fa8f9f openjdk:8
docker tag fe56938077d4 openjdk:8-jdk-slim
docker tag cd08b38dfcae openjdk:8-jre-slim
```
- 调试运行镜像
```
docker run -it --entrypoint /bin/bash name:version
```

## 参考
- [为容器设置启动时要执行的命令和参数](https://kubernetes.io/zh/docs/tasks/inject-data-application/define-command-argument-container/#notes)
- [Why are my Docker ARGs empty?](https://benkyriakou.com/posts/docker-args-empty)
