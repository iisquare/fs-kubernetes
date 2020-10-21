# postgres

### 运行方式
- 一主两从，通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 清理
```
kubectl delete -f postgres.yaml
kubectl delete configmaps postgres -n svr-app
rm -rf /data/k8s-pv/postgres
```
- 创建命名空间
```
kubectl create ns svr-app
```
- 导入配置文件
```
kubectl create configmap postgres --from-file=master.conf --from-file=slave.conf --from-file=recovery.conf -n svr-app
```
- 应用配置清单
```
kubectl create -f postgres.yaml
```
- 主节点授权
```
CREATE ROLE pgrepuser REPLICATION LOGIN PASSWORD 'slave-password';
vim /var/lib/postgresql/data/pg_hba.conf
host    replication     pgrepuser       0.0.0.0/0               md5
su postgres
pg_ctl reload -D $PGDATA

```
- 查看备份状态
```
# pg_basebackup -D $PGDATA -Fp -Xs -v -P -h 192.168.2.78 -U pgrepuser
select pg_is_in_recovery();
```

### 命令参考
- 常用命令
```
\q # 退出
\du # 查看用户
\password db_user # 更改密码
\l # 查看数据库
\c db_name # 切换数据库
\d # 查看表
\d table_name # 查看表结构
\conninfo # 连接信息
```
- 切换为主节点
```
pg_ctl promote
```
- 数据导出导入
```
pg_dump -U postgres -f /path/to/file <db_name>
psql -d <db_name> -f /path/to/file postgres
```


### 参考链接
- [PostgreSQL高可用-主/热备集群](https://www.yangbajing.me/2017/09/20/postgresql%E9%AB%98%E5%8F%AF%E7%94%A8-%E4%B8%BB%E7%83%AD%E5%A4%87%E9%9B%86%E7%BE%A4/)
