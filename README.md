# RabbitMQ集群Docker开发环境(compose版本)
---
该项目本地以Compose方式部署开发环境所使用的模板

## 准备工作
### 1. 编辑`.env-dist`(非必须)
如果本地使用了多套该compose运行环境，则必须调整各自目录下该文件的`COMPOSE_PROJECT_NAME`参数值，以确保相互间唯一

### 2. 创建`docker-compose.yml`
#### 2.1 从模板文件复制生成`docker-compose.yml`
```bash
cp docker-compose.yml.template docker-compose.yml
```
#### 2.2 内容调整
替换相关访问账户与密码

---

## 常用命令
### Build
`make build`

### Start
`make start`

### Stop
`make stop`

### Status
`make status`

### Down
`make down`

---

## 其他
### 集群构建
初次构建并运行该项目后，需配置主从节点及queue镜像：
1. 进入rabbitmq_1容器并设置为主节点
```
docker exec -it [RABBITMQ_1_CONTAINER] bash
# 停止服务
rabbitmqctl stop_app
# 离开所在的集群
rabbitmqctl reset
# 启动服务
rabbitmqctl start_app
```

2. 进入rabbitmq_2容器并将该节点添加到集群中
```
docker exec -it [RABBITMQ_2_CONTAINER] bash
# 停止服务
rabbitmqctl stop_app
# 离开所在的集群
rabbitmqctl reset
# 加入集群
rabbitmqctl join_cluster rabbit@rabbitmq_1
# 启动服务
rabbitmqctl start_app
```

3. 进入rabbitmq_3容器并将该节点添加到集群中
```
docker exec -it [RABBITMQ_3_CONTAINER] bash
# 停止服务
rabbitmqctl stop_app
# 离开所在的集群
rabbitmqctl reset
# 加入集群,ram参数表示内存节点,默认磁盘节点(disc)
rabbitmqctl join_cluster --ram rabbit@rabbitmq_1
# 启动服务
rabbitmqctl start_app
```

4. 进入rabbitmq_1容器将所有queue都进行镜像以扩展为镜像模式的集群
```
docker exec -it [RABBITMQ_1_CONTAINER] bash
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all","ha-sync-mode":"automatic"}'

# 查看容器集群信息
rabbitmqctl cluster_status
```

### 额外说明
考虑到高可用性，推荐在集群里保持2个磁盘节点，这样一个挂了，另一个还可正常工作
```
#加入集群时设置节点为内存节点
rabbitmqctl join_cluster --ram rabbit@rabbitmq_1
#通过命令修改节点的类型
rabbitmqctl changeclusternode_type disc | ram
```
重启健康检查
```
rabbitmq-diagnostics check_running
```


> 该compose模板支持不同需求下开发环境的扩展，但仅限于在本地进行软件开发测试场景使用，不推荐在实际的生产环境下部署使用
