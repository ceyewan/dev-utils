# Genesis 服务配置指南

## 概述

Genesis 是一个用于开发和测试环境的服务编排工具，支持多种基础设施服务的单机和集群模式配置。通过 Docker Compose 文件，您可以快速启动和管理包括 NATS、Kafka、MySQL、Redis 等服务。

## 目录结构

```
.
├── etcd-cluster.yml       # ETCD 集群模式配置
├── etcd-single.yml        # ETCD 单机模式配置
├── kafka-cluster.yml      # Kafka 集群模式配置
├── kafka-single.yml       # Kafka 单机模式配置
├── mysql.yml              # MySQL 服务配置
├── nats-cluster.yml       # NATS 集群模式配置
├── nats-single.yml        # NATS 单机模式配置
├── redis.yml              # Redis 服务配置
└── README.md              # 当前文档
```

## 使用说明

### 启动服务

根据需要选择单机模式或集群模式，使用以下命令启动服务：

#### 单机模式

- 启动所有单机模式服务：

  ```bash
  docker compose -f etcd-single.yml -f kafka-single.yml -f nats-single.yml up -d
  ```

- 启动单个服务（例如 NATS）：

  ```bash
  docker compose -f nats-single.yml up -d
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
docker compose -f nats-single.yml down
```

## 服务配置详情

### NATS

#### 单机模式

- 配置文件：`nats-single.yml`
- 特点：
  - JetStream 支持流处理和持久化消息。
  - 客户端端口（4222）限制为本地访问，提升安全性。
  - 健康检查：通过 HTTP 接口 `/healthz` 确保服务正常运行。
- 启动命令：

  ```bash
  docker compose -f nats-single.yml up -d
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

#### 单机模式

- 配置文件：`kafka-single.yml`
- 特点：
  - 适合开发和测试环境。
  - 默认监听端口：9092。

#### 集群模式

- 配置文件：`kafka-cluster.yml`
- 特点：
  - 多节点集群，支持高可用性。
  - 配置了健康检查和广告监听器。

### ETCD

#### 单机模式

- 配置文件：`etcd-single.yml`
- 特点：
  - 轻量级键值存储，适合开发环境。

#### 集群模式

- 配置文件：`etcd-cluster.yml`
- 特点：
  - 高可用集群，支持分布式一致性。

### MySQL

- 配置文件：`mysql.yml`
- 特点：
  - 默认用户：`root`。
  - 数据持久化存储。

### Redis

- 配置文件：`redis.yml`
- 特点：
  - 内存数据存储，支持持久化。

## 常用操作

### 查看日志

查看特定服务的日志（例如 NATS）：

```bash
docker compose -f nats-single.yml logs -f
```

### 访问监控界面

- NATS：
  - 单机模式：<http://localhost:8222>
  - 集群模式：<http://localhost:8222（主节点）>

### 数据备份

- 备份 NATS 数据：

  ```bash
  docker run --rm -v nats-single-data:/data -v $(pwd):/backup alpine tar czf /backup/nats-data-backup.tar.gz /data
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
