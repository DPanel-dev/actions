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

# Appstore Repository Mirrors

独立工作流 [Mirror Appstore Repositories](.github/workflows/mirror-appstore.yaml) 将三个仓库的默认分支打包成仅含仓库文件的镜像。先推送 Docker Hub，最后统一使用 Skopeo 同步到阿里云；两个平台均使用 `dpanel/store` 仓库，以 tag 区分来源：

| 上游仓库 | Docker Hub | 阿里云 |
| --- | --- | --- |
| `qyg2297248353/appstore-dpanel` | `docker.io/dpanel/store:qyg2297248353` | `registry.cn-hangzhou.aliyuncs.com/dpanel/store:qyg2297248353` |
| `1Panel-dev/appstore` | `docker.io/dpanel/store:1panel` | `registry.cn-hangzhou.aliyuncs.com/dpanel/store:1panel` |
| `okxlin/appstore` | `docker.io/dpanel/store:okxlin` | `registry.cn-hangzhou.aliyuncs.com/dpanel/store:okxlin` |

- 手动运行：强制重新构建并发布三个仓库，不比较 SHA，不使用构建缓存。
- 定时运行：每 4 小时检查一次，UTC 时间为 00:17、04:17、08:17、12:17、16:17、20:17；上游 SHA 与 Docker Hub 对应来源 tag 的提交标签一致，且来源、根目录标签匹配时跳过构建，否则构建。GitHub 调度可能延迟。
- 修改 workflow 的 `schedule.cron` 即可调整频率，例如 `17 */6 * * *` 为每 6 小时，`17 0 * * *` 为每天一次。
- 镜像尚未发布或远端版本读取失败时，保留错误日志并警告，再尝试构建和推送；不会将读取失败当成“没有变化”。上游查询失败则直接报错。
- 最后执行 Skopeo 同步，使用 `--all --preserve-digests --retry-times 3` 保留镜像摘要；即使本次跳过构建也执行同步，Skopeo 复用目标已有层。Docker Hub 发布成功而阿里云同步失败时，下次定时运行可以只补同步，无需重新构建。

复用仓库 Secrets `DOCKER_USERNAME`、`DOCKER_PASSWORD`、`ALIYUN_USERNAME`、`ALIYUN_PASSWORD`，账号需要对各自的 `dpanel/store` 镜像仓库具备读取和推送权限；按平台要求提前创建对应仓库。workflow 合入默认分支后才会启用定时触发。

每次先确定上游 SHA，再获取该提交，避免检查后分支更新导致标签与内容不一致。每个来源只使用表中的固定 tag，提交 SHA 保存在镜像的 `com.dpanel.revision` label 中，不生成额外的 SHA tag。Docker Hub 发布后，Skopeo 将该固定 tag 同步到阿里云的同名 tag。定时比较读取 Docker Hub 镜像的 `com.dpanel.revision` label，不另存成功标记。三个仓库独立执行，单个失败不取消其他仓库；工作流之间串行运行，避免交叉覆盖来源 tag。

镜像沿用 plugin 的 `scratch` 空镜像与根目录布局，例如仓库的 `apps/example/docker-compose.yml` 在镜像内仍为 `/apps/example/docker-compose.yml`。按 Git 跟踪清单打包检出文件，保留隐藏配置、文档、许可证和脚本，排除 `.git`、未跟踪文件及打包临时文件；归档不受 `export-ignore` / `export-subst` 影响。不执行上游的 Dockerfile 或脚本，不递归拉取子模块，不下载 Git LFS 对象（保留指针文件）。一致性以同一提交、相同检出方式的仓库文件为准，不包含 Git 元数据、文件属主和时间戳。

这是用于提取文件的 `linux/amd64` 数据镜像，无启动命令。镜像包含 `com.dpanel.revision`、`com.dpanel.plugin.source` 和 `com.dpanel.plugin.root=/` 标签。服务端商店的镜像同步接入与解包行为需单独验证，发布成功不代表该消费链路已经可用。
