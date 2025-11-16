# Genesis 基础设施库

Docker Compose 基础设施服务配置集合。

## 规范

### 命名规范
- **容器名称**: `genesis-{service}` 或 `genesis-{service}{node}`
- **主机名**: `{service}` 或 `{service}{node}`
- **数据卷**: `{service}-data` 或 `{service}-data-{node}`
- **网络**: 统一使用 `genesis-net` 外部网络

### 配置规范
- 使用 Docker Compose 规范格式，不声明 version
- 统一重启策略: `restart: unless-stopped`
- 统一日志配置: `max-size: "5m"`, `max-file: "2"`
- 端口映射限制为 `127.0.0.1` 访问
- 集群模式仅第一个节点暴露端口到宿主机

### 环境变量
复制 `.env.example` 为 `.env` 并配置相应参数。

## 服务列表

| 服务 | 单机版 | 集群版 | 描述 |
|------|--------|--------|------|
| MySQL | mysql.yml | - | 关系型数据库 |
| Redis | redis.yml | - | 内存数据库 |
| ETCD | etcd-single.yml | etcd-cluster.yml | 分布式键值存储 |
| Kafka | kafka-single.yml | kafka-cluster.yml | 消息队列 |
| NATS | nats-single.yml | nats-cluster.yml | 消息系统 |

## 使用方法

### 创建网络
```bash
docker network create genesis-net
```

### 启动服务
```bash
docker compose -f mysql.yml up -d
```

### 停止服务
```bash
docker compose -f mysql.yml down
```

## 注意事项

- 所有服务都需要 `genesis-net` 网络存在
- 集群版服务首次启动需要等待初始化完成
- 数据持久化通过 Docker 卷实现，请定期备份
- 生产环境请修改默认密码和配置参数