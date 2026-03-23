# CINIT

让你的 Claude Code 拥有一个信息丰富的状态栏。

安装完成后，你会在终端底部看到类似这样的状态栏：

```
Claude Opus 4.6 | v1.0.71 | ~/my-project | ctx:23% 46.0k/200k
```

它会实时显示：当前模型、版本号、工作目录、上下文用量（带颜色预警）、速率限制等信息。

---

## 开始安装

按照以下步骤，从零开始完成配置。

### 第一步：确认你已安装 Claude Code

如果还没有，请先前往 [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code) 完成安装。

在终端输入以下命令确认：

```bash
claude --version
```

如果能看到版本号，说明已经就绪。

### 第二步：下载本项目

打开终端，运行：

```bash
git clone https://github.com/nmhjklnm/CINIT.git
```

然后进入项目目录：

```bash
cd CINIT
```

### 第三步：运行安装脚本

```bash
bash install.sh
```

脚本会自动完成以下事情：
- 检测并安装 `jq`（状态栏脚本的依赖，支持 apt / brew / yum / apk / pacman）
- 如果你已有 `~/.claude/settings.json`，会先备份为 `settings.json.bak`
- 将配置文件复制到 `~/.claude/` 目录

### 第四步：重启 Claude Code

关闭当前的 Claude Code 会话，重新打开：

```bash
claude
```

你应该能在底部看到新的状态栏了。

---

## 状态栏显示了什么？

| 信息 | 说明 | 颜色含义 |
|------|------|----------|
| 模型名称 | 当前使用的模型，如 Claude Opus 4.6 | 青色 |
| 版本号 | Claude Code 的版本 | 灰色 |
| 会话名称 | 通过 `/rename` 设置的名称 | 紫色（仅设置后显示） |
| 工作目录 | 当前所在的文件夹路径 | 蓝色 |
| 上下文用量 | 已用 token 占比 + 具体数值 | 绿色 < 50%，黄色 < 80%，红色 >= 80% |
| 速率限制 | 5 小时 / 7 天的用量（Claude.ai 订阅用户） | 同上，超 50% 显示倒计时 |
| Vim 模式 | INSERT / NORMAL | 绿色 / 黄色（仅 vim 模式下显示） |
| Agent | 使用 `--agent` 启动时的 agent 名称 | 紫色 |
| Worktree | 工作树名称和分支 | 青色 |

---

## 想自定义？

状态栏由 `~/.claude/statusline-command.sh` 控制。你可以直接编辑这个文件来调整显示内容、顺序或颜色。

---

## 系统要求

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- bash
- jq
- Linux 或 macOS

## License

MIT
