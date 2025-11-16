# =========================
# Go 多阶段构建最佳实践模板
# =========================

# 构建参数：是否启用 CGO
ARG CGO_ENABLED=0

# 构建阶段
FROM golang:1.22 AS builder

# 安装依赖（仅当 CGO_ENABLED=1 时需要）
ARG CGO_ENABLED
RUN if [ "$CGO_ENABLED" = "1" ]; then \
      apt-get update && \
      apt-get install -y --no-install-recommends gcc libc6-dev libsqlite3-dev && \
      rm -rf /var/lib/apt/lists/*; \
    fi

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# 编译
ARG CGO_ENABLED
RUN if [ "$CGO_ENABLED" = "1" ]; then \
      CGO_ENABLED=1 GOOS=linux go build -ldflags="-s -w" -o main .; \
    else \
      CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o main .; \
    fi

# =========================
# 运行阶段（自动选择镜像）
# =========================

# 默认使用 distroless static（无 CGO），否则用 distroless base
ARG CGO_ENABLED
FROM gcr.io/distroless/static-debian12:nonroot AS static
FROM gcr.io/distroless/base-debian12:nonroot AS base

# 选择镜像
FROM static AS final
ARG CGO_ENABLED
COPY --from=builder /app/main /app/main
WORKDIR /app
USER nonroot:nonroot
ENTRYPOINT ["/app/main"]

FROM base AS final-cgo
ARG CGO_ENABLED
# 复制动态库（如有需要）
COPY --from=builder /usr/lib/x86_64-linux-gnu/libsqlite3.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /app/main /app/main
WORKDIR /app
USER nonroot:nonroot
ENTRYPOINT ["/app/main"]

# =========================
# 镜像选择逻辑
# =========================
# 构建命令举例：
# CGO_ENABLED=0
# docker build --build-arg CGO_ENABLED=0 --target final -t myapp:static .
#
# CGO_ENABLED=1
# docker build --build-arg CGO_ENABLED=1 --target final-cgo -t myapp:cgo .