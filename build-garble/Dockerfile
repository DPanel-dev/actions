FROM golang:1.25-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN go install mvdan.cc/garble@latest

WORKDIR /src

ENV GARBLE_SEED="" \
    GIT_TOKEN="" \
    TARGET_BRANCH="master" \
    APP_FAMILY="pe"

COPY ./docker-garble/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 接管容器启动入口
ENTRYPOINT ["/entrypoint.sh"]