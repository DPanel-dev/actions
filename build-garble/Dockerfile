FROM golang:1.25-alpine

# 安装编译所需的 C 依赖（针对 gpgme）
# 包含：git (下载), gcc/musl (编译), gpgme/assuan (链接)
RUN apk add --no-cache \
    git \
    gcc \
    musl-dev \
    ca-certificates

# 安装最新版 garble
RUN go install mvdan.cc/garble@latest

WORKDIR /src

CMD ["/bin/sh"]