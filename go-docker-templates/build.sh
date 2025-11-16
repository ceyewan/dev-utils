#!/bin/bash
# Go 项目镜像构建与上传脚本
# 用法：
#   构建本地镜像: ./build.sh local [CGO_ENABLED]
#   构建 amd64镜像: ./build.sh amd64 [CGO_ENABLED]
#   构建并上传: ./build.sh push [CGO_ENABLED] [TAG]

set -e

DOCKERHUB_USER=ceyewan
IMAGE_NAME=myapp
PLATFORM=linux/amd64
CGO_ENABLED=${2:-0}
TAG=${3:-latest}

case "$1" in
  local)
    docker build \
      --build-arg CGO_ENABLED=$CGO_ENABLED \
      --target $( [ "$CGO_ENABLED" = "1" ] && echo final-cgo || echo final ) \
      -t $IMAGE_NAME:local .
    echo "本地镜像已构建：$IMAGE_NAME:local (CGO_ENABLED=$CGO_ENABLED)"
    ;;
  amd64)
    docker build --platform=$PLATFORM \
      --build-arg CGO_ENABLED=$CGO_ENABLED \
      --target $( [ "$CGO_ENABLED" = "1" ] && echo final-cgo || echo final ) \
      -t $IMAGE_NAME:amd64 .
    echo "amd64镜像已构建：$IMAGE_NAME:amd64 (CGO_ENABLED=$CGO_ENABLED)"
    ;;
  push)
    docker build --platform=$PLATFORM \
      --build-arg CGO_ENABLED=$CGO_ENABLED \
      --target $( [ "$CGO_ENABLED" = "1" ] && echo final-cgo || echo final ) \
      -t $DOCKERHUB_USER/$IMAGE_NAME:$TAG .
    docker push $DOCKERHUB_USER/$IMAGE_NAME:$TAG
    echo "已上传到 Docker Hub: $DOCKERHUB_USER/$IMAGE_NAME:$TAG"
    ;;
  *)
    echo "用法: $0 [local|amd64|push] [CGO_ENABLED] [TAG]"
    exit 1
    ;;
esac
