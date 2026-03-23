# CINIT

每次开一个新的 Claude Code 环境，总要重复配一遍状态栏、权限这些东西。这个项目就是把这些配置存下来，下次让 Claude Code 自己照着做就行。

用法：把这个仓库链接丢给 Claude Code，让它按照 README 来配置就行。

---

## 配置步骤

### 第一步：安装 jq

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

## 配置完成后的效果

终端底部会显示一个状态栏：

```
Claude Opus 4.6 | v1.0.71 | ~/my-project | ctx:23% 46.0k/200k
```

包含：模型名称、版本号、工作目录、上下文用量（颜色随用量变化）、速率限制、会话名称、Vim 模式等信息。

## 自定义

编辑 `~/.claude/statusline-command.sh` 可调整显示内容、顺序或颜色。

## License

MIT
