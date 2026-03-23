#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Installing Claude Code configuration..."

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Install jq if not present
if ! command -v jq &>/dev/null; then
  echo "==> Installing jq..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y -qq jq
  elif command -v brew &>/dev/null; then
    brew install jq
  elif command -v yum &>/dev/null; then
    sudo yum install -y jq
  elif command -v apk &>/dev/null; then
    sudo apk add jq
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm jq
  else
    echo "ERROR: Could not install jq. Please install it manually."
    exit 1
  fi
fi

# Copy settings.json (backup existing if present)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "==> Backing up existing settings.json to settings.json.bak"
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
fi
cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"

# Copy statusline script
cp "$SCRIPT_DIR/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"

echo "==> Done! Configuration installed to $CLAUDE_DIR"
echo ""
echo "Files installed:"
echo "  $CLAUDE_DIR/settings.json"
echo "  $CLAUDE_DIR/statusline-command.sh"
echo ""
echo "Restart Claude Code to see the new status line."
