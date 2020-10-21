# helm
仅用于安装部分复杂度较高的基础组件，或运维提供的私有组件，不建议直接在集群中通过helm安装应用。

### 安装说明
- 下载并解压[helm-v3.3.4-linux-amd64.tar.gz](https://github.com/helm/helm/releases/tag/v3.3.4)
- 拷贝可执行文件
```
cp helm /usr/local/bin
helm version
```

### 参考
- [Helm安装使用](https://www.qikqiak.com/k8s-book/docs/42.Helm%E5%AE%89%E8%A3%85.html)
