#!/bin/sh
set -e

# ==========================================
# 1. 检查必填环境变量
# ==========================================
if [ -z "$GARBLE_SEED" ]; then 
    echo "Error: GARBLE_SEED is required" >&2
    exit 1
fi

if [ -z "$GIT_TOKEN" ]; then 
    echo "Error: GIT_TOKEN is required" >&2
    exit 1
fi

# ==========================================
# 2. 配置 Git 凭证 (拉取私有库全靠它)
# ==========================================
echo ">> [1/4] 配置 Git 凭证..." >&2
git config --global url."https://${GIT_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"

# ==========================================
# 3. 实时拉取指定分支的干净代码
# ==========================================
echo ">> [2/4] 正在拉取代码 (分支/Tag: $TARGET_BRANCH)..." >&2
git clone --depth 1 -b "$TARGET_BRANCH" https://github.com/donknap/dpanel.git /src >&2

# 拉取 pro 模块
rm -rf /src/app/pro
git clone --depth 1 https://github.com/donknap/dpanel-pro.git /src/app/pro >&2

# ==========================================
# 4. 配置 100% 对齐的编译环境变量 (核心魔法)
# ==========================================
export CGO_ENABLED=1
export GOOS=linux
export GOARCH=amd64
export GOFLAGS="-trimpath"
export GOGARBLE="*"

# ==========================================
# 5. 下载依赖并执行反向推导
# ==========================================
echo ">> [3/4] 下载 Go Modules 依赖..." >&2
go mod download >&2

echo ">> [4/4] 环境就绪！正在进行 AST 语法树推导与日志还原..." >&2
# 读取外部传入的标准输入日志并进行 reverse
exec garble -seed="$GARBLE_SEED" reverse -tags "pe,w7_rangine_release,containers_image_openpgp" /src/*.go