# dev-utils 仓库说明

本仓库用于存放和维护各类可复用的服务配置文件、Docker Compose 模板、最佳实践脚本，方便快速搭建和管理开发/测试/生产环境。

---

## 目录结构概览

```
.
├── genesis/                # 各类基础服务（NATS/Kafka/ETCD/MySQL/Redis）单机与集群配置
│   ├── *.yml               # 各服务的 compose 文件
│   └── README.md           # 使用说明与运维指南
├── caddy-portainer/        # 反向代理（Caddy）与 Docker 控制台（Portainer）配置
│   ├── caddy.yml           # Caddy 反向代理配置
│   ├── dpanel.yml          # Portainer 控制台配置
│   └── README.md           # 说明文档
├── go-docker-templates/    # Go 项目多阶段构建 Dockerfile 与自动化脚本
│   ├── Dockerfile          # 最佳实践模板，支持 CGO/交叉编译
│   ├── build.sh            # 一键构建/打包/上传脚本
│   └── README.md           # 镜像选项与用法说明
└── README.md               # 仓库总览（当前文件）
```

---

## 推荐用途

- 快速复用和定制各类服务的 Docker Compose 配置
- 一键部署消息队列、数据库、反向代理等基础设施
- Go 项目镜像构建、交叉编译与自动上传
- 作为个人/团队的服务配置模板库

---

## 主要内容简介

### genesis/

- 包含 NATS、Kafka、ETCD、MySQL、Redis 等服务的单机与集群配置，支持健康检查、持久化、资源限制等最佳实践。

### caddy-portainer/

- 提供 Caddy 反向代理和 Portainer Docker 控制台的配置，便于统一管理和外部访问。

### go-docker-templates/

- Go 项目多阶段构建 Dockerfile，支持 CGO/交叉编译，附带自动化构建与上传脚本，镜像选项丰富。

---

## 适合场景

- 本地开发环境快速搭建
- 测试环境服务编排
- 生产环境基础设施模板
- 个人/团队服务配置复用

---

## 贡献与扩展

欢迎补充更多服务配置、脚本或最佳实践，建议保持目录结构清晰、注释完善，便于后续复用和维护。

---

## 参考

- [Docker 官方文档](https://docs.docker.com/)
- [Distroless 镜像](https://github.com/GoogleContainerTools/distroless)
- [Portainer 控制台](https://www.portainer.io/)
- [Caddy 反向代理](https://caddyserver.com/)
