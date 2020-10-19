# mysql

### 运行方式
- 一主两从，通过绑定节点挂载本地硬盘方式运行
- 节点之间通过宿主机IP进行通信，不再单独绑定服务
- 配置清单没有采用StatefulSet方式，直接采用Pod部署以方便单节点修改

### 如何使用
- 创建命名空间
```
kubectl create ns svr-app
```
- 导入配置文件
```
kubectl create configmap mysql --from-file=master78.cnf --from-file=slave79.cnf --from-file=slave80.cnf -n svr-app
```
- 应用配置清单
```
kubectl create -f mysql.yaml
```
- 主节点授权
```
CREATE USER 'replicate'@'*' IDENTIFIED BY 'slave-password';
GRANT REPLICATION SLAVE ON *.* TO 'replicate'@'*';
flush privileges;
SHOW MASTER STATUS;
```
- 从节点同步
```
CHANGE MASTER TO
  MASTER_HOST='192.168.2.78',
  MASTER_USER='replicate',
  MASTER_PASSWORD='slave-password',
  MASTER_LOG_FILE='mysql-bin.000003',
  MASTER_LOG_POS=73;
start slave;
show slave status\G;
```

### 从库初始化-强一致性
- 主库禁止写入
```
flush tables with read lock;
```
- 主库导出数据
```
mysqldump -uroot -pmysql --all-databases > mysql.sql;
```
- 从库导入数据
```
stop slave;
source mysql.sql;
show master status;
CHANGE MASTER TO ...
start slave;
show slave status\G;
```
- 主库恢复写入
```
unlock tables;
```

### 命令参考
- 状态查看
```
show master status;
show binlog events;
show binlog events in 'mysql-bin.000002';
```
- 清理日志
```
reset master;
reset slave;
purge master logs before '2012-03-30 17:20:00';
purge master logs to 'mysql-bin.000002';
```
- 刷新日志
```
flush logs;
show binary logs;
```

### 参考链接
- [MySQL主从复制(Master-Slave)实践](https://www.cnblogs.com/gl-developer/p/6170423.html)
