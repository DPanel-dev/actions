# DPanel Actions Hub

本仓库是 DPanel 生态的 Actions 集中运行中心。它不存放业务代码，而是专门负责执行整个项目组公用的自动化任务、资源托管以及构建环境的维护。

# Build Toolchain

手动运行 `Build and Push ToolChain` workflow 后，Windows 工具发布到 `build-toolchain` Release：

| 架构 | Docker CLI | Docker Compose |
| --- | --- | --- |
| AMD64 | `amd64-windows-docker.exe` | `amd64-windows-docker-compose.exe` |
| ARM64 | `arm64-windows-docker.exe` | `arm64-windows-docker-compose.exe` |

Docker CLI 两种架构统一使用 Skopeo 下载官方 `dockereng/cli-bin` 镜像，选择同一个最新稳定版本的 `windows/amd64`、`windows/arm64` 产物，再提取 `docker.exe`，无需自行编译或运行镜像。Docker Compose 两种架构均直接下载自同一个 GitHub 官方最新 Release，其中 ARM64 对应上游的 `aarch64` 资源。Windows ARM 指 ARM64，不提供 32 位 ARM 工具。

消费方应按目标架构选择对应文件；下载、校验或提取失败时，不执行该任务的 Release 上传。
