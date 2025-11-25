# Genesis 服务配置指南

## 概述

Genesis 是一个用于开发和测试环境的服务编排工具，支持多种基础设施服务的单机和集群模式配置。通过 Docker Compose 文件，您可以快速启动和管理包括 NATS、Kafka、MySQL、Redis 等服务。

## 目录结构

```
.
├── etcd-cluster.yml           # ETCD 集群模式配置
├── etcd-standalone.yml        # ETCD Standalone 模式配置
├── kafka-cluster.yml          # Kafka 集群模式配置
├── kafka-standalone.yml       # Kafka Standalone 模式配置
├── mysql-standalone.yml       # MySQL 服务配置
├── nats-cluster.yml           # NATS 集群模式配置
├── nats-standalone.yml        # NATS Standalone 模式配置
├── postgresql-standalone.yml  # PostgreSQL 服务配置（支持vector扩展）
├── redis-standalone.yml       # Redis 服务配置
└── README.md                  # 当前文档
```

## 使用说明

### 启动服务

根据需要选择单机模式或集群模式，使用以下命令启动服务：

#### 单机模式

- 启动所有单机模式服务：

  ```bash
  docker compose -f etcd-standalone.yml -f kafka-standalone.yml -f nats-standalone.yml -f mysql-standalone.yml -f redis-standalone.yml -f postgresql-standalone.yml up -d
  ```

- 启动单个服务（例如 NATS）：

  ```bash
  docker compose -f nats-standalone.yml up -d
  ```

#### 集群模式

- 启动所有集群模式服务：

  ```bash
  docker compose -f etcd-cluster.yml -f kafka-cluster.yml -f nats-cluster.yml up -d
  ```

- 启动单个服务（例如 NATS 集群）：

  ```bash
  docker compose -f nats-cluster.yml up -d
  ```

### 查看服务状态

使用以下命令查看服务运行状态：

```bash
docker compose ps
```

### 停止服务

停止所有服务：

```bash
docker compose down
```

停止特定服务（例如 NATS）：

```bash
docker compose -f nats-standalone.yml down
```

停止 MySQL 服务：

```bash
docker compose -f mysql-standalone.yml down
```

停止 Redis 服务：

```bash
docker compose -f redis-standalone.yml down
```

停止 PostgreSQL 服务：

```bash
docker compose -f postgresql-standalone.yml down
```

## 服务配置详情

### NATS

#### Standalone 模式

- 配置文件：`nats-standalone.yml`
- 特点：
  - JetStream 支持流处理和持久化消息。
  - 客户端端口（4222）限制为本地访问，提升安全性。
  - 健康检查：通过 HTTP 接口 `/healthz` 确保服务正常运行。
- 启动命令：

  ```bash
  docker compose -f nats-standalone.yml up -d
  ```

#### 集群模式

- 配置文件：`nats-cluster.yml`
- 特点：
  - 三节点高可用集群，支持自动故障转移。
  - 仅主节点（nats-1）暴露客户端端口（4222）和监控端口（8222）。
  - 健康检查：所有节点通过 HTTP 接口 `/healthz` 确保服务正常运行。
- 启动命令：

  ```bash
  docker compose -f nats-cluster.yml up -d
  ```

### Kafka

#### Standalone 模式

- 配置文件：`kafka-standalone.yml`
- 特点：
  - 适合开发和测试环境。
  - 默认监听端口：9092。

#### 集群模式

- 配置文件：`kafka-cluster.yml`
- 特点：
  - 多节点集群，支持高可用性。
  - 配置了健康检查和广告监听器。

### ETCD

#### Standalone 模式

- 配置文件：`etcd-standalone.yml`
- 特点：
  - 轻量级键值存储，适合开发环境。

#### 集群模式

- 配置文件：`etcd-cluster.yml`
- 特点：
  - 高可用集群，支持分布式一致性。

### MySQL

- 配置文件：`mysql-standalone.yml`
- 特点：
  - MySQL 8.0 版本，稳定且功能完整。
  - 优化的内存配置，UTF8MB4字符集。
  - InnoDB缓冲池优化，支持性能调优。
  - 数据持久化存储。
- 启动命令：

  ```bash
  docker compose -f mysql-standalone.yml up -d
  ```

### Redis

- 配置文件：`redis-standalone.yml`
- 特点：
  - Redis 7.2 Alpine 版本，轻量级且高性能。
  - 内存优化配置，密码认证保护。
  - LRU淘汰策略，AOF持久化支持。
  - 适用于缓存和数据存储场景。
- 启动命令：

  ```bash
  docker compose -f redis-standalone.yml up -d
  ```

### PostgreSQL

- 配置文件：`postgresql-standalone.yml`
- 特点：
  - PostgreSQL 17 Alpine 版本，轻量级且高性能。
  - 内存优化配置，适合开发和测试环境。
  - 支持手动安装 [pgvector](https://github.com/pgvector/pgvector) 扩展，提供向量数据类型和相似度搜索功能。
  - 提供详细的 vector 扩展安装指导文档。
- 启动命令：

  ```bash
  docker compose -f postgresql-standalone.yml up -d
  ```

## 常用操作

### 查看日志

查看特定服务的日志（例如 NATS）：

```bash
docker compose -f nats-standalone.yml logs -f
```

### 访问监控界面

- NATS：
  - 单机模式：<http://localhost:8222>
  - 集群模式：<http://localhost:8222（主节点）>

### 数据库连接信息

- **MySQL**:
  - 主机：127.0.0.1
  - 端口：3306
  - 用户：root（或 ${MYSQL_USER}）
  - 连接命令：`docker exec -it genesis-mysql-standalone mysql -uroot -p`

- **Redis**:
  - 主机：127.0.0.1
  - 端口：6379
  - 连接命令：`docker exec -it genesis-redis-standalone redis-cli -a ${REDIS_PASSWORD}`

- **PostgreSQL**:
  - 主机：127.0.0.1
  - 端口：5432
  - 用户：postgres（或 ${POSTGRES_USER}）
  - 连接命令：`docker exec -it genesis-postgres psql -U postgres`

### 数据备份

- 备份 NATS 数据：

  ```bash
  docker run --rm -v nats-standalone-data:/data -v $(pwd):/backup alpine tar czf /backup/nats-data-backup.tar.gz /data
  ```

- 备份 MySQL 数据：

  ```bash
  docker run --rm -v mysql-data:/var/lib/mysql -v $(pwd):/backup alpine tar czf /backup/mysql-data-backup.tar.gz /var/lib/mysql
  ```

- 备份 Redis 数据：

  ```bash
  docker run --rm -v redis-data:/data -v $(pwd):/backup alpine tar czf /backup/redis-data-backup.tar.gz /data
  ```

- 备份 PostgreSQL 数据：

  ```bash
  docker run --rm -v postgres-data:/var/lib/postgresql/data -v $(pwd):/backup alpine tar czf /backup/postgres-data-backup.tar.gz /var/lib/postgresql/data
  ```

## 注意事项

- 确保所有外部网络（如 `genesis-net`）已创建：

  ```bash
  docker network create genesis-net
  ```

- 集群模式下，修改配置时需同步更新所有节点的路由信息。

## 性能调优

- 根据实际需求调整内存限制和存储配置。
- 监控 JetStream 存储使用情况，避免磁盘空间不足。
- 生产环境建议启用 TLS 加密，确保数据安全。
