FROM golang:1.25-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN go install mvdan.cc/garble@latest
# --- 暴力破案开始：打印所有传入 Docker 的文件 ---
# 我们在根目录下找 entrypoint.sh 到底在哪
RUN echo "--- 打印当前构建上下文的文件树 ---" && \
    find . -maxdepth 3 -not -path '*/.*'
# --- 暴力破案结束 ---
RUN ls -al

WORKDIR /src

ENV GARBLE_SEED="" \
    GIT_TOKEN="" \
    TARGET_BRANCH="master" \
    APP_FAMILY="pe"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 接管容器启动入口
ENTRYPOINT ["/entrypoint.sh"]