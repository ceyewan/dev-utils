# Go Docker 镜像模板说明

本目录包含 Go 项目多阶段构建的最佳实践 Dockerfile 模板和自动化脚本，支持本地/交叉编译、打包与上传，方便后续自定义。

---

## 文件结构
```
go-docker-templates/
├── Dockerfile      # 推荐模板，支持 CGO 动态切换
├── build.sh        # 一键构建/打包/上传脚本
├── README.md       # 镜像说明与用法
```

---

## 镜像选项一览

### 一阶段镜像（构建阶段）
| 镜像名称                | 体积   | libc类型 | 包含内容           | 适用场景           |
|------------------------|--------|----------|--------------------|--------------------|
| golang:1.22            | ~1.1GB | glibc    | 完整Go工具链、apt  | 生产/开发/CGO      |
| golang:1.22-alpine     | ~350MB | musl     | Go工具链、apk      | 轻量/无CGO/调试     |

- **glibc**（Debian/Ubuntu）：兼容性强，适合有 CGO 需求或依赖第三方库。
- **musl**（Alpine）：体积小，适合纯静态编译或调试，但部分库兼容性有限。

### 二阶段镜像（运行阶段）
| 镜像名称                              | 体积   | libc类型 | 包含内容           | 适用场景           |
|---------------------------------------|--------|----------|--------------------|--------------------|
| gcr.io/distroless/static-debian12     | ~2MB   | glibc    | CA证书、时区、非root| 静态编译/无CGO     |
| gcr.io/distroless/base-debian12       | ~21MB  | glibc    | glibc+openssl+CA   | CGO/动态链接       |
| gcr.io/distroless/base-nossl-debian12 | ~15MB  | glibc    | glibc基础系统（无SSL）| 无SSL动态链接      |
| gcr.io/distroless/cc-debian12         | ~23MB  | glibc    | C++标准库          | 需C++依赖          |
| alpine:3.19                          | ~7MB   | musl     | shell、包管理器    | 调试/特殊需求      |
| debian:bookworm-slim                 | ~77MB  | glibc    | 完整系统           | 复杂依赖/调试      |

- **distroless static**：最小体积，安全性高，适合无 CGO 的静态编译。
- **distroless base**：支持 glibc 动态链接，适合有 CGO 需求。
- **alpine/debian**：调试或特殊依赖场景可选。
- **debug 标签**：如 `:debug`，包含 shell，便于容器调试。

---

## 兼容性与调试说明
- **glibc vs musl**：glibc 兼容性更好，musl 体积更小但部分库不兼容。
- **debug 镜像**：开发阶段可用 `distroless:debug`，生产建议用非 debug 镜像。
- **非 root 用户**：推荐用 `:nonroot` 标签，提升安全性。

---

## 构建与上传脚本

### build.sh 用法
```bash
# 构建本地镜像（当前架构）
./build.sh local [CGO_ENABLED]

# 构建 amd64 镜像（交叉编译）
./build.sh amd64 [CGO_ENABLED]

# 构建并上传到 Docker Hub
./build.sh push [CGO_ENABLED] [TAG]
```
- `CGO_ENABLED` 默认为 0，可选 1。
- `TAG` 默认为 latest。
- 镜像名为 myapp，可在脚本中自定义。

---

## 主要自定义点
- 构建参数 `CGO_ENABLED` 控制是否启用 CGO。
- 可根据实际需求修改运行阶段基础镜像（如 alpine、debian）。
- 需要其他动态库时，可在 Dockerfile 中补充 `COPY` 步骤。
- 镜像名和 Docker Hub 用户名可在脚本中自定义。

---

## 进阶说明
- 多阶段构建可灵活扩展，支持更多依赖和自定义需求。
- 推荐以非 root 用户运行，提升安全性。
- 镜像标签建议显式指定版本，避免 `latest` 带来的不确定性。
- 生产环境优先使用 distroless 镜像，调试阶段可用 debug 标签。
- glibc 环境适合企业级和第三方依赖，musl 适合极致精简。

---

## 参考
- [Distroless 官方文档](https://github.com/GoogleContainerTools/distroless)
- [Go Docker 官方文档](https://hub.docker.com/_/golang)
- [Docker 多阶段构建最佳实践](https://docs.docker.com/build/building/multi-stage/)
