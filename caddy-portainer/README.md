# Docker Compose 配置指南

## 概述
本目录包含用于搭建 Docker 服务管理平台的 Docker Compose 配置文件。通过以下配置，您可以快速部署一个反向代理（Caddy）和一个 Docker 控制台（Portainer），实现对应用和 Genesis 服务的便捷管理。

## 配置文件说明

### 目录结构
```
.
├── caddy.yml       # Caddy 反向代理配置
├── dpanel.yml      # Docker 控制台（Portainer）配置
```

### Caddy 反向代理
- **配置文件**: `caddy.yml`
- **功能**:
  - 提供反向代理功能，将外部请求转发到内部服务。
  - 支持 HTTPS 自动化配置，提升安全性。
  - 可通过简单的配置文件管理多个域名和服务。
- **启动命令**:
  ```bash
  docker compose -f caddy.yml up -d
  ```
- **示例用途**:
  - 将 `https://example.com` 转发到内部的 NATS 服务。
  - 将 `https://admin.example.com` 转发到 Docker 控制台。

### Docker 控制台（Portainer）
- **配置文件**: `dpanel.yml`
- **功能**:
  - 提供基于 Web 的 Docker 管理界面。
  - 支持容器、网络、卷等资源的可视化管理。
  - 适合快速部署和管理 Genesis 服务或其他应用。
- **启动命令**:
  ```bash
  docker compose -f dpanel.yml up -d
  ```
- **示例用途**:
  - 查看 Genesis 服务的运行状态。
  - 管理和部署其他 Docker 应用。

## 使用说明

### 启动服务
- 启动 Caddy 和 Docker 控制台：
  ```bash
  docker compose -f caddy.yml -f dpanel.yml up -d
  ```

### 查看服务状态
- 检查服务是否正常运行：
  ```bash
  docker compose ps
  ```

### 停止服务
- 停止所有服务：
  ```bash
  docker compose down
  ```

### 查看日志
- 查看 Caddy 日志：
  ```bash
  docker compose -f caddy.yml logs -f
  ```
- 查看 Docker 控制台日志：
  ```bash
  docker compose -f dpanel.yml logs -f
  ```

## 注意事项
- 确保已创建外部网络（如 `genesis-net`）：
  ```bash
  docker network create genesis-net
  ```
- 配置 Caddy 时，请确保域名解析正确指向服务器。
- 部署 Docker 控制台时，建议启用身份验证以确保安全性。

## 示例场景
- **场景 1**: 部署 Genesis 服务
  - 使用 Docker 控制台快速启动 Genesis 的单机或集群模式服务。
  - 通过 Caddy 提供外部访问入口。
- **场景 2**: 管理其他应用
  - 使用 Docker 控制台管理其他容器化应用。
  - 通过 Caddy 配置 HTTPS 和反向代理。

## 性能调优
- 根据实际需求调整 Caddy 和 Docker 控制台的资源限制。
- 定期清理未使用的容器、网络和卷，释放系统资源。

通过以上配置，您可以快速搭建一个基于 Docker 的服务器管理平台，方便地部署和管理应用。