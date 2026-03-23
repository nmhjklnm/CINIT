# install-claude-code

One-command setup for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with a rich status line.

## What you get

A color-coded status line showing real-time session info:

```
Claude Opus 4.6 | v1.0.71 | ~/my-project | ctx:23% 46.0k/200k
```

| Segment | Description | Color |
|---------|-------------|-------|
| **Model** | Active model name | Cyan |
| **Version** | Claude Code version | Dim |
| **Session** | Session name (if set via `/rename`) | Magenta |
| **Directory** | Current working directory (`~` shorthand) | Blue |
| **Context** | Token usage — percentage + used/total | Green < 50%, Yellow < 80%, Red >= 80% |
| **Rate limits** | 5-hour and 7-day usage (Claude.ai subscribers) | Green/Yellow/Red + countdown timer |
| **Vim mode** | INSERT/NORMAL (when vim mode is active) | Green/Yellow |
| **Agent** | Agent name (when using `--agent`) | Magenta |
| **Worktree** | Worktree name and branch | Cyan |

## Quick install

```bash
git clone https://github.com/nmhjklnm/install-claude-code.git
cd install-claude-code
bash install.sh
```

The install script will:
1. Install `jq` if not already present (supports apt, brew, yum, apk, pacman)
2. Back up your existing `~/.claude/settings.json` if one exists
3. Copy `settings.json` and `statusline-command.sh` to `~/.claude/`

## Manual install

If you prefer to do it yourself:

```bash
mkdir -p ~/.claude
cp settings.json ~/.claude/settings.json
cp statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

Make sure `jq` is installed:

```bash
# Debian/Ubuntu
sudo apt-get install jq

# macOS
brew install jq

# Arch
sudo pacman -S jq
```

## Files

| File | Destination | Purpose |
|------|-------------|---------|
| `settings.json` | `~/.claude/settings.json` | Claude Code configuration (permissions, status line) |
| `statusline-command.sh` | `~/.claude/statusline-command.sh` | Status line rendering script |
| `install.sh` | (run once) | Automated installer |

## Customization

Edit `~/.claude/statusline-command.sh` to add, remove, or reorder segments. The script receives JSON on stdin with all available session data. Use `jq` to extract any field you need.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- `bash` and `jq`
- Linux or macOS

## License

MIT
