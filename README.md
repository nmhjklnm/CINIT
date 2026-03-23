# CINIT

为 Claude Code 配置一个信息丰富的状态栏。

安装完成后，终端底部会显示：

```
Claude Opus 4.6 | v1.0.71 | ~/my-project | ctx:23% 46.0k/200k
```

实时展示：当前模型、版本号、工作目录、上下文用量（带颜色预警）、速率限制等。

---

## 安装步骤

### 第一步：安装依赖 jq

状态栏脚本依赖 `jq` 解析 JSON。如果系统中没有，请安装：

- Debian / Ubuntu: `apt-get install -y jq`
- macOS: `brew install jq`
- Arch: `pacman -S jq`
- Alpine: `apk add jq`
- RHEL / CentOS: `yum install -y jq`

### 第二步：将 settings.json 复制到 ~/.claude/

把本项目中的 `settings.json` 复制到 `~/.claude/settings.json`。

如果已有该文件，先备份原文件，再将本项目中的 statusLine 配置合并进去。

### 第三步：将 statusline-command.sh 复制到 ~/.claude/

把本项目中的 `statusline-command.sh` 复制到 `~/.claude/statusline-command.sh`，并确保它有执行权限。

### 第四步：重启 Claude Code

退出当前会话，重新启动 Claude Code，状态栏即生效。

---

## 状态栏显示内容

| 信息 | 说明 | 颜色含义 |
|------|------|----------|
| 模型名称 | 当前使用的模型，如 Claude Opus 4.6 | 青色 |
| 版本号 | Claude Code 版本 | 灰色 |
| 会话名称 | 通过 `/rename` 设置的名称 | 紫色（仅设置后显示） |
| 工作目录 | 当前文件夹路径 | 蓝色 |
| 上下文用量 | 已用 token 占比 + 具体数值 | 绿色 < 50%，黄色 < 80%，红色 >= 80% |
| 速率限制 | 5 小时 / 7 天用量（Claude.ai 订阅用户） | 同上，超 50% 显示倒计时 |
| Vim 模式 | INSERT / NORMAL | 绿色 / 黄色（仅 vim 模式下显示） |
| Agent | `--agent` 启动时的名称 | 紫色 |
| Worktree | 工作树名称和分支 | 青色 |

---

## 自定义

编辑 `~/.claude/statusline-command.sh` 可调整显示内容、顺序或颜色。脚本通过 stdin 接收 JSON 格式的会话数据，用 `jq` 提取所需字段。

## License

MIT
